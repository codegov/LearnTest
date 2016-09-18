//
//  OtherRootViewController.m
//  LearnTest
//
//  Created by syq on 14/11/4.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "OtherRootViewController.h"

@interface OtherRootViewController ()

@end

@implementation OtherRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"系统菜单学习", @"class": @"MenuViewController"}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
