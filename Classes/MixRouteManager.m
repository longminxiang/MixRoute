//
//  MixRouteManager.m
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "MixRouteManager.h"
#import <objc/runtime.h>

@interface MixRouteManager ()

@property (nonatomic, readonly) NSDictionary<MixRouteName, MixRouteModuleBlock> *moduleBlockDictionary;
@property (nonatomic, readonly) NSMutableArray<MixRoute *> *routeQueue;

@property (nonatomic, assign) BOOL locked;

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

+ (void)lock
{
    [[self shared] lock];
}

+ (void)unlock
{
    [[self shared] unlock];
}

+ (void)to:(MixRouteName)name
{
    [self to:name params:nil];
}

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params
{
    if (!name) return;
    MixRoute *route = [[MixRoute alloc] initWithName:name];
    route.params = params;
    [self route:route];
}

+ (void)route:(MixRoute *)route
{
    [[self shared] route:route];
}

- (instancetype)init
{
    if (self = [super init]) {
        _routeQueue = [NSMutableArray new];
        
        NSMutableDictionary *moduleBlockDict = [NSMutableDictionary new];
        unsigned int count;
        Class *allClasse = objc_copyClassList(&count);
        for (int i = 0; i < count; i++) {
            Class class = allClasse[i];
            if (class_conformsToProtocol(class, @protocol(MixRouteModule))) {
                MixRouteModuleRegister *reg = [MixRouteModuleRegister new];
                [class mixRouteRegisterModule:reg];
                [moduleBlockDict addEntriesFromDictionary:reg.blockDictionary];
            }
        }
        free(allClasse);
        _moduleBlockDictionary = moduleBlockDict;
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
    if (self.routeQueue.count) [self.routeQueue removeObjectAtIndex:0];
    [self startRouteQueue];
}

- (void)route:(MixRoute *)route
{
    if (!route) return;
    [self.routeQueue addObject:route];
    [self startRouteQueue];
}

- (void)startRouteQueue
{
    if (self.locked) return;
    MixRoute *route = [self.routeQueue firstObject];
    if (!route) return;
    MixRouteModuleBlock block = self.moduleBlockDictionary[route.name];
    block(route);
    if (!self.locked) {
        [self unlock];
    }
}

@end
