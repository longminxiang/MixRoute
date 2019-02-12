//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>

@implementation MixRouteViewControllerManager

+ (NSArray<MixRouteName> *)mixRouteRegisterModules
{
    NSMutableArray *mmodules = [NSMutableArray new];
    unsigned int count;
    Class *allClasse = objc_copyClassList(&count);
    for (int i = 0; i < count; i++) {
        Class class = allClasse[i];
        if (class_conformsToProtocol(class, @protocol(MixViewControllerRouteModule))) {
            NSArray<MixRouteName> *modules = [class mixRouteRegisterModules];
            [mmodules addObjectsFromArray:modules];
        }
    }
    free(allClasse);
    return mmodules;
}

+ (void)mixRouteFire:(MixRoute *)route
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

    if ([vc isKindOfClass:[UITabBarController class]] && params.tabRoutes.count) {

        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < params.tabRoutes.count; i++) {
            MixRoute *aroute = params.tabRoutes[i];
            Class<MixViewControllerRouteModule> acls = (Class<MixViewControllerRouteModule>)[MixRouteManager moduleClassWithName:aroute.name];
            UIViewController<MixRouteViewControlelr> *avc = [acls viewControllerWithRoute:aroute];
            avc.mix.route = aroute;
            UINavigationController *nav = [[navClass alloc] initWithRootViewController:avc];
            [navs addObject:nav];
        }
        ((UITabBarController *)vc).viewControllers = navs;
    }

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (params.style == MixRouteStyleRoot || !keyWindow.rootViewController) {
        UINavigationController *nav = [[navClass alloc] initWithRootViewController:vc];
        keyWindow.rootViewController = nav;
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
