//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"
#import "Action.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@end

@implementation ViewController

+ (void)mixViewControllerRouteRegisterModule:(MixViewControllerRouteModuleRegister *)reg
{
    [reg add:MixRouteNameVC1 block:^UIViewController<MixRouteViewController> *(MixRoute * _Nonnull route) {
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
        self.mix_extention.attributes.tabBarTintColor = [self randColor];
    });
}

- (IBAction)buttonTouched:(id)sender {
    [self push];

    MixRouteActionDelay(^(MixRouteActionDelayParams * _Nonnull params) {
        params.delay = 3000;
    });

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
    MixRouteVC1(^(MixRouteViewControllerParams *params) {
        params.style = rand() % 2 ? MixViewControllerRouteStylePush : MixViewControllerRouteStylePresent;

        UIViewControllerMixExtentionAttributes *attributes = [UIViewControllerMixExtentionAttributes new];
        attributes.navigationBarTitleTextAttributes = @{NSForegroundColorAttributeName: [self randColor],
                                                        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                        };
        attributes.navigationBarTintColor = [self randColor];
        attributes.navigationBarHidden = rand() % 2;
        attributes.statusBarHidden = rand() % 2;
        attributes.statusBarStyle = rand() % 2;
        params.attributes = attributes;

        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
        if (params.style == MixViewControllerRouteStylePresent && !attributes.navigationBarHidden) {
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss1)];
            item.leftBarButtonItem = leftItem;
        }
        params.navigationItem = item;
    });
}

- (void)dismiss1
{
    MixRouteBack(nil);
}

- (IBAction)action
{
    MixRouteActionShowHUD1(MixRouteActionQueue);
}

- (IBAction)dismiss
{
    MixRouteBack(^(MixRouteBackParams * _Nonnull params) {
        params.delta = 10;
    });
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
