//
//  UINavigationItem+Mix.m
//  MixRoute
//
//  Created by Eric Lung on 2018/11/5.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "UINavigationItem+Mix.h"
#import <objc/runtime.h>

@interface UINavigationItem ()

@property (nonatomic, readonly) NSMutableDictionary *mix_properties;

@end

@implementation UINavigationItem (MixRoute)

- (NSMutableDictionary *)mix_properties
{
    id obj = objc_getAssociatedObject(self, _cmd);
    if (!obj) {
        obj = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _cmd, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

#define _MIX_PROPERTY(__name, __type) \
- (__type)mix_##__name \
{ \
    return self.mix_properties[@#__name]; \
} \
- (void)setMix_##__name:(__type)mix_##__name \
{ \
    if (mix_##__name) { \
        self.mix_properties[@#__name] = mix_##__name; \
    } \
    else { \
        [self.mix_properties removeObjectForKey:@#__name]; \
    } \
}

#define _MIX_NUM_PROPERTY(__name, __type, __valType) \
- (__type)mix_##__name \
{ \
    if (!self.mix_properties[@#__name]) return 0; \
    return [self.mix_properties[@#__name] __valType##Value]; \
} \
- (void)setMix_##__name:(__type)mix_##__name \
{ \
    self.mix_properties[@#__name] = @(mix_##__name); \
}

_MIX_PROPERTY(titleTextAttributes, NSDictionary *)
_MIX_PROPERTY(barTintColor, UIColor *)
_MIX_PROPERTY(barHidden, NSNumber *)
_MIX_NUM_PROPERTY(disableInteractivePopGesture, BOOL, bool)
_MIX_PROPERTY(statusBarStyle, NSNumber *)

@end
