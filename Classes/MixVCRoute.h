//
//  MixVCRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"

@protocol MixRouteViewControlelr;
@protocol MixVCRoute;

UIKIT_EXTERN MixRouteName const MixRouteNameBack;

UIKIT_EXTERN MixRouteName const MixRouteNameBackToRoot;

typedef NS_ENUM(NSUInteger, MixVCRouteStyle) {
    MixRouteStyleNormal,
    MixRouteStylePresent,
    MixRouteStyleRoot,
};

@interface UIViewController (MixRoute)

@property (nonatomic, readonly) UIViewController<MixRouteViewControlelr> *mixRoute_vc;

@end

@protocol MixVCRoute<MixRoute>

@property (nonatomic, assign) MixVCRouteStyle style;

@optional

@property (nonatomic, strong) NSArray<id<MixVCRoute>> *tabRoutes;

@end

@protocol MixVCRouteModule<MixRouteModule>

+ (UIViewController<MixRouteViewControlelr> *)initWithRoute:(id<MixVCRoute>)route;

@optional

+ (Class)routeNavigationControllerClass;

@end

@protocol MixRouteViewControlelr

@property (nonatomic, strong) id<MixVCRoute> route;

@end

@interface MixVCRouteDriver : NSObject<MixRouteModuleDriver>

@property (nonatomic, strong) id<MixVCRoute> route;

@property (nonatomic, assign) Class<MixVCRouteModule> moduleClass;

@end

