//
//  MixViewControllerRouteBase.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixViewControllerRoute.h"

UIKIT_EXTERN MixRouteName const MixRouteNameBack;
UIKIT_EXTERN MixRouteName const MixRouteNameBackToRoot;

NS_ASSUME_NONNULL_BEGIN

@interface MixRouteViewControllerBaseParams : NSObject<MixRouteViewControllerParams>

@end

@interface MixRouteTabBarControllerBaseParams : MixRouteViewControllerBaseParams<MixRouteTabBarControllerParams>

@end

@interface MixRouteBackParams : NSObject<MixRouteParams>

@property (nonatomic, assign) NSInteger delta;

@end

@interface MixViewControllerRouteBase : NSObject<MixRouteModule>

@end

NS_ASSUME_NONNULL_END
