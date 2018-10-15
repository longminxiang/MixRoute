//
//  MixVCRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"
#import "MixRouteDriverManager.h"

@protocol MixRouteViewControlelr;
@protocol MixVCRoute;

UIKIT_EXTERN MixRouteName const MixRouteNameBack;

UIKIT_EXTERN MixRouteName const MixRouteNameBackToRoot;

typedef NS_ENUM(NSUInteger, MixVCRouteStyle) {
    MixRouteStyleNormal,
    MixRouteStylePresent,
};

@interface UIViewController (MixRoute)

@property (nonatomic, readonly) UIViewController<MixRouteViewControlelr> *mixRoute_vc;

@end

@protocol MixVCRoute<MixRoute>

@property (nonatomic, assign) MixVCRouteStyle style;

@end

@protocol MixVCRouteModule<MixRouteModule>

@property (nonatomic, readonly) id<MixVCRoute> router;

+ (UIViewController<MixRouteViewControlelr> *)initWithRoute:(id<MixVCRoute>)route;

@end

@protocol MixRouteViewControlelr

@property (nonatomic, readonly) id<MixVCRoute> router;

@end

@interface MixVCRouteDriver : NSObject<MixRouteModuleDriver>

@end

