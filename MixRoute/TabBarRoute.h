//
//  TabBarRoute.h
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 Eric Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

MIX_ROUTE_NAME(Tab)
MIX_ROUTE_NAME(TabIndex)

@interface TabBarControllerParams : NSObject<MixRouteViewControllerParams>

@end

@interface TabParams : NSObject<MixRouteParams>

@property (nonatomic, assign) int index;

@end

@interface TabBarRoute : NSObject<MixRouteModule, MixRouteMiddleware>

@end
