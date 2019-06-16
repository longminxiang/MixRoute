//
//  ViewController.h
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

MIX_ROUTE_NAME(VC1)

@interface ViewControllerParams : NSObject<MixRouteViewControllerParams>

@end

@interface ViewController : BaseVC<MixRouteModule>

@end
