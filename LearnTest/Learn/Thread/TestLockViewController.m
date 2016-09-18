//
//  TestLockViewController.m
//  LearnTest
//
//  Created by syq on 14/11/12.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestLockViewController.h"

@interface TestLockViewController ()
{
    NSLock *theLock;
    NSRecursiveLock *recursiveLock;
    NSConditionLock *conditionLock;
    NSCondition     *condition;
}
@end

@implementation TestLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    theLock = [[NSLock alloc] init];
    recursiveLock = [[NSRecursiveLock alloc] init];
    conditionLock = [[NSConditionLock alloc] initWithCondition:1];
    condition     = [[NSCondition alloc] init];
    
    NSThread *thread_1  = [[NSThread alloc] initWithTarget:self selector:@selector(doThread) object:nil];
    thread_1.name = @"thread_1";
    [thread_1 start];
    
    NSThread *thread_2 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread) object:nil];
    thread_2.name = @"thread_2";
    [thread_2 start];
    
    NSThread *thread_3 = [[NSThread alloc] initWithTarget:self selector:@selector(doThread7) object:nil];
    thread_3.name = @"thread_3";
    [thread_3 start];
}

- (void)doThread
{
    [self doThread6];
}

- (void)doThread1
{
    //方法 tryLock 试图获取一个锁,但是如果锁不可用的时候,它不会阻塞线程。相反,它只 是返回 NO
    if ([theLock tryLock])
    {
        NSString * name = [NSString stringWithFormat:@"1当前线程名称：%@", [[NSThread currentThread] name]];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
        [theLock unlock];
    }
}

- (void)doThread2
{
    [theLock lock];
    NSString * name = [NSString stringWithFormat:@"2当前线程名称：%@", [[NSThread currentThread] name]];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
    [theLock unlock];
}

- (void)doThread3
{
    //lockBeforeDate:方法试图获取一个锁,但是如果锁没有在规定的时间 内被获得,它会让线程从阻塞状态变为非阻塞状态(或者返回 NO)
    if ([theLock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:1]])
    {
//        [NSThread sleepForTimeInterval:2];
        NSString * name = [NSString stringWithFormat:@"3当前线程名称：%@", [[NSThread currentThread] name]];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
        [theLock unlock];
    }
}

- (void)doThread4
{
    @synchronized(self)
    {
        NSString * name = [NSString stringWithFormat:@"4当前线程名称：%@", [[NSThread currentThread] name]];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
    }
}

- (void)doThread5
{
    [self doThreadRecursive:5];
}

- (void)doThread6
{
    [self doThreadConditionProduce];
}

- (void)doThread7
{
    [self doTreadConditionConsume];
}

- (void)doThread8
{
    [condition lock];
    [condition wait];  // 等待doThread9方法唤醒
    NSString * name = [NSString stringWithFormat:@"8当前线程名称：%@", [[NSThread currentThread] name]];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
    [condition unlock];
}

- (void)doThread9
{
    [condition lock];
    NSString * name = [NSString stringWithFormat:@"9当前线程名称：%@", [[NSThread currentThread] name]];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
    [condition signal]; // 唤醒doThread8方法中的等待
    [condition signal];
    [condition unlock];
}

- (void)doThreadRecursive:(int)value
{
    [recursiveLock lock];  // 递归锁
    if (value != 0)
    {
        NSString * name = [NSString stringWithFormat:@"5当前线程名称：%@ value=%d", [[NSThread currentThread] name], value];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
        --value;
        [self doThreadRecursive:value];
    }
    [recursiveLock unlock];
}

- (void)doThreadConditionProduce
{
    [conditionLock lock];
    for (int i=0;i<=2;i++)
    {
        NSLog(@"thread1:%d",i);
        NSString * name = [NSString stringWithFormat:@"6当前线程名称：%@", [[NSThread currentThread] name]];
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
        sleep(1);
    }
    [conditionLock unlockWithCondition:2];
}

- (void)doTreadConditionConsume
{
    [conditionLock lockWhenCondition:2]; // 当doThreadConditionProduce方法设置了开锁条件时，这里设置的条件必须和设置的一致，才能开锁并得以执行
    NSString * name = [NSString stringWithFormat:@"7当前线程名称：%@", [[NSThread currentThread] name]];
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:name waitUntilDone:NO];
    [conditionLock unlock];
}

//分别使用8种方式加锁 解锁1千万次
- (void)runLock
{
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    
    //@synchronized
    id obj = [[NSObject alloc]init];;
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        @synchronized(obj){
        }
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("@synchronized used : %f\n", timeCurrent-timeBefore);
    
    //NSLock
    NSLock *lock = [[NSLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [lock lock];
        [lock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSLock used : %f\n", timeCurrent-timeBefore);
    
    //NSCondition
    NSCondition *condition = [[NSCondition alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [condition lock];
        [condition unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSCondition used : %f\n", timeCurrent-timeBefore);
    
    //NSConditionLock
    NSConditionLock *conditionLock = [[NSConditionLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [conditionLock lock];
        [conditionLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSConditionLock used : %f\n", timeCurrent-timeBefore);
    
    //NSRecursiveLock
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [recursiveLock lock];
        [recursiveLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock used : %f\n", timeCurrent-timeBefore);
    
    //pthread_mutex
//    pthread_mutex_t mutex =PTHREAD_MUTEX_INITIALIZER;
//    timeBefore = CFAbsoluteTimeGetCurrent();
//    for(i=0; i<count; i++){
//        pthread_mutex_lock(&mutex);
//        pthread_mutex_unlock(&mutex);
//    }
//    timeCurrent = CFAbsoluteTimeGetCurrent();
//    printf("pthread_mutex used : %f\n", timeCurrent-timeBefore);
    
    //dispatch_semaphore
    dispatch_semaphore_t semaphore =dispatch_semaphore_create(1);
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("dispatch_semaphore used : %f\n", timeCurrent-timeBefore);
    
    //OSSpinLockLock
//    OSSpinLock spinlock = OS_SPINLOCK_INIT;
//    timeBefore = CFAbsoluteTimeGetCurrent();
//    for(i=0; i<count; i++){
//        OSSpinLockLock(&spinlock);
//        OSSpinLockUnlock(&spinlock);
//    }
//    timeCurrent = CFAbsoluteTimeGetCurrent();
//    printf("OSSpinLock used : %f\n", timeCurrent-timeBefore);
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
