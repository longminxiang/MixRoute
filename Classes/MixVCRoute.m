//
//  MixVCRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixVCRoute.h"

MixRouteName const MixRouteNameBack = @"MixRouteNameBack";
MixRouteName const MixRouteNameBackToRoot = @"MixRouteNameBackToRoot";

@implementation MixVCRoute

@end

@interface MixVCRouteDriver : NSObject<MixRouteModuleDriver>

@end

@interface MixVCRouteDriver()<MixVCRouteModule>

@end

@implementation MixVCRouteDriver

+ (void)load
{
    [[MixRouteManager shared] registerDriver:self forModule:@protocol(MixVCRouteModule)];
    [[MixRouteManager shared] registerModule:self forName:MixRouteNameBack];
    [[MixRouteManager shared] registerModule:self forName:MixRouteNameBackToRoot];
}

+ (UIViewController<MixRouteViewControlelr> *)vcWithRoute:(MixVCRoute *)route
{
    return nil;
}

- (UIViewController<MixRouteViewControlelr> *)topVC
{
    UIViewController *avc = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findTopVC:avc];
}

- (UIViewController<MixRouteViewControlelr> *)findTopVC:(UIViewController *)vc
{
    UIViewController *avc;
    if (vc.presentedViewController) {
        avc = [self findTopVC:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        avc = [self findTopVC:nav.topViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tvc = (UITabBarController *)vc;
        avc = [self findTopVC:tvc.viewControllers[tvc.selectedIndex]];
    }
    else if ([vc isKindOfClass:[UIViewController class]] && ![vc isKindOfClass:[UIAlertController class]]) {
        avc = vc;
    }
    return avc.mixRoute_vc;
}

- (void)drive:(MixVCRoute *)route completion:(void (^)(void))completion
{
    UIViewController<MixRouteViewControlelr> *topVC = [self topVC];
    if (MixRouteNameEqual(route.name, MixRouteNameBack)) {
        if (topVC.mix_route.style == MixRouteStylePresent) {
            [topVC dismissViewControllerAnimated:YES completion:^{
                if (completion) completion();
            }];
        }
        else {
            int delta = 1;
            if ([route.params isKindOfClass:[NSNumber class]] || [route.params isKindOfClass:[NSString class]]) {
                delta = MAX([route.params intValue], 1);
            }
            int count = (int)topVC.navigationController.viewControllers.count;
            if (delta >= count) {
                [topVC.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                UIViewController *xvc = topVC.navigationController.viewControllers[count - delta - 1];
                [topVC.navigationController popToViewController:xvc animated:YES];
            }
            if (completion) completion();
        }
    }
    else if (MixRouteNameEqual(route.name, MixRouteNameBackToRoot)) {
        [topVC.navigationController popToRootViewControllerAnimated:YES];
        if (completion) completion();
    }
    else {
        Class moduleClass = [[MixRouteManager shared] moduleClassWithName:route.name];
        UIViewController<MixRouteViewControlelr> *vc = [moduleClass vcWithRoute:route];
        if (!vc) {
            if (completion) completion();
            return;
        }
        vc.mix_route = route;

        Class navClass;
        if ([(id)moduleClass respondsToSelector:@selector(routeNavigationControllerClass)]) {
            navClass = [moduleClass routeNavigationControllerClass];
        }
        if (![navClass isKindOfClass:[UINavigationController class]]) {
            navClass = [UINavigationController class];
        }

        if ([vc isKindOfClass:[UITabBarController class]] && route.tabRoutes) {
            NSMutableArray *navs = [NSMutableArray new];
            for (int i = 0; i < route.tabRoutes.count; i++) {
                MixVCRoute *aroute = route.tabRoutes[i];
                Class<MixVCRouteModule> acls = (Class<MixVCRouteModule>)[[MixRouteManager shared] moduleClassWithName:aroute.name];
                UIViewController<MixRouteViewControlelr> *avc = [acls vcWithRoute:aroute];
                avc.mix_route = aroute;
                UINavigationController *nav = [[navClass alloc] initWithRootViewController:avc];
                [navs addObject:nav];
            }
            ((UITabBarController *)vc).viewControllers = navs;
        }
        
        if (route.style == MixRouteStyleRoot) {
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
            if (completion) completion();
        }
        else if (route.style == MixRouteStylePresent) {
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
            [topVC presentViewController:nav animated:YES completion:^{
                if (completion) completion();
            }];
        }
        else {
            [topVC.navigationController pushViewController:vc animated:YES];
            if (completion) completion();
        }
    }
}

@end
