//
//  Action.h
//  MixRoute
//
//  Created by Eric Lung on 2018/11/9.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MixRoute.h"

UIKIT_EXTERN MixRouteName const MixRouteNameActionShowHUD;

UIKIT_EXTERN MixRouteName const MixRouteNameActionLog;

NS_ASSUME_NONNULL_BEGIN

@interface Action : NSObject<MixRouteModule>

@end

NS_ASSUME_NONNULL_END
