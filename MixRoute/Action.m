//
//  Action.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import "Action.h"
#import "MixRouteManager.h"

@implementation MixRouteActionDelayParams

@end

@implementation Action

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameActionShowHUD block:^(id<MixRoute> route) {
        NSLog(@"hud");
    }];
    [reg add:MixRouteNameActionLog block:^(id<MixRoute> route) {
        NSLog(@"log");
    }];
    [reg add:MixRouteNameActionDelay block:^(id<MixRoute> route) {
        MixRouteActionDelayParams *params = (MixRouteActionDelayParams *)route.routeParams;
        CGFloat delay = params.delay / 1000;
        if (delay <= 0) return;
        [MixRouteManager lock:route.routeQueue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MixRouteManager unlock:route.routeQueue];
        });
    }];
}

@end
