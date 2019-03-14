//
//  UINavigationBar+MixE.m
//  MixExtention
//
//  Created by Eric Lung on 2019/3/13.
//  Copyright © 2019 Mix. All rights reserved.
//

#import "UINavigationBar+MixE.h"
#import <objc/runtime.h>

@interface UINavigationBarMixExtention ()

@property (nonatomic, weak) UINavigationBar *bar;

@end

@implementation UINavigationBarMixExtention

- (instancetype)initWithNavigationBar:(UINavigationBar *)bar
{
    if (self = [super init]) {
        self.bar = bar;
    }
    return self;
}

- (void)setBottomLineHidden:(BOOL)bottomLineHidden
{
    _bottomLineHidden = bottomLineHidden;
    [self bottomLineView].hidden = bottomLineHidden;
}

- (UIView *)bottomLineView
{
    for (UIView *view in self.bar.subviews) {
        if (![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) continue;
        for (UIView *sview in view.subviews) {
            if (sview.frame.size.height > 1) continue;
            return sview;
        }
    }
    return nil;
}

@end

@implementation UINavigationBar (MixE)

- (UINavigationBarMixExtention *)mixE
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [[UINavigationBarMixExtention alloc] initWithNavigationBar:self];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

@end
