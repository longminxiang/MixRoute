//
//  ViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

MIX_VC_ROUTE_MAKE(VC1)

@interface ViewController : BaseVC<MixViewControllerRouteModule>

@end
