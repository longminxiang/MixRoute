//
//  MixRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MixRouteDriver;

typedef NSString* MixRouteName NS_EXTENSIBLE_STRING_ENUM;

@protocol MixRouteParams <NSObject>

@end

#define MIX_ROUTE_PROTOCOL_PARAMS(__protocol, __originParams, __params) \
id<__protocol> __params = (id<__protocol>)__originParams; \
if (![__params conformsToProtocol:@protocol(__protocol)]) __params = nil;

#define MIX_ROUTE_PARAMS(__class, __originParams, __params) \
__class *__params = (__class *)__originParams; \
if (![__params isKindOfClass:[__class class]]) __params = nil;

@protocol MixRouteModule

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver;

@end

@interface MixRoute : NSObject

@property (nonatomic, readonly) MixRouteName name;
@property (nonatomic, strong) id<MixRouteParams> params;

- (instancetype)initWithName:(MixRouteName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

typedef void (^MixRouteDriverBlock)(MixRoute *route);

typedef void (^MixRouteDriverRegister)(MixRouteName name, MixRouteDriverBlock block);

@interface MixRouteDriver : NSObject

@property (nonatomic, readonly) MixRouteDriverRegister reg;

@end

@interface MixRouteManager : NSObject

+ (void)lock;

+ (void)unlock;

+ (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name;

+ (void)route:(MixRoute *)route;

+ (void)to:(MixRouteName)name;

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params;

@end
