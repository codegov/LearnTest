//
//  GcdRootViewController.m
//  LearnTest
//
//  Created by syq on 14/11/14.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "GcdRootViewController.h"

@interface GcdRootViewController ()
{
    UILabel *label;
}
@end

@implementation GcdRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试GCD1",  @"class": @"TestGcd1ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试GCD2",  @"class": @"TestGcd2ViewController"}];
        [self.dataArray addObject:@{@"title": @"测试GCD3",  @"class": @"TestGcd3ViewController"}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    label.backgroundColor = [UIColor brownColor];
//    self.tableView.tableHeaderView = label;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:[self testGcdNotificationName] object:nil];
}

- (NSString *)testGcdNotificationName
{
    return @"testGcdNotificationName";
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
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    });
    
//    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView endUpdates];
    
//    [self.tableView reloadData];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        label.text = name;
//    });

//    label.text = name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
