//
//  BlockRootViewController.m
//  LearnTest
//
//  Created by syq on 14/10/24.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "BlockRootViewController.h"

@interface BlockRootViewController ()

@end

@implementation BlockRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试Block1",  @"class": @"TestBlock1ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试Block2",  @"class": @"TestBlock2ViewController"}];
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
