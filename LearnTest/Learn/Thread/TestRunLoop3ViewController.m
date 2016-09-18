//
//  TestRunLoop1ViewController.m
//  LearnTest
//
//  Created by syq on 14/10/22.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestRunLoop3ViewController.h"

@interface TestRunLoop3ViewController ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    BOOL pageStillLoading;
    BOOL finished;
}
@end

@implementation TestRunLoop3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)finishURL
{
    finished = YES;
    NSLog(@"---5");
}

- (void)reOpenURL
{
    [self openURL];
}

- (void)openURL
{
    NSLog(@"0");
    finished = NO;
    [NSThread detachNewThreadSelector:@selector(loadURLAction) toTarget:self withObject:nil]; // 4
    NSLog(@"1");
}

- (void)loadURLAction
{
    NSLog(@"1_1");
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:@"正在执行..." waitUntilDone:YES];
    
    while(!finished)
    {
        NSLog(@"2");
        NSDate *date = [NSDate distantFuture];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];
        NSLog(@"3");
    }
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:@"执行结束" waitUntilDone:YES];
}



- (void)updateUI:(NSString *)name
{
    NSLog(@"%@", name);
    [self.dataArray addObject:name];
    [self.tableView reloadData];
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = self.view.bounds.size.width/3;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 64.0, self.view.bounds.size.width, 40.0)];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 40.0)];
    [button1 setTitle:@"开始" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor brownColor];
    [button1 addTarget:self action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    float x = button1.frame.size.width + button1.frame.origin.x;
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, view.frame.size.height)];
    [button2 setTitle:@"结束" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(finishURL) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    x = button2.frame.size.width + button2.frame.origin.x;
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, view.frame.size.height)];
    [button3 setTitle:@"重新开始" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor blueColor];
    [button3 addTarget:self action:@selector(reOpenURL) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button3];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
