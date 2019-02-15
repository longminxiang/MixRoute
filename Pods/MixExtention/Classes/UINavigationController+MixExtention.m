//
//  UINavigationController+MixExtention.m
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import "UINavigationController+MixExtention.h"
#import <objc/runtime.h>
#import "MixExtentionHooker.h"

@interface UINavigationControllerMixExtention ()

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation UINavigationControllerMixExtention

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
{
    if (self = [super init]) {
        self.navigationController = navigationController;
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self.navigationController pushViewController:viewController animated:animated];
    [self animated:animated forceCompletion:NO completion:completion];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    BOOL forceCompletion = self.navigationController.viewControllers.count <= 1;
    UIViewController *vc = [self.navigationController popViewControllerAnimated:animated];
    [self animated:animated forceCompletion:forceCompletion completion:completion];
    return vc;
}

- (NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    BOOL forceCompletion = self.navigationController.viewControllers.count <= 1;
    NSArray *vcs = [self.navigationController popToViewController:viewController animated:animated];
    [self animated:animated forceCompletion:forceCompletion completion:completion];
    return vcs;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    BOOL forceCompletion = self.navigationController.viewControllers.count <= 1;
    NSArray *vcs = [self.navigationController popToRootViewControllerAnimated:animated];
    [self animated:animated forceCompletion:forceCompletion completion:completion];
    return vcs;
}

- (void)animated:(BOOL)animated forceCompletion:(BOOL)force completion:(void (^)(void))completion
{
    if (!animated || force) {
        if (completion) completion();
    }
    else {
        [self.navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (completion) completion();
        }];
    }
}

@end

@implementation UINavigationController (MixExtention)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(childViewControllerForStatusBarStyle), @selector(_mix_extention_childViewControllerForStatusBarStyle));
    });
}

- (UINavigationControllerMixExtention *)mix_extention
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[UINavigationControllerMixExtention alloc] initWithNavigationController:self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (UIViewController *)_mix_extention_childViewControllerForStatusBarStyle
{
    UIViewController *vc = [self _mix_extention_childViewControllerForStatusBarStyle];
    if (!vc) vc = [self topViewController];
    return vc;
}

@end

