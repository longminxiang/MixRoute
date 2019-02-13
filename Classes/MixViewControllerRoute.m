//
//  MixViewControllerRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRoute.h"
#import <objc/runtime.h>

@implementation MixViewControllerRouteModule

- (void)setName:(MixRouteName)name block:(MixViewControllerRouteModuleBlock)block
{
    self.name = name;
    self.block = block;
}

- (Class)navigationControllerClass
{
    if (!_navigationControllerClass || ![_navigationControllerClass isSubclassOfClass:[UINavigationController class]]) {
        return [UINavigationController class];
    }
    return _navigationControllerClass;
}

@end

@interface MixViewControllerRouteModuleRegister ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixViewControllerRouteModule *> *moduleDictionary;

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

- (void)add:(MixViewControllerRouteModule *)module
{
    if (!module || !module.name || !module.block) return;
    if (!_moduleDictionary) _moduleDictionary = [NSMutableDictionary new];
    _moduleDictionary[module.name] = module;
}

- (void)add:(MixRouteName)name block:(MixViewControllerRouteModuleBlock)block
{
    MixViewControllerRouteModule *module = [MixViewControllerRouteModule new];
    module.name = name;
    module.block = block;
    [self add:module];
}

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
    [[MixViewControllerRouteModuleRegister shared].moduleDictionary enumerateKeysAndObjectsUsingBlock:^(MixRouteName name, MixViewControllerRouteModule *module, BOOL *stop) {
        [reg add:name block:^(MixRoute *route) {
            [self fire:route module:module];
        }];
    }];
}

+ (void)fire:(MixRoute *)route module:(MixViewControllerRouteModule *)module
{
    MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, route.params, params);

    UIViewController<MixRouteViewControlelr> *vc = module.block(route);
    if (!vc) {
        return;
    }
    vc.mix.route = route;

    if ([vc isKindOfClass:[UITabBarController class]] && params.tabRoutes.count) {

        NSMutableArray *navs = [NSMutableArray new];
        for (int i = 0; i < params.tabRoutes.count; i++) {
            MixRoute *aroute = params.tabRoutes[i];
            MixViewControllerRouteModule *amodule = [MixViewControllerRouteModuleRegister shared].moduleDictionary[aroute.name];
            UIViewController<MixRouteViewControlelr> *avc = amodule.block(aroute);
            avc.mix.route = aroute;
            UINavigationController *nav = [[module.navigationControllerClass alloc] initWithRootViewController:avc];
            [navs addObject:nav];
        }
        ((UITabBarController *)vc).viewControllers = navs;
    }

    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (params.style == MixRouteStyleRoot || !keyWindow.rootViewController) {
        UINavigationController *nav = [[module.navigationControllerClass alloc] initWithRootViewController:vc];
        keyWindow.rootViewController = nav;
    }
    else if (params.style == MixRouteStylePresent) {
        UINavigationController *nav = [[module.navigationControllerClass alloc] initWithRootViewController:vc];
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
