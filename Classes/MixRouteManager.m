//
//  MixRouteManager.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteManager.h"
#import <objc/runtime.h>

@interface MixRouteManager ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, Class<MixRouteModule>> *modules;
@property (nonatomic, readonly) NSMutableArray<MixRoute *> *routeQueue;

@property (nonatomic, assign) BOOL routing;

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
        _modules = [NSMutableDictionary new];
        _routeQueue = [NSMutableArray new];
    }
    return self;
}

- (void)registerModule:(Class<MixRouteModule>)moduleClass forName:(MixRouteName)name
{
    self.modules[name] = moduleClass;
}

- (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name
{
    return self.modules[name];
}

- (void)routeTo:(MixRouteName)name
{
    [self routeTo:name params:nil];
}

- (void)routeTo:(MixRouteName)name params:(id<MixRouteParams>)params
{
    if (!name) return;
    MixRoute *route = [[MixRoute alloc] initWithName:name];
    route.params = params;
    [self route:route];
}

- (void)route:(MixRoute *)route
{
    if (!route) return;
    [self.routeQueue addObject:route];
    [self startRouteQueue];
}

- (void)startRouteQueue
{
    if (self.routing) return;
    MixRoute *route = [self.routeQueue firstObject];
    if (!route) return;

    Class<MixRouteModule> module = [self moduleClassWithName:route.name];
    if (!module) {
        NSLog(@"%@ not register", route.name);
        return;
    }
    if (![(id)module respondsToSelector:@selector(drive:completion:)]) {
        NSLog(@"%@ no drive method", route.name);
        return;
    }

    self.routing = YES;
    __weak typeof(self) weaks = self;
    [module drive:route completion:^{
        [weaks.routeQueue removeObjectAtIndex:0];
        weaks.routing = NO;
        [weaks startRouteQueue];
    }];
}

@end
