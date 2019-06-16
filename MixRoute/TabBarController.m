//
//  TabBarController.m
//  MixRoute
//
//  Created by Eric Long on 2019/6/16.
//  Copyright © 2019 YOOEE. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", [self class]);
}

@end
