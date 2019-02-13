//
//  MixRouteManager.h
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixRoute.h"

@interface MixRouteManager : NSObject

+ (void)lock;

+ (void)unlock;

+ (void)route:(MixRoute *)route;

+ (void)to:(MixRouteName)name;

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params;

@end
