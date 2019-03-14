//
//  MixExtentionHooker.h
//  MixExtention
//
//  Created by Eric Lung on 2019/3/13.
//  Copyright © 2019 Mix. All rights reserved.
//

#import <Foundation/Foundation.h>

void mixE_hook_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector);
