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
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self randColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           };
    item.mix.barTitleTextAttributes = atts;
    item.mix.barTintColor = [self randColor];
    //    item.mix.barTintColor = [UIColor whiteColor];
    item.mix.barHidden = rand() % 2;
    //    item.mix.barHidden = NO;
    item.mix.statusBarHidden = rand() % 2;
    item.mix.statusBarStyle = rand() % 2;

    MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
    params.navigationItem = item;

    [MixRouteManager to:MixRouteNameVC1 params:params];
}

+ (UIColor *)randColor
{
    return [UIColor colorWithRed:(float)(rand() % 10) / 10 green:(float)(rand() % 10) / 10 blue:(float)(rand() % 10) / 10 alpha:1];
}

@end

@implementation MixRouteViewControllerModule

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModule *)module
{
    [module setName:MixRouteNameVC1 block:^UIViewController<MixRouteViewControlelr> *(MixRoute * _Nonnull route) {
        return [ViewController new];
    }];
}

@end
