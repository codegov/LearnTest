//
//  TestThread1ViewController.m
//  LearnTest
//
//  Created by syq on 14/10/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestThread1ViewController.h"

@interface TestThread1ViewController ()
{
    BOOL end;
}
@end

@implementation TestThread1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"start new thread …");
    [NSThread detachNewThreadSelector:@selector(runOnNewThread) toTarget:self withObject:nil];
    while (!end) {
        NSLog(@"runloop…");
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        NSLog(@"runloop end.");
    }
    NSLog(@"ok.");
}

-(void)runOnNewThread{
    NSLog(@"run for new thread …");
    sleep(1);
    end=YES;
    NSLog(@"end.");
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
