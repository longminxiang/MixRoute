//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>

@implementation MixRouteViewControllerParams
@synthesize style = _style;
@synthesize tabRoutes = _tabRoutes;
@synthesize navigationControllerClass = _navigationControllerClass;
@synthesize item = _item;
@synthesize navigationItem = _navigationItem;
@synthesize tabBarItem = _tabBarItem;

@end

@implementation UIViewController (MixViewController)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mixE_hook_class_swizzleMethodAndStore(self, @selector(navigationItem), @selector(_mix_vc_route_navigationItem));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(tabBarItem), @selector(_mix_vc_route_tabBarItem));
    });
}

- (MixRoute *)mix_route
{
    if (![self conformsToProtocol:@protocol(MixRouteViewController)]) return nil;
    id obj = objc_getAssociatedObject(self, _cmd);
    return obj;
}

- (void)setMix_route:(MixRoute *)mix_route
{
    if (![self conformsToProtocol:@protocol(MixRouteViewController)]) return;
    objc_setAssociatedObject(self, @selector(mix_route), mix_route, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UINavigationItem *)_mix_vc_route_navigationItem
{
    UINavigationItem *item;
    if ([self conformsToProtocol:@protocol(MixRouteViewController)]) {
        UINavigationItem *aitem = ((id<MixRouteViewControllerParams>)self.mix_route.params).navigationItem;
        if (aitem) item = aitem;
        else aitem = item = [self _mix_vc_route_navigationItem];
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
        UITabBarItem *aitem = ((id<MixRouteViewControllerParams>)self.mix_route.params).tabBarItem;
        if (aitem) item = aitem;
        else aitem = item = [self _mix_vc_route_tabBarItem];
    }
    else {
        item = [self _mix_vc_route_tabBarItem];
    }
    return item;
}

@end


@interface MixViewControllerRouteModuleRegister ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixViewControllerRouteModuleBlock> *blockDictionary;

@end

@implementation MixViewControllerRouteModuleRegister

+ (instancetype)shared
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (void)add:(MixRouteName)name block:(MixViewControllerRouteModuleBlock)block
{
    if (!name || !block) return;
    if (!_blockDictionary) _blockDictionary = [NSMutableDictionary new];
    self.blockDictionary[name] = block;
}

@end

@interface MixRouteViewControllerManager : NSObject<MixRouteModule>

@end

@implementation MixRouteViewControllerManager

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    unsigned int count;
    Class *allClasse = objc_copyClassList(&count);
    for (int i = 0; i < count; i++) {
        Class class = allClasse[i];
        if (class_conformsToProtocol(class, @protocol(MixViewControllerRouteModule))) {
            [class mixViewControllerRouteRegisterModule:[MixViewControllerRouteModuleRegister shared]];
        }
    }
    free(allClasse);
    [[MixViewControllerRouteModuleRegister shared].blockDictionary enumerateKeysAndObjectsUsingBlock:^(MixRouteName name, MixViewControllerRouteModuleBlock block, BOOL *stop) {
        [reg add:name block:^(MixRoute *route) {
            [self fire:route block:block];
        }];
    }];

    [reg add:MixRouteNameBack block:^(MixRoute *route) {
        UIViewController<MixRouteViewController> *topVC = (UIViewController<MixRouteViewController> *)[UIViewControllerMixExtention topViewController];
        MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, topVC.mix_route.params, topParams);
        MIX_ROUTE_PARAMS(MixRouteBackParams, route.params, params);

        if (topParams.style == MixViewControllerRouteStylePresent) {
            [MixRouteManager lock:route.queue];
            [topVC dismissViewControllerAnimated:!params.noAnimated completion:^{
                [MixRouteManager unlock:route.queue];
            }];
        }
        else {
            int count = (int)topVC.navigationController.viewControllers.count;
            if (count <= 1) return;
            NSInteger delta = params.toRoot ? count - 1 : MIN(MAX(params.delta, 1), count - 1);
            UIViewController *xvc = topVC.navigationController.viewControllers[count - delta - 1];
            [MixRouteManager lock:route.queue];
            [topVC.navigationController.mixE popToViewController:xvc animated:!params.noAnimated completion:^{
                [MixRouteManager unlock:route.queue];
            }];
        }
    }];
}

+ (void)fire:(MixRoute *)route block:(MixViewControllerRouteModuleBlock)block
{
    MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, route.params, params);

    UIViewController<MixRouteViewController> *vc = block(route);
    if (!vc) {
        return;
    }
    [vc.mixE setItem:params.item];
    vc.mix_route = route;

    if ([vc isKindOfClass:[UITabBarController class]] && params.tabRoutes.count) {

        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < params.tabRoutes.count; i++) {
            MixRoute *aroute = params.tabRoutes[i];
            MixViewControllerRouteModuleBlock ablock = [MixViewControllerRouteModuleRegister shared].blockDictionary[aroute.name];
            UIViewController<MixRouteViewController> *avc = ablock(aroute);
            avc.mix_route = aroute;
            MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, aroute.params, aparams);
            Class navClass = [self navigationControllerClassWithRouteParams:aparams otherParams:params];
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:avc];
            [navs addObject:nav];
        }
        ((UITabBarController *)vc).viewControllers = navs;
    }

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (params.style == MixViewControllerRouteStyleRoot || !keyWindow.rootViewController) {
        Class navClass = [self navigationControllerClassWithRouteParams:params otherParams:nil];
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        keyWindow.rootViewController = nav;
    }
    else if (params.style == MixViewControllerRouteStylePresent) {
        Class navClass = [self navigationControllerClassWithRouteParams:params otherParams:nil];
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        [MixRouteManager lock:route.queue];
        [[UIViewControllerMixExtention topViewController] presentViewController:nav animated:YES completion:^{
            [MixRouteManager unlock:route.queue];
        }];
    }
    else {
        [MixRouteManager lock:route.queue];
        [[UIViewControllerMixExtention topViewController].navigationController.mixE pushViewController:vc animated:YES completion:^{
            [MixRouteManager unlock:route.queue];
        }];
    }
}

+ (Class)navigationControllerClassWithRouteParams:(id<MixRouteViewControllerParams>)params otherParams:(id<MixRouteViewControllerParams>)aparams
{
    if ([params.navigationControllerClass isSubclassOfClass:[UINavigationController class]]) return params.navigationControllerClass;
    if ([aparams.navigationControllerClass isSubclassOfClass:[UINavigationController class]]) return aparams.navigationControllerClass;
    return [UINavigationController class];
}

@end

@implementation MixRouteBackParams

@end
