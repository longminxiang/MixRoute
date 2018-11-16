//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>

@implementation MixRouteDriver (MixViewControllerRoute)

- (MixRouteDriverViewControllerRegister)regvc
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        __weak typeof(self) weaks = self;
        obj = ^(MixRouteName name) {
            weaks.reg(name, [[self class] viewControllerDriverBlock]);
        };
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return obj;
}

+ (MixRouteDriverBlock)viewControllerDriverBlock
{
    static MixRouteDriverBlock driver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        driver = ^(MixRoute *route) {
            [self viewControllerDriver:route];
        };
    });
    return driver;
}

+ (void)viewControllerDriver:(MixRoute *)route
{
    Class moduleClass = [MixRouteManager moduleClassWithName:route.name];
    if (!moduleClass) return;

    MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, route.params, params);

    UIViewController<MixRouteViewControlelr> *vc = [moduleClass viewControllerWithRoute:route];
    if (!vc) {
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

    MIX_ROUTE_PROTOCOL_PARAMS(MixRouteTabBarControllerParams, route.params, tabParams);
    if ([vc isKindOfClass:[UITabBarController class]] && tabParams.tabRoutes.count) {

        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < tabParams.tabRoutes.count; i++) {
            MixRoute *aroute = tabParams.tabRoutes[i];
            Class<MixViewControllerRouteModule> acls = (Class<MixViewControllerRouteModule>)[MixRouteManager moduleClassWithName:aroute.name];
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
    }
    else if (params.style == MixRouteStylePresent) {
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        [MixRouteManager lock];
        [MixViewController.topVC presentViewController:nav animated:YES completion:^{
            [MixRouteManager unlock];
        }];
    }
    else {
        [MixRouteManager lock];
        [MixViewController.topVC.navigationController mix_route_pushViewController:vc animated:YES completion:^{
            [MixRouteManager unlock];
        }];
    }
}

@end
