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
@property (nonatomic, readonly) NSMutableArray<id<MixRouteModuleDriver>> *driverQueue;

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
        _driverQueue = [NSMutableArray new];
        _modules = [NSMutableDictionary new];
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
    self.drivers[name] = driverClass;
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

- (void)route:(id<MixRoute>)route
{
    if (!route) return;
    Class<MixRouteModule> moduleClass = self.modules[route.name];
    NSString *protocolName = [self getProtocolNameWithModule:moduleClass];
    Class driverClass = self.drivers[protocolName];
    id<MixRouteModuleDriver> driver = [[driverClass alloc] init];
    driver.route = route;
    driver.moduleClass = moduleClass;
    [self.driverQueue addObject:driver];
    [self startDriverQueue];
}

- (void)startDriverQueue
{
    id<MixRouteModuleDriver> driver = [self.driverQueue firstObject];
    if (!driver) return;
    
    [driver.moduleClass prepareRoute:driver.route];
    
    __weak typeof(self) weaks = self;
    __weak typeof(driver) wd = driver;
    [driver drive:^{
        [weaks.driverQueue removeObject:wd];
        [weaks startDriverQueue];
    }];
}

@end
