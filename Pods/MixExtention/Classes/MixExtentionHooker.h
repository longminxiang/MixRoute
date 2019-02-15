//
//  MixExtentionHooker.h
//  MixExtention
//
//  Created by Eric Lung on 2019/2/15.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

FOUNDATION_STATIC_INLINE void mix_extention_hook_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector)
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
