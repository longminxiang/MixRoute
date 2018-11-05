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
#import "MixVCRoute.h"

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

@interface UIViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UIViewController (MixVCRoute)

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

- (UIViewController<MixRouteViewControlelr> *)mixRoute_vc
{
    return [self conformsToProtocol:@protocol(MixRouteViewControlelr)] ? (UIViewController<MixRouteViewControlelr> *)self : nil;
}

- (void)_mix_vc_route_viewDidLoad
{
    [self _mix_vc_route_viewDidLoad];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;

    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    if (self.navigationController.isBeingPresented) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(basePopViewController)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (UINavigationItem *)_mix_vc_route_navigationItem
{
    UINavigationItem *item;
    if ([self conformsToProtocol:@protocol(MixRouteViewControlelr)]) {
        UINavigationItem *aitem = self.mixRoute_vc.mix_route.navigationItem;
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
    if (self.navigationItem.mix_statusBarStyle) {
        style = [self.navigationItem.mix_statusBarStyle intValue];
    }
    return style;
}

- (void)_mix_vc_route_viewWillAppear:(BOOL)animated
{
    [self _mix_vc_route_viewWillAppear:animated];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;

    UINavigationBar *bar = self.navigationController.navigationBar;
    UINavigationItem *item = self.navigationItem;

    BOOL barHidden = item.mix_barHidden ? [item.mix_barHidden boolValue] : self.navigationController.navigationBarHidden;
    
    [self.navigationController setNavigationBarHidden:barHidden animated:YES];
    NSDictionary *titleTextAttributes = barHidden ? bar.titleTextAttributes : item.mix_titleTextAttributes;
    UIColor *barTintColor = barHidden ? bar.barTintColor : item.mix_barTintColor;
    if (titleTextAttributes) bar.titleTextAttributes = titleTextAttributes;
    if (barTintColor) bar.barTintColor = barTintColor;
    if (self.navigationItem.mix_statusBarStyle) {
        UIStatusBarStyle style = [self.navigationItem.mix_statusBarStyle intValue];
        bar.barStyle = style == UIStatusBarStyleLightContent ? UIBarStyleBlack : UIBarStyleDefault;
    }
}

- (void)_mix_vc_route_viewDidAppear:(BOOL)animated
{
    [self _mix_vc_route_viewDidAppear:animated];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;

    UINavigationItem *item = self.navigationItem;

    BOOL isRoot = [self.navigationController.viewControllers firstObject] == self;
    self.navigationController.interactivePopGestureRecognizer.enabled = !isRoot && !item.mix_disableInteractivePopGesture;
}

- (void)basePopViewController
{
    [[MixRouteManager shared] routeTo:MixRouteNameBack];
}

@end