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

@property (nonatomic, assign) BOOL routing;

@property (nonatomic, assign) Class tmpClass;

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

    MixRouteDriverBlock driver = self.drivers[route.name];

    if (!driver) {
        NSLog(@"%@ no driver", route.name);
        return;
    }

    self.routing = YES;
    __weak typeof(self) weaks = self;
    driver(route, ^{
        [weaks.routeQueue removeObjectAtIndex:0];
        weaks.routing = NO;
        [weaks startRouteQueue];
    });
}

@end
