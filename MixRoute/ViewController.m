//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"
#import "Action.h"
#import "MixRouteManager+ViewController.h"
#import "MixRoute.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation ViewController

- (BOOL)hidesBottomBarWhenPushed
{
    return self.navigationController.viewControllers.count > 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.label.text = self.navigationItem.title;
//    MixNavigationItem *item = self.navigationItem.mix;
//    self.title = self.mix_route.params;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationItem.mix.statusBarStyle = !self.navigationItem.mix.statusBarStyle;
//        self.navigationItem.mix.barHidden = NO;
//        self.navigationItem.mix.barBackgroundImage = [UIImage imageNamed:rand() % 2 ? @"nav1" : @"nav"];
//    });
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
//    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    if (!item.barTintColor) item.barTintColor = [self randColor];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        item.statusBarStyle = !item.statusBarStyle;
//    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mix_extention.attributes.tabBarTintColor = [self randColor];
    });
}

- (IBAction)buttonTouched:(id)sender {
    [self push];
    MixRouteActionDelayParams *params = [MixRouteActionDelayParams new];
    params.delay = 3000;
    [MixRouteManager toActionDelay:params queue:MixRouteGlobalQueue];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];
    [self push];

}

- (void)push
{
    [MixRouteManager toViewController];
}

- (IBAction)action
{
    [MixRouteManager toActionShowHUD];
}

- (IBAction)dismiss
{
    MixRouteBackParams *params = [MixRouteBackParams new];
    params.delta = 10;
    [MixRouteManager toViewControllerBack:params];
}

- (UIColor *)randColor
{
    return [UIColor colorWithRed:(float)(rand() % 10) / 10 green:(float)(rand() % 10) / 10 blue:(float)(rand() % 10) / 10 alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
