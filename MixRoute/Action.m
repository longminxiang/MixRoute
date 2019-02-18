//
//  Action.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "Action.h"

@implementation MixRouteActionDelayParams

@end

@implementation Action

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameActionShowHUD block:^(MixRoute *route) {
        NSLog(@"hud");
    }];
    [reg add:MixRouteNameActionLog block:^(MixRoute *route) {
        NSLog(@"log");
    }];
    [reg add:MixRouteNameActionDelay block:^(MixRoute *route) {
        MIX_ROUTE_PARAMS(MixRouteActionDelayParams, route.params, params);
        CGFloat delay = params.delay / 1000;
        if (delay <= 0) return;
        [MixRouteManager lock:route.queue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MixRouteManager unlock:route.queue];
        });
    }];
}

@end
