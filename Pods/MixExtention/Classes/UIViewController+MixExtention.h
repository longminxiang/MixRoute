//
//  UIViewController+MixExtention.h
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* MixExtViewControllerAttribute NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeDisableInteractivePopGesture;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeStatusBarHidden;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeStatusBarStyle;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarHidden;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarTintColor;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarBarTintColor;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarTitleTextAttributes;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarBackImage;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeNavigationBarBackgroundImage;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeTabBarTintColor;
FOUNDATION_EXTERN MixExtViewControllerAttribute const MixExtAttributeTabBarBarTintColor;

@interface UIViewControllerMixExtentionAttributes : NSObject

@property (nonatomic, assign) BOOL disableInteractivePopGesture;


@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;


@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, strong) NSDictionary *navigationBarTitleTextAttributes;

@property (nonatomic, copy) UIColor *navigationBarTintColor;

@property (nonatomic, copy) UIColor *navigationBarBarTintColor;

@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;

@property (nonatomic, strong) UIImage *navigationBarBackImage;


@property (nonatomic, copy) UIColor *tabBarTintColor;

@property (nonatomic, copy) UIColor *tabBarBarTintColor;

@end

@protocol UIViewControllerMixExtention <NSObject>

@end

@interface UIViewControllerMixExtention : NSObject

@property (nonatomic, strong) UIViewControllerMixExtentionAttributes *attributes;

@property (nonatomic, readonly) BOOL viewWillAppear;

@property (nonatomic, readonly) BOOL viewDidAppear;

+ (UIViewController *)topViewController;

@end

@interface UIViewController (MixExtention)

@property (nonatomic, readonly) UIViewControllerMixExtention *mix_extention;

@end

NS_ASSUME_NONNULL_END
