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

+ (void)load
{
    [[MixRouteManager shared] registerModule:self forName:MixRouteNameActionShowHUD];
    [[MixRouteManager shared] registerModule:self forName:MixRouteNameActionLog];
}

+ (void)drive:(MixRoute *)route completion:(void (^)(void))completion
{
    if (MixRouteNameEqual(route.name, MixRouteNameActionShowHUD)) {
        NSLog(@"hud");
    }
    else if (MixRouteNameEqual(route.name, MixRouteNameActionLog)) {
        NSLog(@"log");
    }
    completion();
}

@end
