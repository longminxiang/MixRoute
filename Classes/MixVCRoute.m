//
//  MixVCRoute.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "MixVCRoute.h"
#import "MixRouteManager.h"

MixRouteName const MixRouteNameBack = @"MixRouteNameBack";
MixRouteName const MixRouteNameBackToRoot = @"MixRouteNameBackToRoot";

@implementation UIViewController (MixRoute)

- (UIViewController<MixRouteViewControlelr> *)mixRoute_vc
{
    return [self conformsToProtocol:@protocol(MixRouteViewControlelr)] ? (UIViewController<MixRouteViewControlelr> *)self : nil;
}

@end

@implementation MixVCRouteDriver
@synthesize route = _route;
@synthesize moduleClass = _moduleClass;

+ (void)load
{
    [[MixRouteManager shared] registerDriver:self forModule:@protocol(MixVCRouteModule)];
}

- (UIViewController<MixRouteViewControlelr> *)topVC
{
    UIViewController *avc = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self findTopVC:avc];
}

- (UIViewController<MixRouteViewControlelr> *)findTopVC:(UIViewController *)vc
{
    UIViewController *avc;
    if (vc.presentedViewController) {
        avc = [self findTopVC:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        avc = [self findTopVC:nav.topViewController];
    }
    else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tvc = (UITabBarController *)vc;
        avc = [self findTopVC:tvc.viewControllers[tvc.selectedIndex]];
    }
    else if ([vc isKindOfClass:[UIViewController class]] && ![vc isKindOfClass:[UIAlertController class]]) {
        avc = vc;
    }
    return avc.mixRoute_vc;
}

- (void)drive:(void (^)(void))completion
{
    id<MixVCRoute> route = self.route;
    UIViewController<MixRouteViewControlelr> *vc = [self.moduleClass initWithRoute:route];
    if (!vc) {
        if (completion) completion();
    }

    UIViewController<MixRouteViewControlelr> *topVC = [self topVC];
    if (MixRouteNameEqual(route.name, MixRouteNameBack)) {
        if (topVC.router.style == MixRouteStylePresent) {
            [topVC dismissViewControllerAnimated:YES completion:^{
                if (completion) completion();
            }];
        }
        else {
            int delta = 1;
            if ([route.params isKindOfClass:[NSNumber class]] || [route.params isKindOfClass:[NSString class]]) {
                delta = MAX([route.params intValue], 1);
            }
            int count = (int)topVC.navigationController.viewControllers.count;
            if (delta >= count) {
                [topVC.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                UIViewController *xvc = topVC.navigationController.viewControllers[count - delta - 1];
                [topVC.navigationController popToViewController:xvc animated:YES];
            }
            if (completion) completion();
        }
    }
    else if (MixRouteNameEqual(route.name, MixRouteNameBackToRoot)) {
        [topVC.navigationController popToRootViewControllerAnimated:YES];
        if (completion) completion();
    }
    else if (route.style == MixRouteStylePresent) {
        [topVC presentViewController:vc animated:YES completion:^{
            if (completion) completion();
        }];
    }
    else {
        [topVC.navigationController pushViewController:vc animated:YES];
        if (completion) completion();
    }
}

@end
