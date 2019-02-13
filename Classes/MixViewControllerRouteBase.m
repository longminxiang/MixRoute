//
//  MixViewControllerRouteBase.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixViewControllerRouteBase.h"

MixRouteName const MixRouteNameBack = @"MixRouteNameBack";

@implementation MixRouteViewControllerBaseParams
@synthesize style = _style;
@synthesize navigationItem = _navigationItem;
@synthesize tabBarItem = _tabBarItem;
@synthesize tabRoutes = _tabRoutes;

@end

@implementation MixRouteBackParams

@end

@implementation MixViewControllerRouteBase

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameBack block:^(MixRoute *route) {
        UIViewController<MixRouteViewControlelr> *topVC = MixViewController.topVC;
        MIX_ROUTE_PROTOCOL_PARAMS(MixRouteViewControllerParams, topVC.mix.route.params, topParams);
        MIX_ROUTE_PARAMS(MixRouteBackParams, route.params, params);
        
        if (topParams.style == MixRouteStylePresent) {
            [MixRouteManager lock];
            [topVC dismissViewControllerAnimated:!params.noAnimated completion:^{
                [MixRouteManager unlock];
            }];
        }
        else {
            int count = (int)topVC.navigationController.viewControllers.count;
            if (count <= 1) return;
            NSInteger delta = params.toRoot ? count - 1 : MIN(MAX(params.delta, 1), count - 1);
            UIViewController *xvc = topVC.navigationController.viewControllers[count - delta - 1];
            [MixRouteManager lock];
            [topVC.navigationController mix_route_popToViewController:xvc animated:!params.noAnimated completion:^{
                [MixRouteManager unlock];
            }];
        }
    }];
}

@end
