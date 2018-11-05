//
//  MixVCRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRouteManager.h"
#import "MixRouteViewController.h"

UIKIT_EXTERN MixRouteName const MixRouteNameBack;
UIKIT_EXTERN MixRouteName const MixRouteNameBackToRoot;

typedef NS_ENUM(NSUInteger, MixVCRouteStyle) {
    MixRouteStylePush,
    MixRouteStylePresent,
    MixRouteStyleRoot,
};

@interface MixVCRoute : MixRoute

@property (nonatomic, assign) MixVCRouteStyle style;

@property (nonatomic, strong) UINavigationItem *navigationItem;

@property (nonatomic, strong) NSArray<MixVCRoute *> *tabRoutes;

@end

@protocol MixVCRouteModule<MixRouteModule>

+ (UIViewController<MixRouteViewControlelr> *)vcWithRoute:(MixVCRoute *)route;

@optional

+ (Class)routeNavigationControllerClass;

@end
