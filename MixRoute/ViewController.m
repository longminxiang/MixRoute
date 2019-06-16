//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 Eric Lung. All rights reserved.
//

#import "ViewController.h"
#import "Action.h"
#import "TabBarRoute.h"
#import "RouteManager.h"

@implementation ViewControllerParams
@synthesize style = _style;
@synthesize item = _item;
@synthesize navigationItem = _navigationItem;
@synthesize tabBarItem = _tabBarItem;
@synthesize navigationControllerClass = _navigationControllerClass;

@end

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation ViewController

+ (void)mixRouteRegisterModule:(MixRouteModuleRegister *)reg
{
    [reg add:MixRouteNameVC1 vcBlock:^UIViewController<MixRouteViewController> *(id<MixRoute> route) {
        return [ViewController new];
    }];
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
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mixE.item.tabBarTintColor = [self randColor];
    });
}

- (IBAction)buttonTouched:(id)sender {
    [self push];

}

- (IBAction)tabButtonTouched:(id)sender {
    TabParams *params = [TabParams new];
    params.index = rand() % 4;
    [RouteManager to:MixRouteNameTabIndex params:params];
}

- (void)push
{
    ViewControllerParams *params = [ViewControllerParams new];
    params.style = MixViewControllerRouteStylePush;
    
    MixViewControllerItem *item = [MixViewControllerItem new];
    item.navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: [self randColor],
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20]};
    item.navigationBarTintColor = [self randColor];
    item.navigationBarBarTintColor = [self randColor];
    item.navigationBarHidden = rand() % 2;
    item.statusBarHidden = rand() % 2;
    item.statusBarStyle = rand() % 2;
    params.item = item;
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    if (params.style == MixViewControllerRouteStylePresent && !item.navigationBarHidden) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss1)];
        navItem.leftBarButtonItem = leftItem;
    }
    params.navigationItem = navItem;
    
    [RouteManager to:MixRouteNameVC1 params:params];
}

- (void)dismiss1
{
    [RouteManager to:MixRouteNameBack params:nil];
}

- (IBAction)action
{
    [RouteManager to:MixRouteNameActionShowHUD params:nil queue:MixRouteActionQueue];
}

- (IBAction)dismiss
{
    MixRouteBackParams *params = [MixRouteBackParams new];
    params.delta = 10;
    [RouteManager to:MixRouteNameBack params:params];
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
