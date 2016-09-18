//
//  BuyTicketViewController.m
//  LearnTest
//
//  Created by syq on 14/10/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "BuyTicketViewController.h"

@interface BuyTicketViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int tickets;
    int count;
//    NSThread* ticketsThreadone;
//    NSThread* ticketsThreadtwo;
    NSCondition* ticketsCondition;
    NSLock *theLock;
    
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}
@end

@implementation BuyTicketViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, _tableView.frame.size.width, 40.0)];
    [button setTitle:@"重新运行" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor brownColor];
    _tableView.tableHeaderView = button;
    
    [_tableView reloadData];
    
    [self startThread];
}

- (void)buttonAction
{
    tickets = 100;
}

- (void)startThread
{
    theLock = nil;
    ticketsCondition = nil;
    
    tickets = 2;//100;
    count = 0;
    theLock = [[NSLock alloc] init];
    // 锁对象
    ticketsCondition = [[NSCondition alloc] init];
    
    
//    BOOL exitNow = NO;
//    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    
    NSThread *ticketsThreadone = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadone setName:@"Thread-1"];
    [ticketsThreadone start];
    
    
    NSThread *ticketsThreadtwo = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [ticketsThreadtwo setName:@"Thread-2"];
    [ticketsThreadtwo start];
    
    NSThread *ticketsThreadthree = [[NSThread alloc] initWithTarget:self selector:@selector(run3) object:nil];
    [ticketsThreadthree setName:@"Thread-3"];
    [ticketsThreadthree start];
}


-(void)run3
{
    while (YES) {
        [ticketsCondition lock];
//        [NSThread sleepForTimeInterval:1];
        [ticketsCondition signal]; // 通过[ticketsCondition signal];发送信号的方式，在一个线程唤醒另外一个线程的等待。
        [ticketsCondition unlock];
    }
}

- (void)run
{
    while (TRUE) {
        // 上锁
        if (ticketsCondition)
        {
            [ticketsCondition lock];
            [ticketsCondition wait]; // wait是等待，通过 线程3 去唤醒其他两个线程锁中的wait
            [theLock lock];
            if(tickets >= 0){
                [self dealTicket];
            } else {
                break;
            }
            [theLock unlock];
            [ticketsCondition unlock];
        } else
        {
            @synchronized(self) // 等同 [theLock lock];[theLock unlock];
            {
                if(tickets >= 0){
                    [self dealTicket];
                } else {
                    break;
                }
            }
        }
        
    }
}


- (void)dealTicket
{
    //            [NSThread sleepForTimeInterval:0.09];
    count = 100 - tickets;
    NSString *name = [NSString stringWithFormat:@"当前票数是:%d,售出:%d,线程名:%@",tickets,count,[[NSThread currentThread] name]];
    NSLog(@"%@", name);
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:YES];
    tickets--;
}


- (void)updateUI:(NSString *)name
{
    [_dataArray addObject:name];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(_dataArray.count - 1) inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    NSLog(@"2cell===%@,线程名:%@", @(indexPath.row).stringValue, [[NSThread currentThread] name]);
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
