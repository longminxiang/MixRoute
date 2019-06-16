//
//  MixRouteManager.h
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 Eric Lung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixRoute.h"

@interface MixRouteManager : NSObject

+ (void)lock:(MixRouteQueue)queue;

+ (void)unlock:(MixRouteQueue)queue;

+ (void)route:(id<MixRoute>)route;

@end
