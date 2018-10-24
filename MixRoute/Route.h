//
//  Route.h
//  MixRoute
//
//  Created by Eric on 2018/10/17.
//  Copyright © 2018 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixVCRoute.h"
#import "MixRouteManager.h"

@interface Route : NSObject<MixVCRoute>

@end

@interface MixRouteManager (App)

- (void)routeTo:(MixRouteName)name;

@end

@protocol MixTabRouteModule<MixRouteModule>

+ (UITabBarController *)initWithRoute:(id<MixVCRoute>)route;

@end
