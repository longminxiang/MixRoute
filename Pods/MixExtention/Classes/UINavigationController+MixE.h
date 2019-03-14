//
//  UINavigationController+MixE.h
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationControllerMixExtention : NSObject

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface UINavigationController (MixExtention)

@property (nonatomic, readonly) UINavigationControllerMixExtention *mixE;

@end
