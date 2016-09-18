//
//  BST2And3Node.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "BST2And3Node.h"

@implementation BST2And3Node

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (BOOL)is2Node
{
    if ([self is3Node]) return NO;
    return YES;
}

- (BOOL)is3Node
{
    return (_minKey.length && _maxKey.length);
}

@end
