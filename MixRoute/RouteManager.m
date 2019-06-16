//
//  RouteManager.m
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "RouteManager.h"
#import "MixRouteManager.h"

@implementation RouteManager

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params
{
    [self to:name params:params queue:nil];
}

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params queue:(MixRouteQueue)queue
{
    Route *route = [Route new];
    route.routeName = name;
    route.routeParams = params;
    route.routeQueue = queue;
    [MixRouteManager route:route];
}

@end
