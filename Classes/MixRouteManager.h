//
//  MixRouteManager.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixRoute.h"

@interface MixRouteManager : NSObject

+ (instancetype)shared;

- (void)registerDriver:(Class<MixRouteModuleDriver>)driverClass forModule:(Protocol *)moduleProtocol;

- (void)registerModule:(Class<MixRouteModule>)moduleClass forName:(MixRouteName)name;

- (void)route:(id<MixRoute>)route;

- (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name;

@end
