//
//  Action.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"

NS_ASSUME_NONNULL_BEGIN

static MixRouteQueue const MixRouteActionQueue = @"MixRouteActionQueue";

MIX_ROUTE_MAKE(ActionShowHUD)

MIX_ROUTE_MAKE(ActionLog)

@interface MixRouteActionDelayParams : NSObject<MixRouteParams>

@property (nonatomic, assign) CGFloat delay;

@end

MIX_ROUTE_MAKE_WITH_PARAMS(ActionDelay, MixRouteActionDelayParams)

@interface Action : NSObject<MixRouteModule>

@end

NS_ASSUME_NONNULL_END
