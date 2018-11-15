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

@implementation Action

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver
{
    driver.reg(MixRouteNameActionShowHUD, ^(MixRoute *route, void (^completion)(void)) {
        NSLog(@"hud");
        completion();
    });
    driver.reg(MixRouteNameActionLog, ^(MixRoute *route, void (^completion)(void)) {
        NSLog(@"log");
        completion();
    });
}

@end
