//
//  UINavigationController+MixExtention.h
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationControllerMixExtention : NSObject

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface UINavigationController (MixExtention)

@property (nonatomic, readonly) UINavigationControllerMixExtention *mix_extention;

@end

NS_ASSUME_NONNULL_END
