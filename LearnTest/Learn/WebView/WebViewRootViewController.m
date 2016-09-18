//
//  WebViewRootViewController.m
//  LearnTest
//
//  Created by syq on 14/11/7.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "WebViewRootViewController.h"

@interface WebViewRootViewController ()

@end

@implementation WebViewRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"Js执行Oc学习", @"class": @"MenuViewController"}];
        [self.dataArray addObject:@{@"title": @"web本地缓存", @"class": @"WebViewCacheViewController"}];
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
