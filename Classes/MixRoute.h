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

FOUNDATION_STATIC_INLINE BOOL MixRouteNameEqual(MixRouteName name, MixRouteName aname) {
    return [name isEqualToString:aname];
}

@protocol MixRouteParams <NSObject>

@end

#define MIX_ROUTE_PROTOCOL_PARAMS(__protocol, __originParams, __params) \
id<__protocol> __params = (id<__protocol>)__originParams; \
if (![__params conformsToProtocol:@protocol(__protocol)]) __params = nil;

#define MIX_ROUTE_PARAMS(__class, __originParams, __params) \
__class *__params = (__class *)__originParams; \
if (![__params isKindOfClass:[__class class]]) __params = nil;

@protocol MixRouteModule

+ (NSArray<MixRouteName> *)mixRouteRegisterModules;

+ (void)mixRouteFire:(MixRoute *)route;

@end

@interface MixRoute : NSObject

@property (nonatomic, readonly) MixRouteName name;
@property (nonatomic, strong) id<MixRouteParams> params;

- (instancetype)initWithName:(MixRouteName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
