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

@interface ViewControllerRouteParams : MixRouteViewControllerParams

@end

@implementation ViewControllerRouteParams

@end

@implementation MixRouteManager (ViewController)

+ (void)toViewController
{
    UIColor* (^randColor)(void) = ^{
        return [UIColor colorWithRed:(float)(rand() % 10) / 10 green:(float)(rand() % 10) / 10 blue:(float)(rand() % 10) / 10 alpha:1];
    };

    UIViewControllerMixExtentionAttributes *attributes = [UIViewControllerMixExtentionAttributes new];
    attributes.navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: randColor(),
                                                    NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                    };
    attributes.navigationBarTintColor = randColor();
    attributes.navigationBarHidden = rand() % 2;
    attributes.statusBarHidden = rand() % 2;
    attributes.statusBarStyle = rand() % 2;

    MixRouteViewControllerParams *params = [MixRouteViewControllerParams new];
    params.style = rand() % 2 ? MixViewControllerRouteStylePush : MixViewControllerRouteStylePresent;
    params.attributes = attributes;
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    if (params.style == MixViewControllerRouteStylePresent && !attributes.navigationBarHidden) {
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
    [reg add:MixRouteNameVC1 block:^UIViewController<MixRouteViewController> *(MixRoute * _Nonnull route) {
        return [ViewController new];
    }];
}

@end
