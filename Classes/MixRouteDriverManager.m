//
//  MixRouteDriverManager.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixRouteDriverManager.h"
#import <objc/runtime.h>

@interface MixRouteDriverManager ()

@property (nonatomic, readonly) NSMutableDictionary<NSString *, Class<MixRouteModuleDriver>> *drivers;

@end

@implementation MixRouteDriverManager

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
    }
    return self;
}

- (void)registerDriver:(Class<MixRouteModuleDriver>)driverClass forModule:(Protocol *)moduleProtocol
{
    NSString *name = [self getProtocolName:moduleProtocol];
    self.drivers[name] = driverClass;
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

- (Class<MixRouteModuleDriver>)getDriverWithModule:(Class<MixRouteModule>)moduleClass
{
    NSString *protocolName = [self getProtocolNameWithModule:moduleClass];
    Class<MixRouteModuleDriver> driver = self.drivers[protocolName];
    return driver;
}

@end
