//
//  TestGcd2ViewController.m
//  LearnTest
//
//  Created by syq on 14/11/20.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestGcd2ViewController.h"

typedef void (^FinishBlock)(NSDictionary *userInfo, id value);

@interface Test2Gcd : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) dispatch_queue_t concurrentNameQueue;

@property (nonatomic, strong) FinishBlock block;

+ (instancetype)sharedInstance;

@end

@implementation Test2Gcd

+ (instancetype)sharedInstance
{
    static Test2Gcd *test = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        test = [[Test2Gcd alloc] init];
        test->_dataArray = [[NSMutableArray alloc] init];
        test->_concurrentNameQueue = dispatch_queue_create("com.learn.wz", DISPATCH_QUEUE_CONCURRENT);
    });
    return test;
}

- (void)queryNames
{
    dispatch_async(_concurrentNameQueue, ^{
        NSLog(@"queryNames");
        NSArray *array = [NSArray arrayWithArray:_dataArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Test2Gcd" object:array];
        });
    });
}

- (void)addName:(NSString *)name dealGroup:(dispatch_group_t)dealGroup
{
    if (name.length)
    {
        dispatch_barrier_async(self.concurrentNameQueue, ^{
            NSLog(@"%@\n", name);
            [_dataArray addObject:name];
            dispatch_group_leave(dealGroup);
        });
    }
}

@end

@interface TestGcd2ViewController ()
{
    dispatch_group_t dealGroup;
    dispatch_queue_t _concurrentQueue;
    NSMutableDictionary *_cacheResponseDictionary;
    FinishBlock _cacheBlock;
}
@end

@implementation TestGcd2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _concurrentQueue = dispatch_queue_create("com.teamwork.xmpp.groupUser", DISPATCH_QUEUE_CONCURRENT);
    
    _cacheBlock = ^(NSDictionary *userInfo, id value){
        NSLog(@"---------3333------");
    };
    
    FinishBlock block = ^(NSDictionary *userInfo, id value){
        NSLog(@"---------111------");
    };
    
    _cacheResponseDictionary = [[NSMutableDictionary alloc] init];
    Test2Gcd *test = [[Test2Gcd alloc] init];
    test.block = block;
    [_cacheResponseDictionary setObject:test forKey:@"test"];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 60)];
    [button setBackgroundColor:[UIColor brownColor]];
    [button addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = button;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"Test2Gcd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTest6GcdNotification:) name:@"Test6Gcd" object:nil];
    
    // 系统提供给你一个叫做 主队列（main queue） 的特殊队列。和其它串行队列一样，这个队列中的任务一次只能执行一个.
    // 系统同时提供给你好几个并发队列。它们叫做 全局调度队列（Global Dispatch Queues） 。
    // 目前的四个全局队列有着不同的优先级：background、low、default 以及 high。要知道，Apple 的 API 也会使用这些队列，所以你添加的任何任务都不会是这些队列中唯一的任务。
    // 你也可以创建自己的串行队列或并发队列.
    [self doGcd6];
}

- (void)doAction
{
    NSLog(@"\ndoAction_1");
    [[Test2Gcd sharedInstance] queryNames];
}

- (void)doGcd1
{
    //  dispatch_async() 异步执行 由GCD决定执行 不会阻塞当前线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *name = @"";
        for (int i = 0; i < 1000; i++) {
            name = [NSString stringWithFormat:@"%@%d", name, i];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI:name];
        });
    });
}

- (void)doGcd2
{
    // dispatch_after 工作起来就像一个延迟版的 dispatch_async 。
    // 你依然不能控制实际的执行时间，且一旦 dispatch_after 返回也就不能再取消它。
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self.navigationItem setPrompt:@"测试GCT延迟执行玩"];
    });
    
    delayInSeconds = 3.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self.navigationItem setPrompt:nil];
    });
}

// 处理读与写问题
- (void)doGcd3
{
    dealGroup = dispatch_group_create();
    [self dealReadAndWrite1:^(int value) {
        [[Test2Gcd sharedInstance] queryNames];
    }];
}

- (void)dealReadAndWrite1:(void (^)(int value))comBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        for (int i = 0; i < 400; i++) {
            dispatch_group_enter(dealGroup);
            [[Test2Gcd sharedInstance] addName:[NSString stringWithFormat:@"name_%d", i] dealGroup:dealGroup];
            
        }
        
        dispatch_group_notify(dealGroup, dispatch_get_main_queue(), ^{
            if (comBlock) {
                comBlock (4);
            }
        });
    });
}

- (void)dealReadAndWrite2:(void (^)(int value))comBlock
{    
    dispatch_apply(4000, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        dispatch_group_enter(dealGroup);
        [[Test2Gcd sharedInstance] addName:[NSString stringWithFormat:@"name_%zu", i] dealGroup:dealGroup];
    });
    dispatch_group_notify(dealGroup, dispatch_get_main_queue(), ^{
        if (comBlock) {
            comBlock (4);
        }
    });
}

- (void)receiveNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSArray class]])
    {
        self.dataArray.array = (NSArray *)notification.object;
        [self.tableView  reloadData];
    }
}


- (void)doGcd4
{
    dispatch_async(_concurrentQueue, ^{
        Test2Gcd *test = [_cacheResponseDictionary objectForKey:@"test"];
        [_cacheResponseDictionary removeObjectForKey:@"test"];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"==1==");
            if (test.block)
            {
                test.block(nil, nil);
            }
        });
        NSLog(@"==2==");
        FinishBlock block = ^(NSDictionary *userInfo, id value){
            NSLog(@"=======2=========");
        };
        Test2Gcd *te = [[Test2Gcd alloc] init];
        te.block= block;
        [_cacheResponseDictionary setObject:te forKey:@"test"];
        
    });
}

- (void)doGcd5
{
    dispatch_async(_concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"==1==");
//            _cacheBlock(nil, nil);
//            _cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);_cacheBlock(nil, nil);
            if (_cacheBlock)
            {
                _cacheBlock(nil, nil);
            }
        });
//        NSLog(@"==2==");
//        _cacheBlock = nil;
//        _cacheBlock= ^(NSDictionary *userInfo, id value){
//            NSLog(@"=======2=========");
//        };
//        _cacheBlock (nil, nil);
        _cacheBlock = nil;
        
    });
}

- (void)doGcd6
{
    [[NSUserDefaults standardUserDefaults] setObject:@"哈哈" forKey:@"haha"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    dispatch_async(_concurrentQueue, ^{
//        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"haha"];
//        NSLog(@"--==--value %@", value);
//    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Test6Gcd" object:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"haha"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)receiveTest6GcdNotification:(NSNotification *)notification
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"haha"];
    NSLog(@"11--==--value %@", value);
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
