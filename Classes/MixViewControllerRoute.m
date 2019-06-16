//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>
#import "MixRouteManager.h"

@implementation UIViewController (MixViewController)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mixE_hook_class_swizzleMethodAndStore(self, @selector(navigationItem), @selector(_mix_vc_route_navigationItem));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(tabBarItem), @selector(_mix_vc_route_tabBarItem));
    });
}

- (id<MixRoute>)mix_route
{
    if (![self conformsToProtocol:@protocol(MixRouteViewController)]) return nil;
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setMix_route:(id<MixRoute>)mix_route
{
    if (![self conformsToProtocol:@protocol(MixRouteViewController)]) return;
    objc_setAssociatedObject(self, @selector(mix_route), mix_route, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem *)_mix_vc_route_navigationItem
{
    UINavigationItem *item;
    if ([self conformsToProtocol:@protocol(MixRouteViewController)]) {
        id<MixRouteViewControllerParams> params = (id<MixRouteViewControllerParams>)self.mix_route.routeParams;
        if ([params respondsToSelector:@selector(navigationItem)] && params.navigationItem) {
            item = params.navigationItem;
        }
        else {
            item = [self _mix_vc_route_navigationItem];
        }
    }
    else {
        item = [self _mix_vc_route_navigationItem];
    }
    return item;
}

- (UITabBarItem *)_mix_vc_route_tabBarItem
{
    UITabBarItem *item;
    if ([self conformsToProtocol:@protocol(MixRouteViewController)]) {
        id<MixRouteViewControllerParams> params = (id<MixRouteViewControllerParams>)self.mix_route.routeParams;
        if ([params respondsToSelector:@selector(tabBarItem)] && params.tabBarItem) {
            item = params.tabBarItem;
        }
        else {
            item = [self _mix_vc_route_tabBarItem];
        }
    }
    else {
        item = [self _mix_vc_route_tabBarItem];
    }
    return item;
}

@end

@interface MixRouteViewControllerManager : NSObject<MixRouteModule>

+ (void)fire:(id<MixRoute>)route block:(MixViewControllerRouteModuleBlock)block;

@end

@implementation MixRouteModuleRegister (ViewControllerRoute)

- (void)add:(MixRouteName)name vcBlock:(MixViewControllerRouteModuleBlock)block
{
    [self add:name block:^(id<MixRoute> route) {
        [MixRouteViewControllerManager fire:route block:block];
    }];
}

@end

@implementation MixRouteViewControllerManager

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameBack block:^(id<MixRoute> route) {
        UIViewController<MixRouteViewController> *topVC = (UIViewController<MixRouteViewController> *)[UIViewControllerMixExtention topViewController];
        id<MixRouteViewControllerParams> topParams = (id<MixRouteViewControllerParams>)topVC.mix_route.routeParams;
        MixRouteBackParams *params = (MixRouteBackParams *)route.routeParams;
        
        if (topParams.style == MixViewControllerRouteStylePresent) {
            [MixRouteManager lock:route.routeQueue];
            [topVC dismissViewControllerAnimated:!params.noAnimated completion:^{
                [MixRouteManager unlock:route.routeQueue];
            }];
        }
        else {
            int count = (int)topVC.navigationController.viewControllers.count;
            if (count <= 1) return;
            NSInteger delta = params.toRoot ? count - 1 : MIN(MAX(params.delta, 1), count - 1);
            UIViewController *xvc = topVC.navigationController.viewControllers[count - delta - 1];
            [MixRouteManager lock:route.routeQueue];
            [topVC.navigationController.mixE popToViewController:xvc animated:!params.noAnimated completion:^{
                [MixRouteManager unlock:route.routeQueue];
            }];
        }
    }];
}

+ (NSMutableArray<NSArray *> *)tempVCs
{
    static NSMutableArray *array;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSMutableArray new];
    });
    return array;
}


+ (void)fire:(id<MixRoute>)route block:(MixViewControllerRouteModuleBlock)block
{
    id<MixRouteViewControllerParams> params = (id<MixRouteViewControllerParams>)route.routeParams;
    UIViewController<MixRouteViewController> *vc = block(route);
    if (!vc) {
        return;
    }
    MixViewControllerItem *item = [params respondsToSelector:@selector(item)] && params.item ? params.item : [MixViewControllerItem new];
    [vc.mixE setItem:item];
    vc.mix_route = route;
    
    if ([vc isKindOfClass:[UITabBarController class]] && [params respondsToSelector:@selector(tabRoutes)] && params.tabRoutes.count) {
        
        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < params.tabRoutes.count; i++) {
            id<MixRoute> aroute = params.tabRoutes[i];
            id<MixRouteViewControllerParams> aparams = (id<MixRouteViewControllerParams>)aroute.routeParams;
            MixRouteModuleBlock ablock = [MixRouteModuleRegister blocks][aroute.routeName];
            aparams.style = MixViewControllerRouteStyleSubTab;
            ablock(aroute);
            
            UIViewController<MixRouteViewController> *avc;
            for (NSArray *array in [self tempVCs]) {
                if (array[0] == aroute) {
                    avc = array[1];
                    [[self tempVCs] removeObject:array];
                    break;
                }
            }
            if (!avc) continue;
            Class navClass = [self navigationControllerClassWithRouteParams:aparams otherParams:params];
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:avc];
            [navs addObject:nav];
        }
        ((UITabBarController *)vc).viewControllers = navs;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (params.style == MixViewControllerRouteStyleSubTab) {
        [[self tempVCs] addObject:@[route, vc]];
    }
    else if (params.style == MixViewControllerRouteStyleRoot || !keyWindow.rootViewController) {
        Class navClass = [self navigationControllerClassWithRouteParams:params otherParams:nil];
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        keyWindow.rootViewController = nav;
    }
    else if (params.style == MixViewControllerRouteStylePresent) {
        Class navClass = [self navigationControllerClassWithRouteParams:params otherParams:nil];
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        [MixRouteManager lock:route.routeQueue];
        [[UIViewControllerMixExtention topViewController] presentViewController:nav animated:YES completion:^{
            [MixRouteManager unlock:route.routeQueue];
        }];
    }
    else {
        [MixRouteManager lock:route.routeQueue];
        [[UIViewControllerMixExtention topViewController].navigationController.mixE pushViewController:vc animated:YES completion:^{
            [MixRouteManager unlock:route.routeQueue];
        }];
    }
}

+ (Class)navigationControllerClassWithRouteParams:(id<MixRouteViewControllerParams>)params otherParams:(id<MixRouteViewControllerParams>)aparams
{
    if ([params respondsToSelector:@selector(navigationControllerClass)] &&
        [params.navigationControllerClass isSubclassOfClass:[UINavigationController class]]) {
        return params.navigationControllerClass;
    }
    if ([aparams respondsToSelector:@selector(navigationControllerClass)] &&
        [aparams.navigationControllerClass isSubclassOfClass:[UINavigationController class]]) {
        return aparams.navigationControllerClass;
    }
    return [UINavigationController class];
}

@end

@implementation MixRouteBackParams

@end
