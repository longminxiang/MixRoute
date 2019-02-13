//
//  MixViewControllerRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRouteManager.h"
#import "MixRouteViewController.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN MixRouteName const MixRouteNameBack;

typedef NS_ENUM(NSUInteger, MixViewControllerRouteStyle) {
    MixViewControllerRouteStylePush,
    MixViewControllerRouteStylePresent,
    MixViewControllerRouteStyleRoot,
};

@protocol MixRouteViewControllerParams <MixRouteParams>

@property (nonatomic, assign) MixViewControllerRouteStyle style;

@property (nonatomic, strong, nullable) UINavigationItem *navigationItem;

@optional

@property (nonatomic, strong, nullable) UITabBarItem *tabBarItem;

@property (nonatomic, strong, nullable) NSArray<MixRoute *> *tabRoutes;

@property (nonatomic, assign, nullable) Class navigationControllerClass;

@end

@interface MixRouteViewControllerParams : NSObject<MixRouteViewControllerParams>

@end


typedef UIViewController<MixRouteViewControlelr> * (^MixViewControllerRouteModuleBlock)(MixRoute *route);

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

@interface MixRouteManager (MixViewController)

+ (void)toViewControllerBack:(MixRouteBackParams* _Nullable)params;

@end

NS_ASSUME_NONNULL_END
