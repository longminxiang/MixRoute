//
//  MixViewControllerRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"
#import <MixExtention/MixExtention.h>

typedef NS_ENUM(NSUInteger, MixViewControllerRouteStyle) {
    MixViewControllerRouteStylePush,
    MixViewControllerRouteStylePresent,
    MixViewControllerRouteStyleRoot,
    MixViewControllerRouteStyleSubTab,
};

@protocol MixRouteViewController<UIViewControllerMixExtention>

@end

@protocol MixRouteViewControllerParams <MixRouteParams>

@property (nonatomic, assign) MixViewControllerRouteStyle style;

@optional

@property (nonatomic, strong) MixViewControllerItem *item;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, strong) NSArray<id<MixRoute>> *tabRoutes;

@property (nonatomic, assign) Class navigationControllerClass;

@property (nonatomic, assign) BOOL noAnimated;

@end


@interface UIViewController (MixRouteViewController)

@property (nonatomic, readonly) id<MixRoute> mix_route;

@end

typedef UIViewController<MixRouteViewController> * (^MixViewControllerRouteModuleBlock)(id<MixRoute> route);

@interface MixRouteModuleRegister (ViewControllerRoute)

- (void)add:(MixRouteName)name vcBlock:(MixViewControllerRouteModuleBlock)block;

@end

@interface MixRouteBackParams : NSObject<MixRouteParams>

@property (nonatomic, assign) NSInteger delta;
@property (nonatomic, assign) BOOL toRoot;
@property (nonatomic, assign) BOOL noAnimated;

@end

MIX_ROUTE_NAME(Back)
