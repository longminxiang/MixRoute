//
//  MixRouteDriverManager.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixRoute.h"

@protocol MixRouteModuleDriver

+ (void)module:(Class<MixRouteModule>)module driveRoute:(__kindof id<MixRoute>)route completion:(void (^)(__kindof id<MixRoute> aroute))completion;

@end

@interface MixRouteDriverManager : NSObject

+ (instancetype)shared;

- (void)registerDriver:(Class<MixRouteModuleDriver>)driverClass forModule:(Protocol *)moduleProtocol;

- (Class<MixRouteModuleDriver>)getDriverWithModule:(Class<MixRouteModule>)moduleClass;

@end
