//
//  MixRouteManager+ViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "MixRoute.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN MixRouteName const MixRouteNameVC1;

@interface MixRouteManager (ViewController)

+ (void)toViewController;

@end

@interface MixRouteViewControllerModule : NSObject<MixViewControllerRouteModule>

@end

NS_ASSUME_NONNULL_END
