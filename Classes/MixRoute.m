//
//  MixRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRoute.h"
#import <objc/runtime.h>

@implementation MixRoute

- (instancetype)initWithName:(MixRouteName)name
{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ delloc", NSStringFromClass([self class]));
}

@end
