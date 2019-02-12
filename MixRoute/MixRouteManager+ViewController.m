//
//  MixRouteManager+ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2019/2/12.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "MixRouteManager+ViewController.h"
#import "ViewController.h"

MixRouteName const MixRouteNameVC1 = @"MixRouteNameVC1";

@implementation MixRouteManager (ViewController)

+ (void)toViewController
{
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    NSDictionary *atts = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           };
    item.mix.barTitleTextAttributes = atts;
    item.mix.barTintColor = [UIColor whiteColor];
    //    item.mix.barTintColor = [UIColor whiteColor];
    item.mix.barHidden = rand() % 2;
    //    item.mix.barHidden = NO;
    item.mix.statusBarHidden = rand() % 2;
    item.mix.statusBarStyle = rand() % 2;

    MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
    params.navigationItem = item;

    [MixRouteManager to:MixRouteNameVC1 params:params];
}

@end

@implementation MixRouteViewControllerModule

+ (NSArray<MixRouteName> *)mixRouteRegisterModules
{
    return @[MixRouteNameVC1];
}

//+ (void)mixRouteFire:(MixRoute *)route
//{
//
//}

+ (UIViewController<MixRouteViewControlelr> *)viewControllerWithRoute:(MixRoute *)route
{
    ViewController *vc = [ViewController new];
    return vc;
}

@end
