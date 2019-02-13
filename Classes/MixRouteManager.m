//
//  MixRouteManager.m
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "MixRouteManager.h"
#import <objc/runtime.h>

MixRouteQueue const MixRouteGlobalQueue = @"MixRouteGlobalQueue";

@implementation MixRouteParams

@end

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

@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixRouteModuleBlock> *blockDictionary;

@end

@implementation MixRouteModuleRegister

+ (instancetype)shared
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [self new];
    });
    return obj;
}

- (void)add:(MixRouteName)name block:(MixRouteModuleBlock)block
{
    if (!name || !block) return;
    if (!_blockDictionary) _blockDictionary = [NSMutableDictionary new];
    _blockDictionary[name] = block;
}

@end

@interface MixRouteQueueManager : NSObject

@property (nonatomic, readonly) NSMutableArray<MixRoute *> *routes;

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

- (void)addRoute:(MixRoute *)route
{
    if (!route) return;
    [self.routes addObject:route];
    [self start];
}

- (void)start
{
    MixRoute *route = [self.routes firstObject];
    if (!route) return;
    if (self.locked) return;
    MixRouteModuleBlock block = [MixRouteModuleRegister shared].blockDictionary[route.name];
    block(route);
    if (!self.locked) {
        [self unlock];
    }
}

@end

@interface MixRouteManager ()

@property (nonatomic, readonly) NSMutableDictionary<MixRouteQueue, MixRouteQueueManager *> *queueManagers;

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

+ (void)route:(MixRoute *)route
{
    if (!route) return;
    MixRouteQueueManager *manager = [[self shared] queueManager:route.queue];
    [manager addRoute:route];
}

- (instancetype)init
{
    if (self = [super init]) {
        _queueManagers = [NSMutableDictionary new];
        
        unsigned int count;
        Class *allClasse = objc_copyClassList(&count);
        for (int i = 0; i < count; i++) {
            Class class = allClasse[i];
            if (class_conformsToProtocol(class, @protocol(MixRouteModule))) {
                [class mixRouteRegisterModule:[MixRouteModuleRegister shared]];
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
