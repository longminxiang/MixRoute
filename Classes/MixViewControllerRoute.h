//
//  MixViewControllerRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"
#import "MixRouteViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MixVCRouteStyle) {
    MixRouteStylePush,
    MixRouteStylePresent,
    MixRouteStyleRoot,
};

@protocol MixRouteViewControllerParams <MixRouteParams>

@property (nonatomic, assign) MixVCRouteStyle style;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@optional

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@end

@protocol MixRouteTabBarControllerParams <MixRouteViewControllerParams>

@property (nonatomic, strong) NSArray<MixRoute *> *tabRoutes;

@end

@protocol MixViewControllerRouteModule<MixRouteModule>

+ (UIViewController<MixRouteViewControlelr> *)viewControllerWithRoute:(MixRoute *)route;

@optional

+ (Class)routeNavigationControllerClass;

@end

typedef void (^MixRouteDriverViewControllerRegister)(MixRouteName name);

@interface MixRouteDriver (MixViewControllerRoute)

@property (nonatomic, readonly) MixRouteDriverViewControllerRegister regvc;

@end

NS_ASSUME_NONNULL_END
