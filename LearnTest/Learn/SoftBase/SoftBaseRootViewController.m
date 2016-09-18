//
//  SoftBaseRootViewController.m
//  LearnTest
//
//  Created by syq on 14/11/4.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "SoftBaseRootViewController.h"

@interface SoftBaseRootViewController ()

@end

@implementation SoftBaseRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataArray addObject:@{@"title": @"线性表", @"class": @"LinearlistViewController"}];
    [self.dataArray addObject:@{@"title": @"树",    @"class": @"TreeViewController"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
