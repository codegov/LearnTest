//
//  HashFunA.m
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "HashFunA.h"

@implementation HashFunA

- (long)gethashval:(const char *)key
{
    unsigned int h = 0;
    while (*key)
    {
        h^=(h<<5)+(h>>2)+(unsigned char)*key++;
    }
    return h%80000;
}

@end
