//
//  RuntimeRootViewController.m
//  LearnTest
//
//  Created by syq on 14/12/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "RuntimeRootViewController.h"
//#import "UIFont+TestFont.h"
#import "Son.h"
#import "NSObject+Sark.h"

@implementation RuntimeRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试Runtime1",  @"class": @"TestRuntime1ViewController"}];
//        [self.dataArray addObject:@{@"title": @"测试Runtime2",  @"class": @"TestRuntime2ViewController"}];
//        [self.dataArray addObject:@{@"title": @"测试Runtime3",  @"class": @"TestRuntime3ViewController"}];
        NSLog(@"font === %@   %@  %@   %@", @([UIFont systemFontSize]), @([UIFont labelFontSize]), @([UIFont buttonFontSize]), @([UIFont smallSystemFontSize]));
        
        Son *son = [[Son alloc] init];
        
        id cls = [Son class];
        void *obj = &cls;
        [(__bridge id)obj speak];  /// 输出：my name's <Son: 0x7b670d90>
        
        [NSObject foo];
//        [[NSObject new] foo];
    }
    return self;
}

@end
