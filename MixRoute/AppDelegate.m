//
//  AppDelegate.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "AppDelegate.h"
#import "MixRoute.h"
#import "MixRoute-Swift.h"

MIX_ROUTE_NAME(Tab)

@interface TabBarController : UITabBarController<MixRouteViewController, MixViewControllerRouteModule>

@end

@implementation TabBarController

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModuleRegister *)reg
{
    [reg add:MixRouteNameTab block:^UIViewController<MixRouteViewController> *(MixRoute * _Nonnull route) {
        return [TabBarController new];
    }];
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
                                @"navigationClass": @"BaseNavigationController",
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

@end
