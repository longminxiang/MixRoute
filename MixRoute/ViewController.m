//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationItem+Mix.h"
#import "Action.h"

MixRouteName const MixRouteNameVC1 = @"MixRouteNameVC1";
MixRouteName const MixRouteNameVC2 = @"MixRouteNameVC2";

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation ViewController

+ (void)mixRouteRegisterDriver:(MixRouteDriver *)driver
{
    driver.regvc(MixRouteNameVC1);
    driver.reg(MixRouteNameVC2, ^(MixRoute *route, void (^completion)(void)) {
        NSLog(@"xxxxx");
        completion();
    });
}

+ (UIViewController<MixRouteViewControlelr> *)viewControllerWithRoute:(MixRoute *)route
{
    ViewController *vc = [self new];
    return vc;
}

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
        self.tabBarItem.mix.barTintColor = [self randColor];
    });
}

- (IBAction)buttonTouched:(id)sender {

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
//    item.mix.barBackgroundImage = [UIImage imageNamed:rand() % 2 ? @"nav1" : @"nav"];

    MixRouteViewControllerBaseParams *params = [MixRouteViewControllerBaseParams new];
//    params.style = rand() % 2 ? MixRouteStylePresent : MixRouteStylePush;
    params.navigationItem = item;

    [[MixRouteManager shared] routeTo:MixRouteNameVC1 params:params];
}

- (IBAction)action
{
    [[MixRouteManager shared] routeTo:MixRouteNameActionShowHUD];
}

- (IBAction)dismiss
{
    [[MixRouteManager shared] routeTo:MixRouteNameBack];
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
