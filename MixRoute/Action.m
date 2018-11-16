//
//  Action.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "Action.h"

MixRouteName const MixRouteNameActionShowHUD = @"MixRouteNameActionShowHUD";
MixRouteName const MixRouteNameActionLog = @"MixRouteNameActionLog";
MixRouteName const MixRouteNameActionDelay = @"MixRouteNameActionDelay";

@implementation MixRouteActionDelayParams

@end

@implementation Action

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver
{
    driver.reg(MixRouteNameActionShowHUD, ^(MixRoute *route) {
        NSLog(@"hud");
    });
    driver.reg(MixRouteNameActionLog, ^(MixRoute *route) {
        NSLog(@"log");
    });
    driver.reg(MixRouteNameActionDelay, ^(MixRoute *route) {
        MIX_ROUTE_PARAMS(MixRouteActionDelayParams, route.params, params);
        CGFloat delay = params.delay / 1000;
        if (delay <= 0) return;
        [MixRouteManager lock];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MixRouteManager unlock];
        });
    });
}

@end
