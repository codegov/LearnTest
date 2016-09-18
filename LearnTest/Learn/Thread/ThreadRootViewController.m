//
//  MultiThreadViewController.m
//  LearnTest
//
//  Created by syq on 14/10/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "ThreadRootViewController.h"

@interface ThreadRootViewController ()

@end

@implementation ThreadRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"经典的卖票",    @"class": @"BuyTicketViewController"}];
        [self.dataArray addObject:@{@"title": @"测试Thread1",  @"class": @"TestThread1ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试Thread2",  @"class": @"TestThread2ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试Thread3",  @"class": @"TestThread3ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试RunLoop1", @"class": @"TestRunLoop1ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试RunLoop2", @"class": @"TestRunLoop2ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试RunLoop3", @"class": @"TestRunLoop3ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试NSLock",   @"class": @"TestLockViewController"}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:[self testGcdNotificationName] object:nil];
}

- (NSString *)testGcdNotificationName
{
    return @"TestThread2Notification";
}

- (void)receiveNotification
{
    NSString * name = [NSString stringWithFormat:@"监听通知 当前线程名称：%@", [[NSThread currentThread] name]];
    [self updateUI:name];
}


#pragma mark - 更新UI

- (void)updateUI:(NSString *)name
{
    NSLog(@"%@\n", name);
    [self.dataArray addObject:@{@"title": name,  @"class": @"TestGcd1ViewController"}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    });
    
//    [self.tableView beginUpdates];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView endUpdates];
    
    //    [self.tableView reloadData];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        label.text = name;
//    });
    
    
    //    label.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
