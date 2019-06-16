//
//  MixRoute.m
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 Eric Long. All rights reserved.
//

#import "MixRoute.h"
#import "MixRouteManager.h"

MixRouteQueue const MixRouteGlobalQueue = @"MixRouteGlobalQueue";

@implementation MixRouteModuleRegister

+ (NSMutableDictionary<MixRouteName, MixRouteModuleBlock> *)mutableBlocks
{
    static NSMutableDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [NSMutableDictionary new];
    });
    return dict;
}

+ (NSDictionary<MixRouteName, MixRouteModuleBlock> *)blocks
{
    return [self mutableBlocks];
}

- (void)add:(MixRouteName)name block:(MixRouteModuleBlock)block
{
    if (!name || !block) return;
    [MixRouteModuleRegister mutableBlocks][name] = block;
}

@end
