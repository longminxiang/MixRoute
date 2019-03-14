//
//  MixViewControllerRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRouteManager.h"
#import <MixExtention/MixExtention.h>

NS_ASSUME_NONNULL_BEGIN

#define MIX_VC_ROUTE_MAKE(__name) MIX_ROUTE_MAKE_WITH_PARAMS(__name, MixRouteViewControllerParams)

#define MIX_VC_ROUTE_MAKE_WITH_PARAMS(__name, __params_type) MIX_ROUTE_MAKE_WITH_PARAMS(__name, __params_type)

typedef NS_ENUM(NSUInteger, MixViewControllerRouteStyle) {
    MixViewControllerRouteStylePush,
    MixViewControllerRouteStylePresent,
    MixViewControllerRouteStyleRoot,
};

@protocol MixRouteViewControllerParams <MixRouteParams>

@property (nonatomic, assign) MixViewControllerRouteStyle style;

@optional

@property (nonatomic, strong, nullable) MixViewControllerItem *item;

@property (nonatomic, strong, nullable) UINavigationItem *navigationItem;

@property (nonatomic, strong, nullable) UITabBarItem *tabBarItem;

@property (nonatomic, strong, nullable) NSArray<MixRoute *> *tabRoutes;

@property (nonatomic, assign, nullable) Class navigationControllerClass;

@end

@interface MixRouteViewControllerParams : NSObject<MixRouteViewControllerParams>

@end


@protocol MixRouteViewController<UIViewControllerMixExtention>

@end

@interface UIViewController (MixRouteViewController)

@property (nonatomic, strong) MixRoute *mix_route;

@end

typedef UIViewController<MixRouteViewController> * (^MixViewControllerRouteModuleBlock)(MixRoute *route);

@interface MixViewControllerRouteModuleRegister : NSObject

- (void)add:(MixRouteName)name block:(MixViewControllerRouteModuleBlock)block;

@end

@protocol MixViewControllerRouteModule

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModuleRegister *)reg;

@end

@interface MixRouteBackParams : NSObject<MixRouteParams>

@property (nonatomic, assign) NSInteger delta;
@property (nonatomic, assign) BOOL toRoot;
@property (nonatomic, assign) BOOL noAnimated;

@end

MIX_VC_ROUTE_MAKE_WITH_PARAMS(Back, MixRouteBackParams);

NS_ASSUME_NONNULL_END
