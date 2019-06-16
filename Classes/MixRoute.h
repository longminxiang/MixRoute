//
//  MixRoute.h
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 Eric Long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString* MixRouteName NS_EXTENSIBLE_STRING_ENUM;

typedef NSString* MixRouteQueue NS_EXTENSIBLE_STRING_ENUM;

#define MIX_ROUTE_NAME(__name) static MixRouteName const MixRouteName##__name = @"MixRouteName" #__name;

FOUNDATION_EXTERN MixRouteQueue const MixRouteGlobalQueue;

FOUNDATION_STATIC_INLINE MixRouteName MixRouteNameFrom(NSString *name) {
    if (!name || [[name stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] isEqualToString:@""]) return nil;
    if (![name hasPrefix:@"MixRouteName"]) {
        name = [@"MixRouteName" stringByAppendingString:name];
    }
    return name;
}

FOUNDATION_STATIC_INLINE MixRouteQueue MixRouteQueueFrom(NSString *name) {
    if (!name || [[name stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet] isEqualToString:@""]) return nil;
    if (![name hasPrefix:@"MixRouteQueue"]) {
        name = [@"MixRouteQueue" stringByAppendingString:name];
    }
    return name;
}

@protocol MixRouteParams <NSObject>

@end

@protocol MixRoute <NSObject>

@property (nonatomic, readonly) MixRouteName routeName;
@property (nonatomic, readonly) id<MixRouteParams> routeParams;

@property (nonatomic, readonly) MixRouteQueue routeQueue;

@end

@protocol MixRouteMiddleware <NSObject>

+ (void)mixRoutePrestart:(id<MixRoute>)route;

@end

typedef void (^MixRouteModuleBlock)(id<MixRoute> route);

@interface MixRouteModuleRegister : NSObject

+ (NSDictionary<MixRouteName, MixRouteModuleBlock> *)blocks;

- (void)add:(MixRouteName)name block:(MixRouteModuleBlock)block;

@end

@protocol MixRouteModule

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg;

@end
