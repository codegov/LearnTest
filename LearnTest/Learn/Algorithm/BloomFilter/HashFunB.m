//
//  HashFunB.m
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "HashFunB.h"

@implementation HashFunB

- (long)gethashval:(const char *)key
{
    unsigned int h=0;
    while(*key) h=(unsigned char)*key++ + (h<<6) + (h<<16) - h;
    return h%80000;
}

@end
