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

MixRouteName const MixRouteNameTab = @"MixRouteNameTab";

@interface TabBarController : UITabBarController<MixRouteViewControlelr, MixViewControllerRouteModule>

@end

@implementation TabBarController

MixRegisterRouteModule(MixRouteNameTab);

+ (UIViewController<MixRouteViewControlelr> *)viewControllerWithRoute:(MixRoute *)route
{
    TabBarController *tab = [TabBarController new];
    return tab;
}

//+ (Class)routeNavigationControllerClass
//{
//    return [BaseNavigationController class];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

    NSMutableArray *routes = [NSMutableArray new];
    NSArray *imageNames = @[@"tab_home", @"tab_video", @"tab_live", @"tab_circle"];
    for (int i = 0; i < imageNames.count; i++) {
        MixRoute *route = [[MixRoute alloc] initWithName:MixRouteNameVC1];
        MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
        params.navigationItem = [[UINavigationItem alloc] initWithTitle:[@(rand()) stringValue]];
        NSString *name = imageNames[i];
        UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImage = [[UIImage imageNamed:[name stringByAppendingString:@"_cur"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (!selImage) selImage = [[UIImage imageNamed:@"tab_reflash"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        params.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@(rand()) stringValue] image:image selectedImage:selImage];
        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
        route.params = params;
        [routes addObject:route];
    }
    MixRouteTabBarControllerBaseParams *params = [MixRouteTabBarControllerBaseParams new];
    params.style = MixRouteStyleRoot;
    params.tabRoutes = routes;
    params.tabBarItem = [UITabBarItem new];
    params.tabBarItem.mix.barTintColor = [UIColor redColor];

    [[MixRouteManager shared] routeTo:MixRouteNameTab params:params];
    
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
