//
//  AppDelegate.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"

@interface TabParams : MixRouteParams

@property (nonatomic, assign) int index;

@end

MIX_ROUTE_NAME(TabIndex)

FOUNDATION_STATIC_INLINE void MixRouteTabIndexWithQueue(TabParams * _Nullable params, MixRouteQueue _Nullable queue) {
    MixRoute *route = [[MixRoute alloc] initWithName:MixRouteNameTabIndex];
    route.params = params;
    route.queue = queue;
    [MixRouteManager route:route];
}
FOUNDATION_STATIC_INLINE void MixRouteTabIndex(TabParams * _Nullable params) {
    MixRouteTabIndexWithQueue(params, nil);
}

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, nullable) UIWindow *window;

@end

