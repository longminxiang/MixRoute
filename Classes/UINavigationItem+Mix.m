//
//  UINavigationItem+Mix.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/5.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "UINavigationItem+Mix.h"
#import <objc/runtime.h>

@implementation MixNavigationItem

@end

@implementation UINavigationItem (MixNavigationItem)

- (MixNavigationItem *)mix
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [MixNavigationItem new];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end

@interface MixNavigationItemManager ()

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation MixNavigationItemManager

- (instancetype)initWithViewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.vc = vc;
        MixNavigationItem *item = self.vc.navigationItem.mix;
        for (NSString *keyPath in [self mixItemKeyPaths]) {
            [item addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    MixNavigationItem *item = self.vc.navigationItem.mix;
    UINavigationController *nav = self.vc.navigationController;
    UINavigationBar *bar = nav.navigationBar;

    for (NSString *keyPath in [self mixItemKeyPaths]) {
        void *context = NULL;
        //view will appear时是不能禁用的
        if ([keyPath isEqualToString:@"disableInteractivePopGesture"]) {
            BOOL lock = YES;
            context = &lock;
        }
        //如果没有背景图，那就要用bar的背景图代替
        else if ([keyPath isEqualToString:@"barBackgroundImage"] && !item.barBackgroundImage) {
            context = (__bridge void *)[bar backgroundImageForBarMetrics:UIBarMetricsDefault];
        }
        [self observeValueForKeyPath:keyPath ofObject:self.vc.navigationItem.mix change:nil context:context];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self observeValueForKeyPath:@"disableInteractivePopGesture" ofObject:self.vc.navigationItem.mix change:nil context:NULL];
    [self observeValueForKeyPath:@"barBackgroundImage" ofObject:self.vc.navigationItem.mix change:nil context:NULL];
    [self observeValueForKeyPath:@"barTitleTextAttributes" ofObject:self.vc.navigationItem.mix change:nil context:NULL];
}

- (NSArray *)mixItemKeyPaths
{
    NSArray *keyPaths = @[@"disableInteractivePopGesture", @"statusBarStyle", @"barHidden",
                          @"barTitleTextAttributes", @"barTintColor", @"barBackgroundImage"];
    return keyPaths;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    MixNavigationItem *item = self.vc.navigationItem.mix;
    if (object != item) return;
    UINavigationController *nav = self.vc.navigationController;
    if (nav.topViewController != self.vc) return;

    UINavigationBar *bar = nav.navigationBar;

    if ([keyPath isEqualToString:@"disableInteractivePopGesture"]) {
        BOOL lock = context;
        if (!lock) {
            BOOL isRoot = [nav.viewControllers firstObject] == self.vc;
            nav.interactivePopGestureRecognizer.enabled = !isRoot && !item.disableInteractivePopGesture;
        }
    }
    else if ([keyPath isEqualToString:@"statusBarStyle"]) {
        bar.barStyle = item.statusBarStyle == UIStatusBarStyleLightContent ? UIBarStyleBlack : UIBarStyleDefault;
        [self.vc setNeedsStatusBarAppearanceUpdate];
    }
    else if ([keyPath isEqualToString:@"barHidden"]) {
        [nav setNavigationBarHidden:item.barHidden animated:YES];
    }
    else if ([keyPath isEqualToString:@"barTitleTextAttributes"]) {
        bar.titleTextAttributes = item.barTitleTextAttributes;
    }
    else if ([keyPath isEqualToString:@"barTintColor"]) {
        bar.barTintColor = item.barTintColor;
    }
    else if ([keyPath isEqualToString:@"barBackgroundImage"]) {
        UIImage *image = (__bridge UIImage *)(context);
        if (![image isKindOfClass:[UIImage class]]) {
           image = item.barBackgroundImage;
        }
        [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)dealloc
{
    MixNavigationItem *item = self.vc.navigationItem.mix;
    for (NSString *keyPath in [self mixItemKeyPaths]) {
        [item removeObserver:self forKeyPath:keyPath];
    }
}

@end

@interface UIViewController ()

@end

@implementation UIViewController (MixNavigationItem)

- (MixNavigationItemManager *)mix_itemManager
{
    MixNavigationItemManager *obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[MixNavigationItemManager alloc] initWithViewController:self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end
