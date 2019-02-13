//
//  AppDelegate.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MixViewControllerRouteBase.h"
#import "MixRoute-Swift.h"
#import <objc/runtime.h>

MixRouteName const MixRouteNameTab = @"MixRouteNameTab";

@interface TabBarController : UITabBarController<MixRouteViewControlelr, MixViewControllerRouteModule>

@end

@implementation TabBarController

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModule *)module
{
    module.name = MixRouteNameTab;
    module.navigationControllerClass = [BaseNavigationController class];
    module.block = ^UIViewController<MixRouteViewControlelr> *(MixRoute * _Nonnull route) {
        return [TabBarController new];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

//    NSMutableArray *routes = [NSMutableArray new];
//    NSArray *imageNames = @[@"tab_home", @"tab_video", @"tab_live", @"tab_circle"];
//    for (int i = 0; i < imageNames.count; i++) {
//        MixRoute *route = [[MixRoute alloc] initWithName:MixRouteNameVC1];
//        MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
//        params.navigationItem = [[UINavigationItem alloc] initWithTitle:[@(rand()) stringValue]];
//        NSString *name = imageNames[i];
//        UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIImage *selImage = [[UIImage imageNamed:[name stringByAppendingString:@"_cur"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        if (!selImage) selImage = [[UIImage imageNamed:@"tab_reflash"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        params.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@(rand()) stringValue] image:image selectedImage:selImage];
//        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
//        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
//        route.params = params;
//        [routes addObject:route];
//    }
//    MixRouteTabBarControllerBaseParams *params = [MixRouteTabBarControllerBaseParams new];
//    params.style = MixRouteStyleRoot;
//    params.tabRoutes = routes;
//    params.tabBarItem = [UITabBarItem new];
//    params.tabBarItem.mix.barTintColor = [UIColor redColor];
//
//    [MixRouteManager to:MixRouteNameTab params:params];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
//        params.navigationItem = [[UINavigationItem alloc] initWithTitle:[@(rand()) stringValue]];
//        params.style = MixRouteStyleRoot;
//        [MixRouteManager to:MixRouteNameVC1 params:params];
//    });

    NSDictionary *rootDict = @{
                                @"name": @"Tab",
//                                @"style": @(MixRouteStyleRoot),
                                @"tabRoutes": @[
                                        @{@"name": @"VC1", @"nav": @{@"title": @"xx"}, @"tab": @{@"image": @"tab_home", @"selImage": @"tab_reflash", @"title": @"ss"}},
                                        @{@"name": @"VC1", @"nav": @{@"title": @"xx"}, @"tab": @{@"image": @"tab_video", @"selImage": @"tab_reflash", @"title": @"ss"}},
                                        @{@"name": @"VC1", @"nav": @{@"title": @"xx"}, @"tab": @{@"image": @"tab_live", @"selImage": @"tab_live_cur", @"title": @"ss"}},
                                        @{@"name": @"VC1", @"nav": @{@"title": @"xx"}, @"tab": @{@"image": @"tab_circle", @"selImage": @"tab_circle_cur", @"title": @"ss"}},
                                        ],
                                };
    Route *route = [Route routeWithDictionary:rootDict];
    MixRoute *aroute = route.vcRoute;
    [MixRouteManager route:aroute];
    NSLog(@"%@", route);
    return YES;
}

- (UIColor *)randColor
{
    return [UIColor colorWithRed:(float)(rand() % 10) / 10 green:(float)(rand() % 10) / 10 blue:(float)(rand() % 10) / 10 alpha:1];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
