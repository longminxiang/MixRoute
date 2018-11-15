//
//  MixViewControllerRouteBase.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRouteBase.h"

MixRouteName const MixRouteNameBack = @"MixRouteNameBack";
MixRouteName const MixRouteNameBackToRoot = @"MixRouteNameBackToRoot";

@implementation MixRouteViewControllerBaseParams
@synthesize style = _style;
@synthesize navigationItem = _navigationItem;
@synthesize tabBarItem = _tabBarItem;

@end

@implementation MixRouteTabBarControllerBaseParams
@synthesize tabRoutes = _tabRoutes;

@end

@implementation MixRouteBackParams

@end

@implementation MixViewControllerRouteBase

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver
{
    MixRouteDriverBlock block = ^(MixRoute *route, void (^completion)(void)) {
        [self drive:route completion:completion];
    };
    driver.reg(MixRouteNameBack, block);
    driver.reg(MixRouteNameBackToRoot, block);
}

+ (void)drive:(MixRoute *)route completion:(void (^)(void))completion
{
    UIViewController<MixRouteViewControlelr> *topVC = MixViewController.topVC;
    MixRouteConverParams(MixRouteViewControllerParams, topParams, topVC.mix.route.params);

    if (MixRouteNameEqual(route.name, MixRouteNameBack)) {
        if (topParams.style == MixRouteStylePresent) {
            [topVC dismissViewControllerAnimated:YES completion:^{
                if (completion) completion();
            }];
        }
        else {
            MixRouteBackParams *params = (MixRouteBackParams *)route.params;
            if (![params isKindOfClass:[MixRouteBackParams class]]) params = nil;

            int count = (int)topVC.navigationController.viewControllers.count;
            NSInteger delta = MAX(params.delta, 1);
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
}

@end
