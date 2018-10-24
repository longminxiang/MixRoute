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

@interface MixRoute : NSObject

@property (nonatomic, readonly) MixRouteName name;
@property (nonatomic, strong) id params;

- (instancetype)initWithName:(MixRouteName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@protocol MixRouteModule

@end

@protocol MixRouteModuleDriver

- (void)drive:(MixRoute *)route completion:(void (^)(void))completion;

@end

#define MixRegisterRouteModule(__name) \
+ (void)load { \
    [[MixRouteManager shared] registerModule:self forName:__name]; \
}
