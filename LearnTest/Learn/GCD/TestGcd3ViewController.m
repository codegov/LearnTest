//
//  TestGcd3ViewController.m
//  LearnTest
//
//  Created by syq on 14/12/1.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestGcd3ViewController.h"

#define XMPP_LISTEN_RECEIVE     @"12"
#define ABC(x) x*x

@interface TestGcd3ViewController ()
{
    dispatch_queue_t _conQueue;
    
    NSMutableDictionary *dic;
    
    dispatch_source_t timer;
}
@end

@implementation TestGcd3ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        dic = [[NSMutableDictionary alloc] init];
        _conQueue = dispatch_queue_create("com.learn.testgcd3", DISPATCH_QUEUE_CONCURRENT);
//        _conQueue = dispatch_queue_create("com.learn.testgcd3", DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification) name:@"test" object:nil];
    }
    return self;
}

- (void)postXMPPNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test12];
    
//    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:6];
//    for (int i = 0 ; i < 6; i ++) {
//        [array addObject:@"0"];
//    }
//    [array insertObject:XMPP_LISTEN_RECEIVE atIndex:3];
//    
//    NSLog(@"array == =%@", array);
//    
//    NSLog(@"index===%d", [array indexOfObject:@"12"]);
//    
//    NSString *ss = @"12";
//    NSLog(@"index==1=%d", [array indexOfObject:ss]);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        __block NSString *value = @"test1";
//        __block int i = 3;
//        
//        dispatch_barrier_async(_conQueue, ^{
//            NSLog(@"value1 == %@ %d", value, i);
//            value = @"-----"; i =0;
//            [dic setObject:@"--1" forKey:@"test"];
//            
//            dispatch_barrier_async(_conQueue, ^{
//                NSLog(@"value2 == %@ %d", value, i);
//                [dic setObject:@"--3" forKey:@"test"];
//            });
//            [dic setObject:@"--1" forKey:@"test"];
//            
//            NSLog(@"value4 == %@ %d", value, i);
//            [self postXMPPNotification:@"test" object:nil userInfo:nil];
//        });
//        
//        dispatch_sync(_conQueue, ^{
//            NSLog(@"+++%@", dic);
//        });
//        i = 5;
//        value = @"test2";
//        NSLog(@"value3=%@  %d", value, i);
//    });
}

- (void)deadLockCase3 {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"deadLockCase1");
    dispatch_async(serialQueue, ^{
        NSLog(@"deadLockCase2");
        //串行队列里面同步一个串行队列就会死锁
        dispatch_sync(serialQueue, ^{
            NSLog(@"deadLockCase3");
        });
        NSLog(@"deadLockCase4");
    });
    NSLog(@"deadLockCase5");
}

- (void)noticationAction
{
    NSLog(@"noticationAction==%@", @([[NSProcessInfo processInfo] systemUptime]));
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t firstQueue = dispatch_queue_create("com.starming.gcddemo.firstqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t secondQueue = dispatch_queue_create("com.starming.gcddemo.secondqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_set_target_queue(firstQueue, serialQueue);
    dispatch_set_target_queue(secondQueue, serialQueue);
    
    dispatch_async(firstQueue, ^{
        NSLog(@"1");
        //        [NSThread sleepForTimeInterval:3.f];
    });
    dispatch_async(secondQueue, ^{
        NSLog(@"2");
        //        [NSThread sleepForTimeInterval:2.f];
    });
    dispatch_async(secondQueue, ^{
        NSLog(@"3");
        //        [NSThread sleepForTimeInterval:1.f];
    });
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, firstQueue, ^(void){
        [self testAction];
    });
    
    //GCD定时器
    int interval = 1;
    int leeway = 0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), interval * NSEC_PER_SEC, leeway);
        dispatch_source_set_event_handler(timer, ^{
            NSLog(@"someMethod");
        });
        
        dispatch_resume(timer);
    }
}

- (void)testAction
{
    NSLog(@"testAction");
}

- (void)receiveTestNotification
{
    [self test0];
}

- (void)test6 // 并发队列--运行正常；串行队列--死锁
{
    dispatch_sync(_conQueue, ^{
        NSLog(@"1--=====%@", dic);
        for (int i =0; i < 100; i++) {
            NSLog(@"===---%d", i);
            dispatch_sync(_conQueue, ^{
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"3--=====%@", dic);
            });
        }
        NSLog(@"2--=====%@", dic);
    });
}

- (void)test5 //  并发队列--运行正常；串行队列--运行正常
{
    dispatch_async(_conQueue, ^{
        NSLog(@"1--=====%@", dic);
        for (int i =0; i < 100; i++) {
            NSLog(@"===---%d", i);
            dispatch_async(_conQueue, ^{
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"3--=====%@", dic);
            });
        }
        NSLog(@"2--=====%@", dic);
    });
}

- (void)test4 //  并发队列--运行正常；串行队列--运行正常
{
    for (int i = 0; i < 100; i++) {
        NSLog(@"===---%d", i);
        dispatch_async(_conQueue, ^{
            NSLog(@"1--=====%@", dic);
            dispatch_async(_conQueue, ^{
                [dic setObject:@"--4" forKey:@"test"];
            });
            NSLog(@"2--=====%@", dic);
        });
    }
}

- (void)test3 //  并发队列--运行正常；串行队列--运行正常
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"===---%d", i);
            dispatch_sync(_conQueue, ^{
                NSLog(@"1--=====%@", dic);
                dispatch_barrier_async(_conQueue, ^{
                    [dic setObject:@"--4" forKey:@"test"];
                });
                NSLog(@"2--=====%@", dic);
            });
        }
    });
}

- (void)test2 //  并发队列--运行正常；串行队列--运行正常
{
    for (int i = 0; i < 100; i++) {
        dispatch_sync(_conQueue, ^{
            NSLog(@"\n\n===---%d", i);
            NSLog(@"1--=====%@", dic);
            dispatch_async(_conQueue, ^{
                NSLog(@"3--=====%@", dic);
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"4--=====%@", dic);
            });
            NSLog(@"2--=====%@", dic);
        });
    }
}

- (void)test1 //  并发队列--死锁；串行队列--死锁
{
    dispatch_async(_conQueue, ^{
        for (int i = 0; i < 100; i++)
        {
            NSLog(@"\n\n===---%d", i);
            NSLog(@"1--=====%@", dic);
            dispatch_sync(_conQueue, ^{
                NSLog(@"3--=====%@", dic);
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"4--=====%@", dic);
            });
            NSLog(@"2--=====%@", dic);
        }
    });
}

- (void)test0 //  并发队列--死锁；串行队列--死锁
{
    dispatch_barrier_async(_conQueue, ^{
        for (int i = 0; i < 100; i++)
        {
            NSLog(@"\n\n===---%d", i);
            NSLog(@"1--=====%@", dic);
            dispatch_sync(_conQueue, ^{
                NSLog(@"3--=====%@", dic);
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"4--=====%@", dic);
            });
            NSLog(@"2--=====%@", dic);
        }
    });
}

- (void)test11
{
    dispatch_barrier_async(_conQueue, ^{
        for (int i = 0; i < 100; i++)
        {
            NSLog(@"\n\n===---%d", i);
            NSLog(@"1--=====%@", dic);
            dispatch_barrier_async(_conQueue, ^{
                NSLog(@"3--=====%@", dic);
                [dic setObject:@"--4" forKey:@"test"];
                NSLog(@"4--=====%@", dic);
            });
            NSLog(@"2--=====%@", dic);
        }
    });
}

- (void)testhehe
{
    for (int i = 0; i < 10; i++) {
        [self updateUI:[NSString stringWithFormat:@"呵呵——%d", i]];
    }
}

- (void)test12
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
        dispatch_async(_conQueue, ^{
            NSLog(@"2");
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"3");
            });
            NSLog(@"4");
        });
        NSLog(@"5");
    });
    
//    int a, k=3;
//    a=++ABC(k + 1); // ++k + 1 * k + 1;
//    NSLog(@"---------%d------", a);
}




#pragma mark - 更新UI

- (void)updateUI:(NSString *)name
{
    NSLog(@"%@\n", name);
    [self.dataArray addObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView reloadData];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    for (int i = 0; i < 100; i++) {
        NSLog(@"---%d", i);
    }
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
