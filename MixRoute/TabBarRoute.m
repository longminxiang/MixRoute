//
//  TabBarRoute.m
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 Eric Long. All rights reserved.
//

#import "TabBarRoute.h"
#import "TabBarController.h"
#import "ViewController.h"

@implementation TabBarControllerParams
@synthesize style = _style;
@synthesize tabRoutes = _tabRoutes;

@end

@implementation TabParams

@end

@implementation TabBarRoute

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameTab vcBlock:^UIViewController<MixRouteViewController> *(id<MixRoute> route) {
        return [TabBarController new];
    }];
    [reg add:MixRouteNameTabIndex block:^(id<MixRoute> route) {
        TabParams *params = (TabParams *)route.routeParams;
        UINavigationController *vc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        TabBarController *tvc = (TabBarController *)[vc.viewControllers firstObject];
        [((UINavigationController *)tvc.viewControllers[tvc.selectedIndex]).mixE popToRootViewControllerAnimated:YES completion:^{
            tvc.selectedIndex = params.index;
        }];
    }];
}

+ (void)mixRoutePrestart:(id<MixRoute>)route
{
    if (![route.routeName isEqualToString:MixRouteNameTab]) return;
    
    Route *aroute = (Route *)route;
    
    NSMutableArray *routes = [NSMutableArray new];
    NSArray *imageNames = @[@"tab_home", @"tab_video", @"tab_live", @"tab_circle"];
    for (int i = 0; i < imageNames.count; i++) {
        Route *route = [Route new];
        route.routeName = MixRouteNameVC1;
        
        ViewControllerParams *params = [ViewControllerParams new];
        
        MixViewControllerItem *item = [MixViewControllerItem new];
        item.navigationBarBarTintColor = [UIColor orangeColor];
        item.navigationBarTintColor = [UIColor whiteColor];
        item.navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        item.tabBarBarTintColor = [UIColor redColor];
        params.item = item;
        
        NSString *name = imageNames[i];
        UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *selImage = [[UIImage imageNamed:[name stringByAppendingString:@"_cur"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (!selImage) selImage = [[UIImage imageNamed:@"tab_reflash"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        params.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@(rand()) stringValue] image:image selectedImage:selImage];
        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
        [params.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor orangeColor]} forState:UIControlStateSelected];
        route.routeParams = params;
        [routes addObject:route];
    }
    TabBarControllerParams *params = [TabBarControllerParams new];
    params.style = MixViewControllerRouteStyleRoot;
    params.tabRoutes = routes;
    aroute.routeParams = params;
}

@end
