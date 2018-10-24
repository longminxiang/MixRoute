//
//  ViewController.m
//  MixRoute
//
//  Created by Eric Lung on 2018/10/15.
//  Copyright © 2018年 YOOEE. All rights reserved.
//

#import "ViewController.h"
#import "Route.h"

MixRouteName const MixRouteNameVC1 = @"MixRouteNameVC1";

@interface ViewController ()<MixRouteViewControlelr>

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation ViewController
@synthesize route = _route;

+ (void)load {
    [[MixRouteManager shared] registerModule:self forName:MixRouteNameVC1];
}

+ (void)prepareRoute:(id<MixRoute>)aroute {
    
}

+ (UIViewController<MixRouteViewControlelr> *)initWithRoute:(id<MixVCRoute>)route {
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
    self.label.text = self.route.params;
    self.title = self.route.params;
}

- (IBAction)buttonTouched:(id)sender {
    Route *route = [[Route alloc] initWithName:MixRouteNameVC1];    
    route.params = [@(rand()) stringValue];
    [[MixRouteManager shared] route:route];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
