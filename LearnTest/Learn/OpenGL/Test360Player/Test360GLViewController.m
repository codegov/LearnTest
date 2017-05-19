//
//  Test360GLViewController.m
//  LearnTest
//
//  Created by javalong on 2016/12/26.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "Test360GLViewController.h"
@import CoreAudio;

@interface Test360GLViewController ()

@end

@implementation Test360GLViewController
{
    dispatch_semaphore_t frameRenderingSemaphore; // 信号量
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testSemaphore];
//    [self testRegular];
}

- (void)testRegular
{
    NSString *string = @"NSString(ccc, dsds)";
    NSError *regexError = nil;
    NSRegularExpression *parsingRegex = [NSRegularExpression regularExpressionWithPattern:@"(float|CGPoint|NSString)\\((.*?)(?:,\\s*(.*?))*\\)" options:0 error:&regexError];
    NSTextCheckingResult *parse = [parsingRegex firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    NSLog(@"======%@", parse);
    
    for (int i = 0; i < parse.numberOfRanges; i++)
    {
        NSString *modifier2 = [string substringWithRange:[parse rangeAtIndex:i]];
        NSLog(@"modifier***===%@", modifier2);
    }
}

- (void)testSemaphore
{
    frameRenderingSemaphore = dispatch_semaphore_create(1); // 并发只允许一个线程
    
    for (int i = 0; i < 3; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self test2:[@"test_" stringByAppendingString:@(i).stringValue]];
        });
    }
    
    sleep(3);
    
    for (int i = 3; i < 8; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSString *msg = [@"test_" stringByAppendingString:@(i).stringValue];
            NSLog(@"for21=========%@", msg);
            [self test2:msg];
            NSLog(@"for22=========%@", msg);
        });
    }
}

- (void)test:(NSString *)msg
{
    if (dispatch_semaphore_wait(frameRenderingSemaphore, DISPATCH_TIME_NOW) != 0) // 减一
    {
        NSLog(@"waiting.....%@", msg);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"------1--------%@", msg);
        sleep(2);
        NSLog(@"------2--------%@", msg);
        dispatch_semaphore_signal(frameRenderingSemaphore); // 加一
        NSLog(@"------3--------%@", msg);
    });
}

- (void)test2:(NSString *)msg
{
    dispatch_semaphore_wait(frameRenderingSemaphore, DISPATCH_TIME_FOREVER);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"------1--------%@", msg);
        sleep(2);
        NSLog(@"------2--------%@", msg);
        dispatch_semaphore_signal(frameRenderingSemaphore); // 加一
        NSLog(@"------3--------%@", msg);
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
