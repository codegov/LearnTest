//
//  BlueYaRootViewController.m
//  LearnTest
//
//  Created by syq on 15/5/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "BlueYaRootViewController.h"

@interface BlueYaRootViewController ()

@end

@implementation BlueYaRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试蓝牙1",  @"class": @"BlueYaTest1ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试蓝牙2", @"class": @"GKBlueViewController"}];
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

@end
