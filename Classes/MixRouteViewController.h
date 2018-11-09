//
//  MixRouteViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/24.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+Mix.h"

@class MixRoute;

@protocol MixRouteViewControlelr

@end

@interface MixViewController : NSObject

@property (nonatomic, weak, readonly) UIViewController<MixRouteViewControlelr> *vc;

@property (nonatomic, strong) MixRoute *route;

@property (nonatomic, readonly, class) UIViewController<MixRouteViewControlelr> *topVC;

@end

@interface UIViewController (MixRouteViewControlelr)

@property (nonatomic, readonly) MixViewController *mix;

@end
