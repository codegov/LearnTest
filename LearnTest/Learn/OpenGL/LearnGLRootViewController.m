//
//  LearnGLRootViewController.m
//  LearnTest
//
//  Created by javalong on 2016/12/6.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "LearnGLRootViewController.h"

@interface LearnGLRootViewController ()

@end

@implementation LearnGLRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataArray addObject:@{@"title": @"测试1",        @"class": @"LearnGLTest1ViewController"}];
    [self.dataArray addObject:@{@"title": @"测试2",        @"class": @"LearnGLTest2ViewController"}];
    [self.dataArray addObject:@{@"title": @"测试3:画板",    @"class": @"LearnGLTest3ViewController"}];
    [self.dataArray addObject:@{@"title": @"测试3_1:画板",  @"class": @"LearnGLTest31ViewController"}];
    
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
