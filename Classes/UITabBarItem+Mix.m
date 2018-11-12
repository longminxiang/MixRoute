//
//  UITabBarItem+Mix.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/12.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "UITabBarItem+Mix.h"
#import <objc/runtime.h>

@implementation MixTabBarItem

@end

@implementation UITabBarItem (MixTabBarItem)

- (MixTabBarItem *)mix
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [MixTabBarItem new];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end

@interface MixTabBarItemManager ()

@property (nonatomic, weak) UIViewController *vc;

@end

@implementation MixTabBarItemManager

- (instancetype)initWithViewController:(UIViewController *)vc
{
    if (self = [super init]) {
        self.vc = vc;
        MixTabBarItem *item = self.vc.tabBarItem.mix;
        for (NSString *keyPath in [self mixItemKeyPaths]) {
            [item addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:NULL];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    MixTabBarItem *item = self.vc.tabBarItem.mix;
    for (NSString *keyPath in [self mixItemKeyPaths]) {
        void *context = NULL;
        [self observeValueForKeyPath:keyPath ofObject:item change:nil context:context];
    }
}

- (NSArray *)mixItemKeyPaths
{
    NSArray *keyPaths = @[@"barTintColor"];
    return keyPaths;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSArray *vcs = self.vc.tabBarController.viewControllers;
    UINavigationController *nav = self.vc.navigationController;
    if (([vcs containsObject:nav] && [nav.viewControllers firstObject] != self.vc) && ![vcs containsObject:self.vc] && ![self.vc isKindOfClass:[UITabBarController class]]) return;

    MixTabBarItem *item = self.vc.tabBarItem.mix;
    if (object != item) return;
    UITabBar *tabBar = self.vc.tabBarController.tabBar;
    if (!tabBar && [self.vc isKindOfClass:[UITabBarController class]]) {
        tabBar = ((UITabBarController *)self.vc).tabBar;
    }
    MixTabBarItem *titem = self.vc.tabBarController.tabBarItem.mix;

    if ([keyPath isEqualToString:@"barTintColor"]) {
        UIColor *color = item.barTintColor;
        if (!color) color = titem.barTintColor;
        tabBar.barTintColor = color;
    }
}

- (void)dealloc
{
    MixTabBarItem *item = self.vc.tabBarItem.mix;
    for (NSString *keyPath in [self mixItemKeyPaths]) {
        [item removeObserver:self forKeyPath:keyPath];
    }
}

@end
