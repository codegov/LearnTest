//
//  TestBloomFilterViewController.m
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "TestBloomFilterViewController.h"
#import "HashFunA.h"
#import "HashFunB.h"
#import "Bloom.h"

@implementation TestBloomFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HashFunA *funa = [[HashFunA alloc] init];
    HashFunB *funb = [[HashFunB alloc] init];
    
    NSMutableArray *funArray = [[NSMutableArray alloc] init];
    [funArray addObject:funa];
    [funArray addObject:funb];
    
    Bloom *bloom = [[Bloom alloc] initWithSize:10000 hashfunclist:funArray];
    [bloom add:"hello"];
    [bloom add:"world"];
    [bloom add:"ipad"];
    [bloom add:"iphone4"];
    [bloom add:"ipod"];
    [bloom add:"apple"];
    [bloom add:"banana"];
    [bloom add:"hello"];
    
    const char *c = "ipod";
    BOOL value = [bloom check:c];
    
    NSLog(@"%s是否存在==%d", c, value);
}



@end
