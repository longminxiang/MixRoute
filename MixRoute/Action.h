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

FOUNDATION_EXTERN MixRouteName const MixRouteNameActionShowHUD;

FOUNDATION_EXTERN MixRouteName const MixRouteNameActionLog;

FOUNDATION_EXTERN MixRouteName const MixRouteNameActionDelay;

FOUNDATION_EXTERN MixRouteQueue const MixRouteActionQueue;

@interface MixRouteActionDelayParams : NSObject<MixRouteParams>

@property (nonatomic, assign) CGFloat delay;

@end

@interface MixRouteManager (Action)

+ (void)toActionShowHUD;

+ (void)toActionLog;

+ (void)toActionDelay:(MixRouteActionDelayParams *)params queue:(MixRouteQueue)queue;

@end

@interface Action : NSObject<MixRouteModule>

@end

NS_ASSUME_NONNULL_END
