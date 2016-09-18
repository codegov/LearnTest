//
//  TestThread2ViewController.m
//  LearnTest
//
//  Created by syq on 14/11/14.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestThread2ViewController.h"

@interface TestThread2ViewController ()


@end

@implementation TestThread2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:[self testThread2NotificationName] object:nil];
    
    NSThread *thread_1 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread) object:nil];
    thread_1.name = @"thread_1";
    [thread_1 start];
}


- (NSString *)testThread2NotificationName
{
    return @"TestThread2Notification";
}

- (void)doThread
{
    @synchronized(self)
    {
        NSString * name = [NSString stringWithFormat:@"当前线程名称：%@", [[NSThread currentThread] name]];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:YES];
        [NSThread sleepForTimeInterval:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:[self testThread2NotificationName] object:nil];
    }
}

/**
 重要结论
 */

- (void)receiveNotification // 此方法属于线程
{
    NSString * name = [NSString stringWithFormat:@"监听通知 当前线程名称：%@", [[NSThread currentThread] name]];
    [self updateUI:name];
//    [self performSelector:@selector(updateUI:) withObject:name];              // 在当前线程当前运行循环周期执行
//    [self performSelector:@selector(updateUI:) withObject:name afterDelay:0]; // 在当前线程下一个运行循环周期执行，这里updateUI方法不会执行，因为此时的线程生命周期就一次循环。
}


#pragma mark - 更新UI

- (void)updateUI:(NSString *)name
{
    NSLog(@"%@\n", name);
    [self.dataArray addObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
