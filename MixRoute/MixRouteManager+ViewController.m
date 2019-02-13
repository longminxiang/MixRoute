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
    UIColor* (^randColor)(void) = ^{
        return [UIColor colorWithRed:(float)(rand() % 10) / 10 green:(float)(rand() % 10) / 10 blue:(float)(rand() % 10) / 10 alpha:1];
    };

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    NSDictionary *atts = @{NSForegroundColorAttributeName: randColor(),
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           };
    item.mix.barTitleTextAttributes = atts;
    item.mix.barTintColor = randColor();
    item.mix.barHidden = rand() % 2;
    item.mix.statusBarHidden = rand() % 2;
    item.mix.statusBarStyle = rand() % 2;

    MixRouteViewControllerParams *params = [MixRouteViewControllerParams new];
    params.style = rand() % 2 ? MixViewControllerRouteStylePush : MixViewControllerRouteStylePresent;
    if (params.style == MixViewControllerRouteStylePresent && !item.mix.barHidden) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
       item.leftBarButtonItem = leftItem;
    }
    params.navigationItem = item;

    MixRoute *route = [[MixRoute alloc] initWithName:MixRouteNameVC1];
    route.params = params;
    [MixRouteManager route:route];
}

+ (void)dismiss
{
    [MixRouteManager toViewControllerBack:nil];
}

@end

@implementation MixRouteViewControllerModule

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModuleRegister *)reg
{
    [reg add:MixRouteNameVC1 block:^UIViewController<MixRouteViewControlelr> *(MixRoute * _Nonnull route) {
        return [ViewController new];
    }];
}

@end
