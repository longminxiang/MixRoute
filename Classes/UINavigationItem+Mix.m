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

    [self.vc.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        BOOL isPop = ![nav.viewControllers containsObject:fromVC];
        if (!isPop) return ;

        for (UIView *view in [bar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                for (UILabel *label in [view subviews]) {
                    if (![label isKindOfClass:[UILabel class]] || item.barHidden) continue;
                    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:item.barTitleTextAttributes];
                    break;
                }
            }
            else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                for (UIView *sview in [view subviews]) {
                    if (![sview isKindOfClass:[UIVisualEffectView class]]) continue;
                    for (UIView *ssview in [sview subviews]) {
                        if (ssview.alpha < 0.86 && !item.barHidden) {
                            ssview.backgroundColor = item.barTintColor;
                            break;
                        }
                    }
                }
            }
        }
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    MixNavigationItem *item = self.vc.navigationItem.mix;
    [self observeValueForKeyPath:@"disableInteractivePopGesture" ofObject:item change:nil context:NULL];
}

- (NSArray *)mixItemKeyPaths
{
    NSArray *keyPaths = @[@"disableInteractivePopGesture", @"statusBarStyle", @"barHidden",
                          @"barTitleTextAttributes", @"barTintColor", @"barBackgroundImage", @"statusBarHidden"];
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
        if (lock) return;
        BOOL isRoot = [nav.viewControllers firstObject] == self.vc;
        nav.interactivePopGestureRecognizer.enabled = !isRoot && !item.disableInteractivePopGesture;
    }
    else if ([keyPath isEqualToString:@"statusBarStyle"]) {
        [self.vc setNeedsStatusBarAppearanceUpdate];
    }
    else if ([keyPath isEqualToString:@"statusBarHidden"]) {
        UIView *view = [[UIApplication sharedApplication] valueForKeyPath:@"statusBarWindow.statusBar"];
        view.alpha = !item.statusBarHidden || !item.barHidden;
    }
    else if ([keyPath isEqualToString:@"barHidden"]) {
        [nav setNavigationBarHidden:item.barHidden animated:YES];
    }
    else if ([keyPath isEqualToString:@"barTitleTextAttributes"]) {
        if (item.barHidden) return;
        bar.titleTextAttributes = item.barTitleTextAttributes;
    }
    else if ([keyPath isEqualToString:@"barTintColor"]) {
        if (item.barHidden) return;
        bar.barTintColor = item.barTintColor;
    }
    else if ([keyPath isEqualToString:@"barBackgroundImage"]) {
        if (item.barHidden) return;
        UIImage *image = (__bridge UIImage *)(context);
        if (![image isKindOfClass:[UIImage class]]) image = item.barBackgroundImage;
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
