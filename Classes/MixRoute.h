//
//  MixRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MixRoute;

typedef NSString* MixRouteName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_STATIC_INLINE MixRouteName MixRouteNameFrom(NSString *name) {
    if (!name || [[name stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] isEqualToString:@""]) return nil;
    if (![name hasPrefix:@"MixRouteName"]) {
        name = [@"MixRouteName" stringByAppendingString:name];
    }
    return name;
}

@protocol MixRouteParams <NSObject>

@end

#define MIX_ROUTE_PROTOCOL_PARAMS(__protocol, __originParams, __params) \
id<__protocol> __params = (id<__protocol>)__originParams; \
if (![__params conformsToProtocol:@protocol(__protocol)]) __params = nil;

#define MIX_ROUTE_PARAMS(__class, __originParams, __params) \
__class *__params = (__class *)__originParams; \
if (![__params isKindOfClass:[__class class]]) __params = nil;

typedef void (^MixRouteModuleBlock)(MixRoute *route);

@interface MixRouteModuleRegister : NSObject

@property (nonatomic, readonly) NSDictionary<MixRouteName, MixRouteModuleBlock> *blockDictionary;

- (void)add:(MixRouteName)name block:(MixRouteModuleBlock)block;

@end

@protocol MixRouteModule

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg;

@end

@interface MixRoute : NSObject

@property (nonatomic, readonly) MixRouteName name;
@property (nonatomic, strong) id<MixRouteParams> params;

- (instancetype)initWithName:(MixRouteName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
