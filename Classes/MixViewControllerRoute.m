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
        obj = ^(MixRouteName  _Nonnull name) {
            weaks.reg(name, [[self class] sharedDriver]);
        };
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    return obj;
}

+ (MixRouteDriverBlock)sharedDriver
{
    static MixRouteDriverBlock driver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        driver = ^(MixRoute *route, void (^completion)(void)){
            [self defaultDriver:route completion:completion];
        };
    });
    return driver;
}

+ (void)defaultDriver:(MixRoute *)route completion:(void (^)(void))completion
{
    Class moduleClass = [[MixRouteManager shared] moduleClassWithName:route.name];
    if (!moduleClass) return;

    MixRouteConverParams(MixRouteViewControllerParams, params, route.params);

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
