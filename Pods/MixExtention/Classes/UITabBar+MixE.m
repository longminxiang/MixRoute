//
//  UITabBar+MixE.m
//
//  Created by Eric Lung on 2018/11/30.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "UITabBar+MixE.h"
#import <objc/runtime.h>

@implementation MixTabBarBugFix

+ (void)load
{
    if (@available(iOS 12.1, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            id (^block)(Class, SEL, IMP)  = ^id(Class originClass, SEL originSEL, IMP originIMP) {
                return ^(UIView *view, CGRect rect) {
                    if ([view isKindOfClass:originClass]) {
                        if (!CGRectIsEmpty(view.frame) && CGRectIsEmpty(rect))  return;
                    }
                    void (*originSelectorIMP)(id, SEL, CGRect) = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(view, originSEL, rect);
                };
            };

            Class class = NSClassFromString(@"UITabBarButton");
            SEL sel = @selector(setFrame:);
            Method originMethod = class_getInstanceMethod(class, sel);
            id impBlock = block(class, sel, method_getImplementation(originMethod));
            method_setImplementation(originMethod, imp_implementationWithBlock(impBlock));
        });
    }
}

@end
