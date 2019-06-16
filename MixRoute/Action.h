//
//  Action.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

static MixRouteQueue const MixRouteActionQueue = @"MixRouteActionQueue";

MIX_ROUTE_NAME(ActionShowHUD)
MIX_ROUTE_NAME(ActionLog)
MIX_ROUTE_NAME(ActionDelay)

@interface MixRouteActionDelayParams : NSObject<MixRouteParams>

@property (nonatomic, assign) CGFloat delay;

@end

@interface Action : NSObject<MixRouteModule>

@end
