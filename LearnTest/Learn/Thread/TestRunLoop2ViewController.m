//
//  TestRunLoop2ViewController.m
//  LearnTest
//
//  Created by syq on 14/10/23.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestRunLoop2ViewController.h"

#define kCheckinMessage 100
#define LOCAL_MACH_PORT_NAME    "com.wangzz.demo"

@interface TestRunLoop2ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton   *button;
    
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    
    CFRunLoopRef runLoop1;
}
@end

@implementation TestRunLoop2ViewController

// 声明为静态变量，这样较方便我们在c函数中访问：
static int loops=0;
static CFRunLoopSourceRef source;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10.0, 74.0, self.view.bounds.size.width - 20.0, self.view.bounds.size.height - 84.0)];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor brownColor].CGColor;
    view.layer.cornerRadius = 6.0;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, view.frame.size.width, view.bounds.size.height - 70.0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(10.0, view.bounds.size.height + view.bounds.origin.y + 15.0, self.view.bounds.size.width - 20.0 - 80.0, 50.0)];
    [button setTitle:@"Run" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(runOrStop:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width, button.frame.origin.y, 80.0, 50.0)];
    [button1 addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    button1.backgroundColor = [UIColor brownColor];
    [self.view addSubview:button1];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSLog(@"--viewWillDisappear--");
    [self closeRunLoop];
}

- (void)openAction
{
    NSLog(@"open");
    if (runLoop1 && CFRunLoopIsWaiting(runLoop1)) {
        CFRunLoopWakeUp(runLoop1);
        loops++;
        if(source) CFRunLoopSourceSignal(source);
    }
}

- (void)closeRunLoop
{
    if (runLoop1) CFRunLoopStop(runLoop1);
}

- (void)runOrStop:(id)sender
{
    NSLog(@"run");
    if ([@"Run" isEqualToString:button.titleLabel.text])
    {
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        
        NSThread *thread_1 = [[NSThread alloc] initWithTarget:self selector:@selector(aThread) object:nil];
        [thread_1 setName:@"thead_1"];
        [thread_1 start];
        
//        NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(aThread) object:nil];
//        [thread2 setName:@"thead_2"];
//        [thread2 start];
    }
}

- (void)aThread
{
    @synchronized(self)
    {
        CFStringRef model = kCFRunLoopCommonModes;//(CFStringRef)@"test";
        //CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), model);
        
        source = [self addSourceWithModel:model];
        [self addObserverWithModel:model];
        [self addTimerWithModel:model];
        [self addPortWith:model];
        
        runLoop1 = CFRunLoopGetCurrent();
        
        //CFRunLoopRunInMode(model, 1, TRUE);
        CFRunLoopRun();
    }
}

#pragma mark - 添加端口

- (CFRunLoopSourceRef)addPortWith:(CFStringRef)model
{
    CFMessagePortContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    CFStringRef portName = CFStringCreateWithFormat(kCFAllocatorDefault, NULL, CFSTR(LOCAL_MACH_PORT_NAME));
    Boolean shouldFreeInfo;
    CFMessagePortRef myport = CFMessagePortCreateLocal(kCFAllocatorDefault,
                                                       portName,
                                                       &MainThreadResponseHandler,
                                                       &context,
                                                       &shouldFreeInfo);
    if (myport != NULL) {
        CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, myport, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, model);
        return source;
    }
    
    return nil;
}

#pragma mark - 添加自定义源

- (CFRunLoopSourceRef)addSourceWithModel:(CFStringRef)model
{
    //void*类型（即id类型）
    CFRunLoopSourceContext source_context;
    bzero(&source_context, sizeof(source_context));
    source_context.perform = _perform;
    source_context.info    = (__bridge void *)(self);
    CFRunLoopSourceRef source_temp = CFRunLoopSourceCreate(NULL, 0, &source_context);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source_temp, model);
    
    return source_temp;
}

#pragma mark - 添加观察者源

- (CFRunLoopObserverRef)addObserverWithModel:(CFStringRef)model
{
    //设置Run loop observer的运行环境
    CFRunLoopObserverContext observer_context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    //创建Run loop observer对象
    //第一个参数用于分配observer对象的内存  kCFAllocatorDefault与NULL 等价
    //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
    //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    //第四个参数用于设置该observer的优先级
    //第五个参数用于设置该observer的回调函数
    //第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &observer_context);
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, model);
    
    return observer;
}

#pragma mark - 添加定时器源

- (CFRunLoopTimerRef)addTimerWithModel:(CFStringRef)model
{
    CFRunLoopTimerContext timer_context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(NULL, CFAbsoluteTimeGetCurrent(), 1, 0, 0, _timer, &timer_context);
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, model);
    return timer;
}


#pragma mark - runloop 观察回调

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch (activity)
    {
            //The entrance of the run loop, before entering the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
            //Inside the event processing loop before any timers are processed
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
            //Inside the event processing loop before any sources are processed
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
            //Inside the event processing loop before the run loop sleeps, waiting for a source or timer to fire.
            //This activity does not occur if CFRunLoopRunInMode is called with a timeout of 0 seconds.
            //It also does not occur in a particular iteration of the event processing loop if a version 0 source fires
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
            //Inside the event processing loop after the run loop wakes up, but before processing the event that woke it up.
            //This activity occurs only if the run loop did in fact go to sleep during the current loop
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
            //The exit of the run loop, after exiting the event processing loop.
            //This activity occurs once for each call to CFRunLoopRun and CFRunLoopRunInMode
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
            /*
             A combination of all the preceding stages
             case kCFRunLoopAllActivities:
             break;
             */
        default:  
            break;  
    }  
}

#pragma mark - 自定义源回调

void _perform(void *info)
{
    NSString *name = [NSString stringWithFormat:@"自定义源回调：%d", loops];
    
    NSLog(@"自定义源回调：%d", loops);
    BOOL close = loops%3 == 0;
    
    id obj=(__bridge id)info;
    
    [obj performSelectorOnMainThread:@selector(updateTextView:) withObject:name waitUntilDone:NO];
    
    if ([obj respondsToSelector:@selector(sendMessage:msgId:)]) {
        [obj performSelector:@selector(sendMessage:msgId:) withObject:name withObject:[NSNumber numberWithInt:loops]];
    }
    
    if (close)
    {
        CFRunLoopStop(CFRunLoopGetCurrent());
        NSString * name = [NSString stringWithFormat:@"当前线程名称：%@停止任务", [[NSThread currentThread] name]];
        [obj performSelectorOnMainThread:@selector(updateTextView:) withObject:name waitUntilDone:NO];
    }
}

#pragma mark - 定时源回调

void _timer(CFRunLoopTimerRef timer __unused, void *info)
{
    loops++;
    NSString * name = [NSString stringWithFormat:@"定时源回调：：%@线程：%d", [[NSThread currentThread] name], loops];
    id obj=(__bridge id)info;
    [obj performSelectorOnMainThread:@selector(updateTextView:) withObject:name waitUntilDone:NO];
   
    if(source) CFRunLoopSourceSignal(source);
}

#pragma mark - 端口通讯 发送

- (NSString *)sendMessage:(NSString *)msg msgId:(NSNumber *)msgId
{
    CFMessagePortRef bRemote = CFMessagePortCreateRemote(kCFAllocatorDefault, CFSTR(LOCAL_MACH_PORT_NAME));
    if (nil == bRemote) {
        return nil;
    }
    
    const char *messge = [msg UTF8String];
    CFDataRef data,recvData = nil;
    data = CFDataCreate(kCFAllocatorDefault, (UInt8 *)messge, strlen(messge));
    CFMessagePortSendRequest(bRemote, msgId.intValue, data, 0, 100, kCFRunLoopDefaultMode, &recvData);
    if (nil == recvData) {
        CFRelease(data);
        CFMessagePortInvalidate(bRemote);
        CFRelease(bRemote);
        return nil;
    }
    const UInt8 *recvedMsg = CFDataGetBytePtr(recvData);
    if (nil == recvedMsg) {
        CFRelease(data);
        CFMessagePortInvalidate(bRemote);
        CFRelease(bRemote);
        return nil;
    }
    
    NSString *strMsg = [NSString stringWithCString:(char *)recvedMsg encoding:NSUTF8StringEncoding];
    
    CFRelease(data);
    CFMessagePortInvalidate(bRemote);
    CFRelease(bRemote);
    CFRelease(recvData);
    
    return strMsg;
}

#pragma mark - 端口通讯 监听

CFDataRef MainThreadResponseHandler(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info)
{
    NSString *strData = nil;
    if (data) {
        const UInt8 *recvedMsg = CFDataGetBytePtr(data);
        strData = [NSString stringWithCString:(char *)recvedMsg encoding:NSUTF8StringEncoding];
    }
    
    NSString *returnString = [NSString stringWithFormat:@"我已经接收了：%@", strData];
    
    NSString *name = [NSString stringWithFormat:@"接收到消息%d：%@", (int)msgid, strData];
    id obj=(__bridge id)info;
    [obj performSelectorOnMainThread:@selector(updateTextView:) withObject:name waitUntilDone:NO];
    
    const char *cStr = [returnString UTF8String];
    NSUInteger ulen = [returnString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    CFDataRef sg = CFDataCreate(kCFAllocatorDefault, (UInt8 *)cStr, ulen);
    return sg;
}


#pragma mark - 更新UI

- (void)updateTextView:(NSString *)name
{
    NSLog(@"%@\n", name);
    [_dataArray addObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(_dataArray.count - 1) inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
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
    NSLog(@"dealloc");
}


@end
