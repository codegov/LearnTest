//
//  TestGcd1ViewController.m
//  LearnTest
//
//  Created by syq on 14/11/14.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestGcd1ViewController.h"

@interface TestGcd1ViewController ()

@end

@implementation TestGcd1ViewController

static dispatch_queue_t _addressBookQueue;

- (id)init
{
    self = [super init];
    if (self) {
        _addressBookQueue = dispatch_queue_create("addressBook", NULL);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test2];
}

- (void)test2
{
    [self performSelector:@selector(doTest2) withObject:nil afterDelay:3];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
       [self performSelector:@selector(cancelTest2) withObject:nil afterDelay:2];
       [[NSRunLoop currentRunLoop] run];
    });
}

- (void)doTest2
{
    NSLog(@"======doTest2======");
}

- (void)cancelTest2
{
    NSLog(@"======cancelTest2======");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doTest2) object:nil];
    });
}


- (void)test1
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification) name:[self testGcdNotificationName] object:nil];
    
    [self setupContactsData];
}

- (NSString *)testGcdNotificationName
{
    return @"testGcdNotificationName";
}

- (void)setupContactsData
{
    dispatch_block_t block = ^{
        NSString * name = [NSString stringWithFormat:@"当前线程名称：%@", [[NSThread currentThread] name]];
        // UI会不及时绘制，会隔一段时间 7到20几秒
        [self updateUI:name];
        // UI会及时绘制
//        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:[self testGcdNotificationName] object:self userInfo:nil];
    };
    
    dispatch_async(_addressBookQueue, block);
}


/**
 重要结论
 */

- (void)receiveNotification  // 此方法属于GCD线程
{
    NSString * name = [NSString stringWithFormat:@"监听通知 当前线程名称：%@", [[NSThread currentThread] name]];
    
    // GCD 不放在主线程UI会不及时绘制，放在主线程则会及时绘制。Thread则不会发生这样的问题
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:name]; // UI会及时绘制
    });

//    [self updateUI:name];   // UI会不及时绘制，会隔一段时间 7到20几秒
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

@end
