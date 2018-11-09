//
//  MixRouteViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/24.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteViewController.h"
#import <objc/runtime.h>
#import "MixRouteManager.h"
#import "MixViewControllerRouteBase.h"

void mix_vc_route_hook_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation MixViewController

+ (UIViewController<MixRouteViewControlelr> *)topVC
{
    UIViewController *avc = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findTopVC:avc];
}

+ (UIViewController<MixRouteViewControlelr> *)findTopVC:(UIViewController *)vc
{
    UIViewController *avc;
    if (vc.presentedViewController) {
        avc = [self findTopVC:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        avc = [self findTopVC:nav.topViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tvc = (UITabBarController *)vc;
        avc = [self findTopVC:tvc.viewControllers[tvc.selectedIndex]];
    }
    else if ([vc isKindOfClass:[UIViewController class]] && ![vc isKindOfClass:[UIAlertController class]]) {
        avc = vc;
    }
    return avc.mix.vc;
}

- (instancetype)initWithVC:(UIViewController<MixRouteViewControlelr> *)vc
{
    if (self = [super init]) {
        _vc = vc;
    }
    return self;
}

@end

@interface UINavigationController (MixRouteViewControlelr)

@end

@implementation UINavigationController (MixRouteViewControlelr)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(childViewControllerForStatusBarStyle), @selector(_mix_childViewControllerForStatusBarStyle));
    });
}

- (UIViewController *)_mix_childViewControllerForStatusBarStyle
{
    UIViewController *vc = [self _mix_childViewControllerForStatusBarStyle];
    if ([self isKindOfClass:[UINavigationController class]] && !vc) {
        vc = [(UINavigationController *)self topViewController];
    }
    return vc;
}

@end

@interface UIViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UIViewController (MixRouteViewControlelr)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(viewDidLoad), @selector(_mix_vc_route_viewDidLoad));
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(navigationItem), @selector(_mix_vc_route_navigationItem));
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(preferredStatusBarStyle), @selector(_mix_vc_route_preferredStatusBarStyle));
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(viewWillAppear:), @selector(_mix_vc_route_viewWillAppear:));
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(viewDidAppear:), @selector(_mix_vc_route_viewDidAppear:));
    });
}

- (MixViewController *)mix
{
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return nil;

    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[MixViewController alloc] initWithVC:(UIViewController<MixRouteViewControlelr> *)self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (void)_mix_vc_route_viewDidLoad
{
    [self _mix_vc_route_viewDidLoad];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;

    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    if (self.navigationController.isBeingPresented) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_mix_dismissViewController)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (UINavigationItem *)_mix_vc_route_navigationItem
{
    UINavigationItem *item;
    if ([self conformsToProtocol:@protocol(MixRouteViewControlelr)]) {
        UINavigationItem *aitem = ((id<MixRouteViewControllerParams>)self.mix.route.params).navigationItem;
        if (aitem) item = aitem;
        else aitem = item = [self _mix_vc_route_navigationItem];
    }
    else {
        item = [self _mix_vc_route_navigationItem];
    }
    return item;
}

- (UIStatusBarStyle)_mix_vc_route_preferredStatusBarStyle
{
    UIStatusBarStyle style = [self _mix_vc_route_preferredStatusBarStyle];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return style;
    style = self.navigationItem.mix.statusBarStyle;
    return style;
}

- (void)_mix_vc_route_viewWillAppear:(BOOL)animated
{
    [self _mix_vc_route_viewWillAppear:animated];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;
    [self.mix_itemManager viewWillAppear:animated];
}

- (void)_mix_vc_route_viewDidAppear:(BOOL)animated
{
    [self _mix_vc_route_viewDidAppear:animated];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;
    [self.mix_itemManager viewDidAppear:animated];
}

- (void)_mix_dismissViewController
{
    [[MixRouteManager shared] routeTo:MixRouteNameBack];
}

@end
