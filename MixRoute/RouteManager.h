//
//  RouteManager.h
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Route.h"

@interface RouteManager : NSObject

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params;

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params queue:(MixRouteQueue)queue;

@end
