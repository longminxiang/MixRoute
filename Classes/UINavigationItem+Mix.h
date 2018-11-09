//
//  UINavigationItem+Mix.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/5.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MixNavigationItem : NSObject

@property (nonatomic, assign) BOOL disableInteractivePopGesture;

@property (nonatomic, assign) BOOL statusBarHidden;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;


@property (nonatomic, assign) BOOL barHidden;

@property (nonatomic, strong) NSDictionary *barTitleTextAttributes;

@property (nonatomic, copy) UIColor *barTintColor;

@property (nonatomic, strong) UIImage *barBackgroundImage;

@end

@interface UINavigationItem (MixNavigationItem)

@property (nonatomic, readonly) MixNavigationItem *mix;

@end

@interface MixNavigationItemManager : NSObject

- (void)viewWillAppear:(BOOL)animated;

- (void)viewDidAppear:(BOOL)animated;

@end

@interface UIViewController (MixNavigationItem)

@property (nonatomic, readonly) MixNavigationItemManager *mix_itemManager;

@end
