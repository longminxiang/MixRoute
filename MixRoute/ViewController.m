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
}

- (IBAction)buttonTouched:(id)sender {
    MixVCRoute *route = [[MixVCRoute alloc] initWithName:MixRouteNameVC1];

    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:[@(rand() / 100) stringValue]];
    NSDictionary *atts = @{NSForegroundColorAttributeName: [self randColor],
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           };
    item.mix_titleTextAttributes = atts;
    item.mix_barTintColor = [self randColor];
//    item.mix_barHidden = @(rand() % 2);
    item.mix_statusBarStyle = @(rand() % 2);
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
