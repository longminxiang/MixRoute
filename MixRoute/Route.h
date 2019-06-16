//
//  Route.h
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixViewControllerRoute.h"

@interface Route : NSObject<MixRoute>

@property (nonatomic, strong) MixRouteName routeName;
@property (nonatomic, strong) id<MixRouteParams> routeParams;
@property (nonatomic, strong) MixRouteQueue routeQueue;

@end
