//
//  MixRouteManager.m
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 Eric Lung. All rights reserved.
//

#import "MixRouteManager.h"
#import <objc/runtime.h>

@class MixRouteQueueManager;

@interface MixRouteManager ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteQueue, MixRouteQueueManager *> *queueManagers;

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixRouteModuleBlock> *mutableBlocks;

@property (nonatomic, readonly) NSMutableSet<Class<MixRouteMiddleware>> *middlewareClasses;

+ (MixRouteManager *)shared;

@end

@interface MixRouteQueueManager : NSObject

@property (nonatomic, readonly) NSMutableArray<id<MixRoute>> *routes;

@property (nonatomic, readonly) MixRouteQueue queue;

@property (nonatomic, assign) BOOL locked;

@end

@implementation MixRouteQueueManager

- (instancetype)initWithQueue:(MixRouteQueue)queue
{
    if (self = [super init]) {
        _queue = queue;
        _routes = [NSMutableArray new];
    }
    return self;
}

- (void)lock
{
    self.locked = YES;
}

- (void)unlock
{
    self.locked = NO;
    [self.routes removeObjectAtIndex:0];
    [self start];
}

- (void)addRoute:(id<MixRoute>)route
{
    if (!route) return;
    [self.routes addObject:route];
    [self start];
}

- (void)start
{
    id<MixRoute> route = [self.routes firstObject];
    if (!route) return;
    if (self.locked) return;
    for (Class<MixRouteMiddleware> middlewareClass in [MixRouteManager shared].middlewareClasses) {
        [middlewareClass mixRoutePrestart:route];
    }
    MixRouteModuleBlock block = [MixRouteModuleRegister blocks][route.routeName];
    if (block) block(route);
    if (!self.locked) {
        [self unlock];
    }
}

@end

@implementation MixRouteManager

+ (MixRouteManager *)shared
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

+ (NSDictionary<MixRouteName, MixRouteModuleBlock> *)blocks
{
    return [self shared].mutableBlocks;
}

+ (void)lock:(MixRouteQueue)queue
{
    MixRouteQueueManager *manager = [[self shared] queueManager:queue];
    [manager lock];
}

+ (void)unlock:(MixRouteQueue)queue
{
    MixRouteQueueManager *manager = [[self shared] queueManager:queue];
    [manager unlock];
}

+ (void)route:(id<MixRoute>)route
{
    if (!route) return;
    MixRouteQueueManager *manager = [[self shared] queueManager:route.routeQueue];
    [manager addRoute:route];
}

- (instancetype)init
{
    if (self = [super init]) {
        _queueManagers = [NSMutableDictionary new];
        _mutableBlocks = [NSMutableDictionary new];
        _middlewareClasses = [NSMutableSet new];
        
        MixRouteModuleRegister *reg = [MixRouteModuleRegister new];
        unsigned int count;
        Class *allClasse = objc_copyClassList(&count);
        for (int i = 0; i < count; i++) {
            Class class = allClasse[i];
            if (class_conformsToProtocol(class, @protocol(MixRouteModule))) {
                [class mixRouteRegisterModule:reg];
            }
            if (class_conformsToProtocol(class, @protocol(MixRouteMiddleware))) {
                [_middlewareClasses addObject:class];
            }
        }
        free(allClasse);
    }
    return self;
}

- (MixRouteQueueManager *)queueManager:(MixRouteQueue)queue
{
    if (!queue) queue = MixRouteGlobalQueue;
    MixRouteQueueManager *manager = self.queueManagers[queue];
    if (!manager) {
        manager = [[MixRouteQueueManager alloc] initWithQueue:queue];
        self.queueManagers[queue] = manager;
    }
    return manager;
}

@end
