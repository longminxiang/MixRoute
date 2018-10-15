//
//  MixRouteDefaultDriver.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteDefaultDriver.h"

@implementation MixRouteDefaultModuleDriver
@synthesize route = _route;
@synthesize moduleClass = _moduleClass;

+ (void)load
{
    [[MixRouteManager shared] registerDriver:self forModule:@protocol(MixRouteModule)];
}

- (void)drive:(void (^)(void))completion
{
    if (completion) completion();
}

@end
