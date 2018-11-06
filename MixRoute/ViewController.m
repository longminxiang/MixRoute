//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationItem+Mix.h"

MixRouteName const MixRouteNameVC1 = @"MixRouteNameVC1";

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation ViewController

MixRegisterRouteModule(MixRouteNameVC1);

+ (UIViewController<MixRouteViewControlelr> *)vcWithRoute:(MixVCRoute *)route {
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
//    self.title = self.mix_route.params;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.navigationItem.mix.statusBarStyle = !self.navigationItem.mix.statusBarStyle;
//        self.navigationItem.mix.barHidden = NO;
//        self.navigationItem.mix.barBackgroundImage = [UIImage imageNamed:rand() % 2 ? @"nav1" : @"nav"];
//    });
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
//    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (IBAction)buttonTouched:(id)sender {
    MixVCRoute *route = [[MixVCRoute alloc] initWithName:MixRouteNameVC1];

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self randColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           };
    item.mix.barTitleTextAttributes = atts;
    item.mix.barTintColor = [self randColor];
//    item.mix.barTintColor = [UIColor whiteColor];
    item.mix.barHidden = NO;
    item.mix.statusBarStyle = rand() % 2;
    if (!item.mix.barHidden) {
//        item.mix.barBackgroundImage = [UIImage imageNamed:rand() % 2 ? @"nav1" : @"nav"];
    }
    route.navigationItem = item;

//    route.style = rand() % 2 ? MixRouteStylePresent : MixRouteStylePush;
    [[MixRouteManager shared] route:route];
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
