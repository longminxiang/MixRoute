//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>

@interface NSObject (MixViewControllerRouteModule)<MixRouteModule>

@end

@implementation NSObject (MixViewControllerRouteModule)

+ (void)drive:(MixRoute *)route completion:(void (^)(void))completion
{
    if (![self conformsToProtocol:@protocol(MixViewControllerRouteModule)]) return;

    MixRouteConverParams(MixRouteViewControllerParams, params, route.params);

    Class moduleClass = [[MixRouteManager shared] moduleClassWithName:route.name];
    UIViewController<MixRouteViewControlelr> *vc = [moduleClass viewControllerWithRoute:route];
    if (!vc) {
        if (completion) completion();
        return;
    }
    vc.mix.route = route;

    Class navClass;
    if ([(id)moduleClass respondsToSelector:@selector(routeNavigationControllerClass)]) {
        navClass = [moduleClass routeNavigationControllerClass];
    }
    if (![navClass isSubclassOfClass:[UINavigationController class]]) {
        navClass = [UINavigationController class];
    }

    MixRouteConverParams(MixRouteTabBarControllerParams, tabParams, route.params);
    if ([vc isKindOfClass:[UITabBarController class]] && tabParams.tabRoutes.count) {

        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < tabParams.tabRoutes.count; i++) {
            MixRoute *aroute = tabParams.tabRoutes[i];
            Class<MixViewControllerRouteModule> acls = (Class<MixViewControllerRouteModule>)[[MixRouteManager shared] moduleClassWithName:aroute.name];
            UIViewController<MixRouteViewControlelr> *avc = [acls viewControllerWithRoute:aroute];
            avc.mix.route = aroute;
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:avc];
            [navs addObject:nav];
        }
        ((UITabBarController *)vc).viewControllers = navs;
    }

    if (params.style == MixRouteStyleRoot) {
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        if (completion) completion();
    }
    else if (params.style == MixRouteStylePresent) {
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        [MixViewController.topVC presentViewController:nav animated:YES completion:^{
            if (completion) completion();
        }];
    }
    else {
        [MixViewController.topVC.navigationController pushViewController:vc animated:YES];
        if (completion) completion();
    }
}

@end
