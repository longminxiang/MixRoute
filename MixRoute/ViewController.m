//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"

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
    self.label.text = self.mix_route.params;
    self.title = self.mix_route.params;
}

- (IBAction)buttonTouched:(id)sender {
    MixVCRoute *route = [[MixVCRoute alloc] initWithName:MixRouteNameVC1];
    route.params = [@(rand()) stringValue];
    route.style = rand() % 2 ? MixRouteStylePresent : MixRouteStylePush;
    [[MixRouteManager shared] route:route];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
