//
//  MixRouteViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/24.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MixVCRoute;

@protocol MixRouteViewControlelr

@property (nonatomic, strong) MixVCRoute *mix_route;

@end

@interface UIViewController (MixVCRoute)

@property (nonatomic, readonly) UIViewController<MixRouteViewControlelr> *mixRoute_vc;

@end
