//
//  DrawRootViewController.m
//  LearnTest
//
//  Created by syq on 15/8/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "DrawRootViewController.h"
#import "DrawView.h"
#import "DrawCAShapeLayer.h"
#import "DrawTestView.h"

@interface DrawRootViewController ()

@end

@implementation DrawRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DrawView *view = [[DrawView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 64.0)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    DrawTestView *testView = [[DrawTestView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 200)];
    testView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:testView];
    
//    DrawCAShapeLayer *view = [[DrawCAShapeLayer alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:view];
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
