//
//  MixRouteViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/24.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+Mix.h"
#import "UITabBarItem+Mix.h"

@class MixRoute;

@protocol MixRouteViewControlelr

@end

@interface MixViewController : NSObject

@property (nonatomic, weak, readonly) UIViewController<MixRouteViewControlelr> *vc;

@property (nonatomic, strong) MixRoute *route;

@property (nonatomic, readonly, class) UIViewController<MixRouteViewControlelr> *topVC;

@property (nonatomic, readonly) MixNavigationItemManager *navigationItemManager;

@property (nonatomic, readonly) MixTabBarItemManager *tabBarItemManager;

@end

@interface UIViewController (MixRouteViewControlelr)

@property (nonatomic, readonly) MixViewController *mix;

@end

@interface UINavigationController (MixRouteViewControlelr)

- (UIViewController *)mix_route_popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)mix_route_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)mix_route_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)mix_route_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
