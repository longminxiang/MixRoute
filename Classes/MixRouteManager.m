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
@property (nonatomic, readonly) NSMutableDictionary<NSString *, Class<MixRouteModuleDriver>> *drivers;
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
        _drivers = [NSMutableDictionary new];
        _modules = [NSMutableDictionary new];
        _routeQueue = [NSMutableArray new];
    }
    return self;
}

- (void)registerModule:(Class<MixRouteModule>)moduleClass forName:(MixRouteName)name
{
    self.modules[name] = moduleClass;
}

- (void)registerDriver:(Class<MixRouteModuleDriver>)driverClass forModule:(Protocol *)moduleProtocol
{
    NSString *name = [self getProtocolName:moduleProtocol];
    self.drivers[name] = [[(Class)driverClass alloc] init];
}

- (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name
{
    return self.modules[name];
}

- (NSString *)getProtocolName:(Protocol *)protocol
{
    NSString *name = [NSString stringWithCString:protocol_getName(protocol) encoding:NSUTF8StringEncoding];
    return name;
}

- (NSString *)getProtocolNameWithModule:(Class<MixRouteModule>)moduleClass
{
    u_int count;
    Protocol* __unsafe_unretained *protocols = class_copyProtocolList(moduleClass, &count);
    for (int i = 0; i < count; i++) {
        Protocol *protocol = protocols[i];
        if (!protocol_conformsToProtocol(protocol, @protocol(MixRouteModule))) continue;
        NSString *name = [self getProtocolName:protocol];
        NSLog(@"%@", name);
        return name;
    }
    return nil;
}

- (id<MixRouteModuleDriver>)driverWithRoute:(MixRoute *)route
{
    Class<MixRouteModule> moduleClass = [self moduleClassWithName:route.name];
    NSString *moduleProtocolName = [self getProtocolNameWithModule:moduleClass];
    id<MixRouteModuleDriver> driver = self.drivers[moduleProtocolName];
    return driver;
}

- (void)routeTo:(MixRouteName)name
{
    if (!name) return;
    MixRoute *route = [[MixRoute alloc] initWithName:name];
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

    self.routing = YES;
    id<MixRouteModuleDriver> driver = [self driverWithRoute:route];
    NSAssert(driver, @"no driver");
    
    __weak typeof(self) weaks = self;
    [driver drive:route completion:^{
        [weaks.routeQueue removeObjectAtIndex:0];
        weaks.routing = NO;
        [weaks startRouteQueue];
    }];
}

@end
