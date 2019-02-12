//
//  MixRouteManager.h
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MixRoute.h"

//@protocol MixRouteManagerModule <NSObject>
//
//+ (void)mixRouteManagerPrepareForRoute:(MixRoute *)route;
//
//@end

@interface MixRouteManager : NSObject

+ (void)lock;

+ (void)unlock;

+ (Class<MixRouteModule>)moduleClassWithName:(MixRouteName)name;

+ (void)route:(MixRoute *)route;

+ (void)to:(MixRouteName)name;

+ (void)to:(MixRouteName)name params:(id<MixRouteParams>)params;

@end
