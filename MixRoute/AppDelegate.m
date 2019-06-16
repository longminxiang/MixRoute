//
//  AppDelegate.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarRoute.h"
#import "RouteManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [RouteManager to:MixRouteNameTab params:nil];
    return YES;
}

@end
