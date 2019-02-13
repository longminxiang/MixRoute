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

@interface MixRouteModuleRegister ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixRouteModuleBlock> *blockMutableDictionary;

@end

@implementation MixRouteModuleRegister

- (instancetype)init
{
    if (self = [super init]) {
        _blockMutableDictionary = [NSMutableDictionary new];
    }
    return self;
}

- (NSDictionary<MixRouteName, MixRouteModuleBlock> *)blockDictionary
{
    return self.blockMutableDictionary;
}

- (void)add:(MixRouteName)name block:(MixRouteModuleBlock)block
{
    if (!name || !block) return;
    _blockMutableDictionary[name] = block;
}

@end
