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

@implementation UIViewController (MixVCRoute)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mix_vc_route_hook_class_swizzleMethodAndStore(self, @selector(viewDidLoad), @selector(_mixVCRoute_viewDidLoad));
    });
}

- (void)_mixVCRoute_viewDidLoad
{
    [self _mixVCRoute_viewDidLoad];
    if (![self conformsToProtocol:@protocol(MixRouteViewControlelr)]) return;

    BOOL isRoot = [self.navigationController.viewControllers firstObject] == self;
    self.navigationController.interactivePopGestureRecognizer.enabled = !isRoot;
    if (self.navigationController.isBeingPresented) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(basePopViewController)];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (UIViewController<MixRouteViewControlelr> *)mixRoute_vc
{
    return [self conformsToProtocol:@protocol(MixRouteViewControlelr)] ? (UIViewController<MixRouteViewControlelr> *)self : nil;
}

- (void)basePopViewController
{
    [[MixRouteManager shared] routeTo:MixRouteNameBack];
}

@end
