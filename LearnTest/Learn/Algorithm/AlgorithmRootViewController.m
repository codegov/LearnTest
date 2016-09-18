//
//  AlgorithmRootViewController.m
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "AlgorithmRootViewController.h"

@implementation AlgorithmRootViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"Bloom Filter算法",  @"class": @"TestBloomFilterViewController"}];
    }
    return self;
}

@end
