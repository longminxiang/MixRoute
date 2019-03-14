//
//  UIViewController+MixE.m
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import "UIViewController+MixE.h"
#import <objc/runtime.h>
#import "MixExtentionHooker.h"
#import "UINavigationBar+MixE.h"

@implementation MixViewControllerItem

@end

@interface UIViewControllerMixExtention ()

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation UIViewControllerMixExtention
@synthesize item = _item;

- (instancetype)initWithViewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.vc = vc;
    }
    return self;
}

- (MixViewControllerItem *)item
{
    if (!_item) {
        _item = [MixViewControllerItem new];
        [self addObserverToItem:_item];
    }
    return _item;
}

- (void)setItem:(MixViewControllerItem *)item
{
    [self removeObserverToItem:_item];
    _item = item;
    [self addObserverToItem:_item];
}

- (NSArray *)itemKeyPaths
{
    return @[@"disableInteractivePopGesture", @"statusBarHidden", @"statusBarStyle",
             @"navigationBarHidden", @"navigationBarBottomLineHidden", @"navigationBarTitleTextAttributes",
             @"navigationBarTintColor", @"navigationBarBarTintColor", @"navigationBarBackgroundImage",
             @"navigationBarBackImage", @"tabBarTintColor", @"tabBarBarTintColor"];
}

- (void)addObserverToItem:(MixViewControllerItem *)item
{
    if (!item) return;
    for (NSString *keyPath in [self itemKeyPaths]) {
        [item addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeObserverToItem:(MixViewControllerItem *)item
{
    if (!item) return;
    for (NSString *keyPath in [self itemKeyPaths]) {
        [item removeObserver:self forKeyPath:keyPath];
    }
}

- (void)setViewState:(MixViewControllerState)viewState
{
    _viewState = viewState;
}

- (void)viewDidLoad
{
    self.viewState = MixViewControllerStateViewDidLoad;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.item.statusBarHidden = self.item.statusBarHidden;
    self.item.statusBarStyle = self.item.statusBarStyle;
    self.item.navigationBarHidden = self.item.navigationBarHidden;
    self.item.tabBarTintColor = self.item.tabBarTintColor;
    self.item.tabBarBarTintColor = self.item.tabBarBarTintColor;
    self.item.navigationBarBottomLineHidden = self.item.navigationBarBottomLineHidden;

    UINavigationController *nav = self.vc.navigationController;
    UINavigationBar *bar = nav.navigationBar;
    [self.vc.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        BOOL isPop = ![nav.viewControllers containsObject:fromVC];
        if (isPop) {
            for (UIView *view in [bar subviews]) {
                if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                    for (UILabel *label in [view subviews]) {
                        if (![label isKindOfClass:[UILabel class]] || self.item.navigationBarHidden) continue;
                        label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:self.item.navigationBarTitleTextAttributes];
                        break;
                    }
                }
                else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                    for (UIView *sview in [view subviews]) {
                        if (![sview isKindOfClass:[UIVisualEffectView class]]) continue;
                        for (UIView *ssview in [sview subviews]) {
                            if (ssview.alpha < 0.86 && !self.item.navigationBarHidden) {
                                ssview.backgroundColor = self.item.navigationBarTintColor;
                                break;
                            }
                        }
                    }
                }
            }
        }
    } completion:nil];
    self.viewState = MixViewControllerStateViewWillAppear;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.item.disableInteractivePopGesture = self.item.disableInteractivePopGesture;
    self.item.navigationBarBottomLineHidden = self.item.navigationBarBottomLineHidden;
    self.viewState = MixViewControllerStateViewDidAppear;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.viewState = MixViewControllerStateViewWillDisappear;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.viewState = MixViewControllerStateViewDidDisappear;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object != self.item) return;
    UINavigationController *nav = self.vc.navigationController;
    UINavigationBar *navBar = nav.navigationBar;

    if ([keyPath isEqualToString:@"disableInteractivePopGesture"]) {
        BOOL enabled = [nav.viewControllers firstObject] != self.vc && !self.item.disableInteractivePopGesture;
        nav.interactivePopGestureRecognizer.enabled = enabled;
    }
    else if ([keyPath isEqualToString:@"statusBarHidden"]) {
        UIView *view = [[UIApplication sharedApplication] valueForKeyPath:@"statusBarWindow.statusBar"];
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = !self.item.statusBarHidden;
        }];
    }
    else if ([keyPath isEqualToString:@"statusBarStyle"]) {
        [self.vc setNeedsStatusBarAppearanceUpdate];
    }
    else if ([keyPath isEqualToString:@"navigationBarHidden"]) {
        [nav setNavigationBarHidden:self.item.navigationBarHidden animated:YES];
        self.item.navigationBarTitleTextAttributes = self.item.navigationBarTitleTextAttributes;
        self.item.navigationBarTintColor = self.item.navigationBarTintColor;
        self.item.navigationBarBarTintColor = self.item.navigationBarBarTintColor;
        self.item.navigationBarBackgroundImage = self.item.navigationBarBackgroundImage;
        self.item.navigationBarBackImage = self.item.navigationBarBackImage;
    }
    else if ([keyPath isEqualToString:@"navigationBarBottomLineHidden"]) {
        navBar.mixE.bottomLineHidden = self.item.navigationBarBottomLineHidden;
    }
    else if ([keyPath isEqualToString:@"navigationBarTitleTextAttributes"]) {
        if (self.item.navigationBarHidden) return;
        self.vc.navigationController.navigationBar.titleTextAttributes = self.item.navigationBarTitleTextAttributes;
    }
    else if ([keyPath isEqualToString:@"navigationBarTintColor"]) {
        if (self.item.navigationBarHidden) return;
        navBar.tintColor = self.item.navigationBarTintColor;
    }
    else if ([keyPath isEqualToString:@"navigationBarBarTintColor"]) {
        if (self.item.navigationBarHidden) return;
        navBar.barTintColor = self.item.navigationBarBarTintColor;
    }
    else if ([keyPath isEqualToString:@"navigationBarBackgroundImage"]) {
        if (self.item.navigationBarHidden) return;
        [navBar setBackgroundImage:self.item.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else if ([keyPath isEqualToString:@"navigationBarBackImage"]) {
        if (self.item.navigationBarHidden) return;
        navBar.backIndicatorImage = self.item.navigationBarBackImage;
        navBar.backIndicatorTransitionMaskImage = self.item.navigationBarBackImage;
    }
    else if ([keyPath isEqualToString:@"tabBarTintColor"]) {
        [self tabBar].tintColor = self.item.tabBarTintColor;
    }
    else if ([keyPath isEqualToString:@"tabBarBarTintColor"]) {
        [self tabBar].barTintColor = self.item.tabBarBarTintColor;
    }
}

- (UITabBar *)tabBar
{
    NSArray *vcs = self.vc.tabBarController.viewControllers;
    UINavigationController *nav = self.vc.navigationController;
    if (([nav.viewControllers firstObject] == self.vc || [vcs containsObject:self.vc]) && ![self.vc isKindOfClass:[UITabBarController class]]) {
        UITabBar *tabBar = self.vc.tabBarController.tabBar;
        if (!tabBar && [self.vc isKindOfClass:[UITabBarController class]]) {
            tabBar = ((UITabBarController *)self.vc).tabBar;
        }
        return tabBar;
    }
    return nil;
}

- (void)dealloc
{
    [self removeObserverToItem:self.item];
}

@end

@implementation UIViewControllerMixExtention (TopViewController)

+ (UIViewController *)topViewController
{
    UIViewController *avc = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findTopViewController:avc];
}

+ (UIViewController *)findTopViewController:(UIViewController *)vc
{
    UIViewController *avc;
    if (vc.presentedViewController) {
        avc = [self findTopViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        avc = [self findTopViewController:nav.topViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tvc = (UITabBarController *)vc;
        avc = [self findTopViewController:tvc.viewControllers[tvc.selectedIndex]];
    }
    else if ([vc isKindOfClass:[UIViewController class]] && ![vc isKindOfClass:[UIAlertController class]]) {
        avc = vc;
    }
    return avc;
}

@end

@interface UIViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) BOOL mix_hasExtention;

@end

@implementation UIViewController (MixExtention)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mixE_hook_class_swizzleMethodAndStore(self, @selector(viewDidLoad), @selector(_mix_extention_viewDidLoad));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(viewWillAppear:), @selector(_mix_extention_viewWillAppear:));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(viewWillDisappear:), @selector(_mix_extention_viewWillDisappear:));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(viewDidAppear:), @selector(_mix_extention_viewDidAppear:));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(viewDidDisappear:), @selector(_mix_extention_viewDidDisappear:));
        mixE_hook_class_swizzleMethodAndStore(self, @selector(preferredStatusBarStyle), @selector(_mix_extention_preferredStatusBarStyle));
    });
}

- (BOOL)mix_hasExtention
{
    return [self conformsToProtocol:@protocol(UIViewControllerMixExtention)];
}

- (UIViewControllerMixExtention *)mixE
{
    if (!self.mix_hasExtention) return nil;
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[UIViewControllerMixExtention alloc] initWithViewController:self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (void)_mix_extention_viewDidLoad
{
    [self _mix_extention_viewDidLoad];
    if (!self.mix_hasExtention) return;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.mixE viewDidLoad];
}

- (UIStatusBarStyle)_mix_extention_preferredStatusBarStyle
{
    return self.mix_hasExtention ? self.mixE.item.statusBarStyle : [self _mix_extention_preferredStatusBarStyle];
}

- (void)_mix_extention_viewWillAppear:(BOOL)animated
{
    [self _mix_extention_viewWillAppear:animated];
    if (self.mix_hasExtention) [self.mixE viewWillAppear:animated];
}

- (void)_mix_extention_viewWillDisappear:(BOOL)animated
{
    [self _mix_extention_viewWillDisappear:animated];
    if (self.mix_hasExtention) [self.mixE viewWillDisappear:animated];
}

- (void)_mix_extention_viewDidAppear:(BOOL)animated
{
    [self _mix_extention_viewDidAppear:animated];
    if (self.mix_hasExtention) [self.mixE viewDidAppear:animated];
}

- (void)_mix_extention_viewDidDisappear:(BOOL)animated
{
    [self _mix_extention_viewDidDisappear:animated];
    if (self.mix_hasExtention) [self.mixE viewDidDisappear:animated];
}

@end
