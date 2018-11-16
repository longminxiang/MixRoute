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

@implementation MixRouteDriver

- (void)setReg:(MixRouteDriverRegister)reg
{
    _reg = reg;
}

@end

@interface MixRouteManager ()

@property (nonatomic, readonly) MixRouteDriver *driver;
@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, Class<MixRouteModule>> *modules;
@property (nonatomic, readonly) NSMutableDictionary<MixRouteName, MixRouteDriverBlock> *drivers;
@property (nonatomic, readonly) NSMutableArray<MixRoute *> *routeQueue;

@property (nonatomic, assign) Class tmpClass;

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

+ (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name
{
    return [self shared].modules[name];
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
        _modules = [NSMutableDictionary new];
        _drivers = [NSMutableDictionary new];
        _routeQueue = [NSMutableArray new];
        _driver = [MixRouteDriver new];
        __weak typeof(self) weaks = self;
        _driver.reg = ^(MixRouteName name, MixRouteDriverBlock block) {
            weaks.drivers[name] = block;
            if (weaks.tmpClass) weaks.modules[name] = weaks.tmpClass;
        };
        [self lookupAllClass];
    }
    return self;
}

- (void)lookupAllClass
{
    unsigned int count;
    Class *allClasse = objc_copyClassList(&count);
    for (int i = 0; i < count; i++) {
        Class class = allClasse[i];
        if (class_conformsToProtocol(class, @protocol(MixRouteModule))) {
            self.tmpClass = class;
            [class mixRouteRegisterDriver:self.driver];
        }
    }
    free(allClasse);
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

    MixRouteDriverBlock driver = self.drivers[route.name];

    if (!driver) {
        NSLog(@"%@ no driver", route.name);
        return;
    }
    driver(route);
    if (!self.locked) {
        [self unlock];
    }
}

@end
