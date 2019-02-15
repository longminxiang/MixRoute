//
//  UIViewController+MixExtention.m
//  MixExtention
//
//  Created by Eric Lung on 2019/2/14.
//  Copyright © 2019 Mix. All rights reserved.
//

#import "UIViewController+MixExtention.h"
#import "MixExtentionHooker.h"

@implementation UIViewControllerMixExtentionAttributes

+ (NSArray<NSString *> *)keyPaths
{
    return @[@"disableInteractivePopGesture", @"statusBarHidden", @"statusBarStyle", @"navigationBarHidden",
             @"navigationBarTintColor", @"navigationBarBarTintColor", @"navigationBarTitleTextAttributes",
             @"navigationBarBackImage", @"navigationBarBackgroundImage", @"tabBarTintColor", @"tabBarBarTintColor"];
}

@end

@interface UIViewControllerMixExtention ()

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation UIViewControllerMixExtention

- (instancetype)initWithViewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.vc = vc;
    }
    return self;
}

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

- (void)setViewWillAppear:(BOOL)viewWillAppear
{
    _viewWillAppear = viewWillAppear;
}

- (void)setViewDidAppear:(BOOL)viewDidAppear
{
    _viewDidAppear = viewDidAppear;
}

- (void)setAttributes:(UIViewControllerMixExtentionAttributes *)attributes
{
    if (_attributes) {
        for (NSString *keyPath in [UIViewControllerMixExtentionAttributes keyPaths]) {
            [_attributes removeObserver:self forKeyPath:keyPath];
        }
    }
    _attributes = attributes;
    for (NSString *keyPath in [UIViewControllerMixExtentionAttributes keyPaths]) {
        [_attributes addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationController *nav = self.vc.navigationController;
    UINavigationBar *bar = nav.navigationBar;

    [self setupStatusBarHidden];
    [self setupStatusBarStyle];
    [self setupNavigationBarHidden];
    [self setupTabBarTintColor];
    [self setupTabBarBarTintColor];

    [self.vc.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        BOOL isPop = ![nav.viewControllers containsObject:fromVC];
        if (!isPop) return ;

        for (UIView *view in [bar subviews]) {
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                for (UILabel *label in [view subviews]) {
                    if (![label isKindOfClass:[UILabel class]] || self.attributes.navigationBarHidden) continue;
                    label.attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:self.attributes.navigationBarTitleTextAttributes];
                    break;
                }
            }
            else if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                for (UIView *sview in [view subviews]) {
                    if (![sview isKindOfClass:[UIVisualEffectView class]]) continue;
                    for (UIView *ssview in [sview subviews]) {
                        if (ssview.alpha < 0.86 && !self.attributes.navigationBarHidden) {
                            ssview.backgroundColor = self.attributes.navigationBarTintColor;
                            break;
                        }
                    }
                }
            }
        }
    } completion:nil];
    self.viewWillAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setupDisableInteractivePopGesture];
    self.viewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.viewWillAppear = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.viewDidAppear = NO;
}

- (void)setupDisableInteractivePopGesture
{
    BOOL enabled = [self.vc.navigationController.viewControllers firstObject] != self.vc && !self.attributes.disableInteractivePopGesture;
    self.vc.navigationController.interactivePopGestureRecognizer.enabled = enabled;
}

- (void)setupStatusBarHidden
{
    UIView *view = [[UIApplication sharedApplication] valueForKeyPath:@"statusBarWindow.statusBar"];
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = !self.attributes.statusBarHidden;
    }];
}

- (void)setupStatusBarStyle
{
    [self.vc setNeedsStatusBarAppearanceUpdate];
}

- (void)setupNavigationBarHidden
{
    BOOL hidden = self.attributes.navigationBarHidden;
    [self.vc.navigationController setNavigationBarHidden:hidden animated:YES];
    [self setupNavigationBarTitleTextAttributes];
    [self setupNavigationBarTintColor];
    [self setupNavigationBarBarTintColor];
    [self setupNavigationBarBackgroundImage];
    [self setupNavigationBarBackImage];
}

- (void)setupNavigationBarTitleTextAttributes
{
    if (self.attributes.navigationBarHidden) return;
    self.vc.navigationController.navigationBar.titleTextAttributes = self.attributes.navigationBarTitleTextAttributes;
}

- (void)setupNavigationBarTintColor
{
    if (self.attributes.navigationBarHidden) return;
    self.vc.navigationController.navigationBar.tintColor = self.attributes.navigationBarTintColor;
}

- (void)setupNavigationBarBarTintColor
{
    if (self.attributes.navigationBarHidden) return;
    self.vc.navigationController.navigationBar.barTintColor = self.attributes.navigationBarBarTintColor;
}

- (void)setupNavigationBarBackgroundImage
{
    if (self.attributes.navigationBarHidden) return;
    [self.vc.navigationController.navigationBar setBackgroundImage:self.attributes.navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setupNavigationBarBackImage
{
    if (self.attributes.navigationBarHidden) return;
    self.vc.navigationController.navigationBar.backIndicatorImage = self.attributes.navigationBarBackImage;
    self.vc.navigationController.navigationBar.backIndicatorTransitionMaskImage = self.attributes.navigationBarBackImage;
}

- (void)setupTabBarTintColor
{
    [self tabBar].tintColor = self.attributes.tabBarTintColor;
}

- (void)setupTabBarBarTintColor
{
    [self tabBar].barTintColor = self.attributes.tabBarBarTintColor;
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self.attributes) {
        if ([keyPath isEqualToString:@"disableInteractivePopGesture"]) [self setupDisableInteractivePopGesture];
        else if ([keyPath isEqualToString:@"statusBarHidden"]) [self setupStatusBarHidden];
        else if ([keyPath isEqualToString:@"statusBarStyle"]) [self setupStatusBarStyle];
        else if ([keyPath isEqualToString:@"navigationBarHidden"]) [self setupNavigationBarHidden];
        else if ([keyPath isEqualToString:@"navigationBarTitleTextAttributes"]) [self setupNavigationBarTitleTextAttributes];
        else if ([keyPath isEqualToString:@"navigationBarTintColor"]) [self setupNavigationBarTintColor];
        else if ([keyPath isEqualToString:@"navigationBarBarTintColor"]) [self setupNavigationBarBarTintColor];
        else if ([keyPath isEqualToString:@"navigationBarBackgroundImage"]) [self setupNavigationBarBackgroundImage];
        else if ([keyPath isEqualToString:@"navigationBarBackImage"]) [self setupNavigationBarBackImage];
        else if ([keyPath isEqualToString:@"tabBarTintColor"]) [self setupTabBarTintColor];
        else if ([keyPath isEqualToString:@"tabBarBarTintColor"]) [self setupTabBarBarTintColor];
    }
}

- (void)dealloc
{
    for (NSString *keyPath in [UIViewControllerMixExtentionAttributes keyPaths]) {
        [self.attributes removeObserver:self forKeyPath:keyPath];
    }
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
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(viewDidLoad), @selector(_mix_extention_viewDidLoad));
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(viewWillAppear:), @selector(_mix_extention_viewWillAppear:));
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(viewWillDisappear:), @selector(_mix_extention_viewWillDisappear:));
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(viewDidAppear:), @selector(_mix_extention_viewDidAppear:));
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(viewDidDisappear:), @selector(_mix_extention_viewDidDisappear:));
        mix_extention_hook_class_swizzleMethodAndStore(self, @selector(preferredStatusBarStyle), @selector(_mix_extention_preferredStatusBarStyle));
    });
}

- (BOOL)mix_hasExtention
{
    return [self conformsToProtocol:@protocol(UIViewControllerMixExtention)];
}

- (UIViewControllerMixExtention *)mix_extention
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
}

- (UIStatusBarStyle)_mix_extention_preferredStatusBarStyle
{
    return self.mix_hasExtention ? self.mix_extention.attributes.statusBarStyle : [self _mix_extention_preferredStatusBarStyle];
}

- (void)_mix_extention_viewWillAppear:(BOOL)animated
{
    [self _mix_extention_viewWillAppear:animated];
    if (self.mix_hasExtention) [self.mix_extention viewWillAppear:animated];
}

- (void)_mix_extention_viewWillDisappear:(BOOL)animated
{
    [self _mix_extention_viewWillDisappear:animated];
    if (self.mix_hasExtention) [self.mix_extention viewWillDisappear:animated];
}

- (void)_mix_extention_viewDidAppear:(BOOL)animated
{
    [self _mix_extention_viewDidAppear:animated];
    if (self.mix_hasExtention) [self.mix_extention viewDidAppear:animated];
}

- (void)_mix_extention_viewDidDisappear:(BOOL)animated
{
    [self _mix_extention_viewDidDisappear:animated];
    if (self.mix_hasExtention) [self.mix_extention viewDidDisappear:animated];
}

@end
