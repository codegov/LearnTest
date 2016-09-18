//
//  TestThread3ViewController.m
//  LearnTest
//
//  Created by syq on 14/12/1.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestThread3ViewController.h"

@interface TestThread3ViewController ()
{
//    NSString *_string;
}

//NSString 线程安全指的是实例里面的方法和熟悉，不是指赋值操作
@property (nonatomic, strong) NSString *string;

@end

@implementation TestThread3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:8] forKey:@"TestThread3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSThread *thread_1 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread1) object:nil];
    thread_1.name = @"thread_1";
    [thread_1 start];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:9] forKey:@"TestThread3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSThread *thread_2 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread2) object:nil];
    thread_2.name = @"thread_2";
    [thread_2 start];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:10] forKey:@"TestThread3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSThread *thread_3 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread3) object:nil];
    thread_3.name = @"thread_3";
    [thread_3 start];
    
//    for (int i = 0; i < 100; i++) {
//        int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TestThread3"] intValue];
//        NSLog(@"valeu == %@ %d", [NSThread currentThread].name, value);
//    }
}

- (void)doThread1
{
    _string = @"------1";
    for (int i = 0; i < 100; i++) {
        int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TestThread3"] intValue];
        _string = @"======";//[NSString stringWithFormat:@"%@----%d--1", [NSThread currentThread].name, i];
        NSLog(@"%@ %d  %@", [NSThread currentThread].name, value, _string);
    }
    NSLog(@"%@", _string);
}

- (void)doThread2
{
    _string = @"------2";
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:11] forKey:@"TestThread3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)doThread3
{
    _string = @"------3";
    for (int i = 0; i < 100; i++) {
        int value = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TestThread3"] intValue];
        _string = @"-------";//[NSString stringWithFormat:@"%@----%d--1", [NSThread currentThread].name, i];
        NSLog(@"valeu ==%@ %d %@", [NSThread currentThread].name, value, _string);
    }
    NSLog(@"%@", _string);
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
