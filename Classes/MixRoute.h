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

@protocol MixRoute

@property (nonatomic, readonly) MixRouteName name;

@property (nonatomic, strong) id params;

- (instancetype)initWithName:(MixRouteName)name;

@end

@protocol MixRouteModule

+ (void)prepareRoute:(id<MixRoute>)aroute;

@end

@protocol MixRouteModuleDriver

@property (nonatomic, strong) id<MixRoute> route;

@property (nonatomic, assign) Class<MixRouteModule> moduleClass;

- (void)drive:(void (^)(void))completion;

@end
