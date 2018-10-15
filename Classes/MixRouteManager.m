//
//  MixRouteManager.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteManager.h"
#import <objc/runtime.h>
#import "MixRouteDriverManager.h"

@interface MixRouteManager ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, Class<MixRouteModule>> *modules;
@property (nonatomic, readonly) NSMutableArray<id<MixRoute>> *routeQueue;

@end

@implementation MixRouteManager

+ (instancetype)shared
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        _routeQueue = [NSMutableArray new];
        _modules = [NSMutableDictionary new];
    }
    return self;
}

- (void)registerModule:(Class<MixRouteModule>)moduleClass forName:(MixRouteName)name
{
    self.modules[name] = moduleClass;
}

- (void)route:(id<MixRoute>)route
{
    if (!route) return;
    [self.routeQueue addObject:route];
    [self startRouteQueue];
}

- (void)startRouteQueue
{
    id<MixRoute> route = [self.routeQueue firstObject];
    if (!route) return;

    Class<MixRouteModule> module = self.modules[route.name];
    [module prepareRoute:route];

    Class<MixRouteModuleDriver> driver = [[MixRouteDriverManager shared] getDriverWithModule:module];

    __weak typeof(self) weaks = self;
    [driver module:module driveRoute:route completion:^(id<MixRoute> aroute){
        [weaks.routeQueue removeObject:aroute];
        [weaks startRouteQueue];
    }];
}

@end
