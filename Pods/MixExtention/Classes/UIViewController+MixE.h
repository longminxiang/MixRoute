//
//  UIViewController+MixE.h
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MixViewControllerState) {
    MixViewControllerStateNone,
    MixViewControllerStateViewDidLoad,
    MixViewControllerStateViewWillAppear,
    MixViewControllerStateViewDidAppear,
    MixViewControllerStateViewWillDisappear,
    MixViewControllerStateViewDidDisappear,
};

@protocol UIViewControllerMixExtention <NSObject>

@end

@interface MixViewControllerItem : NSObject

@property (nonatomic, assign) BOOL disableInteractivePopGesture;

@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, assign) BOOL navigationBarHidden;

@property (nonatomic, assign) BOOL navigationBarBottomLineHidden;

@property (nonatomic, strong) NSDictionary *navigationBarTitleTextAttributes;

@property (nonatomic, copy) UIColor *navigationBarTintColor;

@property (nonatomic, copy) UIColor *navigationBarBarTintColor;

@property (nonatomic, strong) UIImage *navigationBarBackgroundImage;

@property (nonatomic, strong) UIImage *navigationBarBackImage;

@property (nonatomic, copy) UIColor *tabBarTintColor;

@property (nonatomic, copy) UIColor *tabBarBarTintColor;

@end

@interface UIViewControllerMixExtention : NSObject

@property (nonatomic, strong) MixViewControllerItem *item;

@property (nonatomic, readonly) MixViewControllerState viewState;

@end

@interface UIViewControllerMixExtention (TopViewController)

+ (UIViewController *)topViewController;

@end

@interface UIViewController (MixExtention)

@property (nonatomic, readonly) UIViewControllerMixExtention *mixE;

@end
