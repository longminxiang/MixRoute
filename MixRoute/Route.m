//
//  Route.m
//  MixRoute
//
//  Created by Eric on 2018/10/17.
//  Copyright © 2018 YOOEE. All rights reserved.
//

#import "Route.h"

@implementation Route
@synthesize name = _name;
@synthesize params = _params;
@synthesize style = _style;
@synthesize tabRoutes = _tabRoutes;

- (instancetype)initWithName:(MixRouteName)name {
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

@end

@implementation MixRouteManager (App)

- (void)routeTo:(MixRouteName)name {
    Route *route = [[Route alloc] initWithName:name];
    [self route:route];
}

@end
