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

@protocol MixRouteModule

@optional

+ (void)drive:(MixRoute *)route completion:(void (^)(void))completion;

@end

#define MixRegisterRouteModule(__name) \
+ (void)load { \
    [[MixRouteManager shared] registerModule:self forName:__name]; \
}
