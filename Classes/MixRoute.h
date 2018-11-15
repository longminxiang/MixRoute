//
//  MixRoute.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *MixRouteName NS_EXTENSIBLE_STRING_ENUM;

FOUNDATION_STATIC_INLINE BOOL MixRouteNameEqual(MixRouteName name, MixRouteName aname) {
    return [name isEqualToString:aname];
}

@protocol MixRouteParams <NSObject>

@end

#define MixRouteConverParams(__protocol, __params, __originParams) \
id<__protocol> __params = (id<__protocol>)__originParams; \
if (![__params conformsToProtocol:@protocol(__protocol)]) __params = nil;

@interface MixRoute : NSObject

@property (nonatomic, readonly) MixRouteName name;
@property (nonatomic, strong) id<MixRouteParams> params;

- (instancetype)initWithName:(MixRouteName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

typedef void (^MixRouteDriverBlock)(MixRoute *route, void (^completion)(void));
typedef void (^MixRouteDriverRegister)(MixRouteName name, MixRouteDriverBlock block);

@interface MixRouteDriver : NSObject

@property (nonatomic, readonly) MixRouteDriverRegister reg;

@end

@protocol MixRouteModule

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver;

@end

@interface MixRouteManager : NSObject

+ (instancetype)shared;

- (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name;

- (void)route:(MixRoute *)route;

- (void)routeTo:(MixRouteName)name;

- (void)routeTo:(MixRouteName)name params:(id<MixRouteParams>)params;

@end
