//
//  SocketRootViewController.m
//  LearnTest
//
//  Created by syq on 15/5/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "SocketRootViewController.h"
#import "PingImp.h"

@interface SocketRootViewController ()

@end

@implementation SocketRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试套接字1",  @"class": @"SocketTest1ViewController"}];
//        [self.dataArray addObject:@{@"title": @"测试套接字2",  @"class": @"SocketTest1ViewController"}];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PingImp ping];
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
