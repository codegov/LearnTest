//
//  Son.m
//  LearnTest
//
//  Created by javalong on 16/9/14.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "Son.h"

@interface Son ()

@property (nonatomic, copy) NSString *name;

@end

@implementation Son

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class])); // 输出：Son
        NSLog(@"%@", NSStringFromClass([super class])); // 输出：Son
        BOOL res1 = [[NSObject class] isKindOfClass:[NSObject class]];
        BOOL res2 = [[NSObject class] isMemberOfClass:[NSObject class]];
        BOOL res3 = [[Son class] isKindOfClass:[Son class]];
        BOOL res4 = [[Son class] isMemberOfClass:[Son class]];
        NSLog(@"res=%@ %@ %@ %@", @(res1), @(res2), @(res3), @(res4)); // 输出：1 0 0 0
        
    }
    return self;
}

- (void)speak
{
    NSLog(@"my name's %@", self.name);
}

@end
