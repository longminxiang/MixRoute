//
//  UITabBarItem+Mix.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/12.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MixTabBarItem : NSObject

@property (nonatomic, copy) UIColor *barTintColor;

@end

@interface UITabBarItem (MixTabBarItem)

@property (nonatomic, readonly) MixTabBarItem *mix;

@end

@interface MixTabBarItemManager : NSObject

- (instancetype)initWithViewController:(UIViewController *)vc;

- (void)viewWillAppear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
