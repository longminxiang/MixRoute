//
//  MixRouteDefaultDriver.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteDefaultDriver.h"

@implementation MixRouteDefaultModuleDriver

+ (void)load
{
    [[MixRouteDriverManager shared] registerDriver:self forModule:@protocol(MixRouteModule)];
}

+ (void)module:(Class<MixRouteModule>)module driveRoute:(__kindof  id<MixRoute>)route completion:(void (^)(__kindof  id<MixRoute>))completion
{
    if (completion) completion(route);
}

@end
