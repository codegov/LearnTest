//
//  BSTRBTree.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "BSTRBTree.h"
#import "BSTRBNode.h"

@implementation BSTRBTree
{
    BSTRBNode *_root;
}

- (id)getValue:(NSString *)key
{
    BSTRBNode *node = [self getNodeWithKey:key node:_root];
    return node.value;
}

- (BSTRBNode *)getNodeWithKey:(NSString *)key node:(BSTRBNode *)node
{
    if (node == nil) return nil;
    
    NSComparisonResult res = [key compare:node.key];
    if (res == NSOrderedSame) // 等于
    {
        return node;
    } else if (res == NSOrderedDescending) // 大于
    {
        return [self getNodeWithKey:key node:node.right];
    } else // 小于
    {
        return [self getNodeWithKey:key node:node.left];
    }
    return nil;
}


- (BSTRBNode *)rotateLeft:(BSTRBNode *)node
{
    BSTRBNode *t = node.right;
    node.right = t.left;
    t.left = node;
    t.isRed = node.isRed;
    node.isRed = YES;
    return t;
}

- (BSTRBNode *)rotateRight:(BSTRBNode *)node
{
    BSTRBNode *t = node.left;
    node.left = t.right;
    t.right = node;
    t.isRed = node.isRed;
    node.isRed = YES;
    return t;
}

- (BSTRBNode *)flipColor:(BSTRBNode *)node
{
    node.isRed = YES;
    node.left.isRed = NO;
    node.right.isRed = NO;
    
    return node;
}

- (void)putValue:(NSString *)key value:(id)value
{
    
}

- (BSTRBNode *)putNodeWithKey:(NSString *)key value:(id)value node:(BSTRBNode *)node
{
    if (node == nil)
    {
        node = [[BSTRBNode alloc] init];
        node.key    = key;
        node.value  = value;
        node.number = 1;
        node.isRed  = YES;
    } else
    {
        NSComparisonResult res = [key compare:node.key];
        if (res == NSOrderedSame) // 等于
        {
            node.value = value;
        } else if (res == NSOrderedDescending) // 大于
        {
            node.right = [self putNodeWithKey:key value:value node:node.right];
        } else // 小于
        {
            node.left = [self putNodeWithKey:key value:value node:node.left];
        }
        node.number = node.left.number + node.right.number + 1;
        
        if (node.right.isRed && !node.left.isRed) node = [self rotateLeft:node];
        if (node.right.isRed && node.left.left.isRed) node = [self rotateRight:node];
        if (node.right.isRed && node.left.isRed) node = [self flipColor:node];
    }
    return node;
}

- (void)delKey:(NSString *)key
{
    
}

- (void)log
{
    
}

@end
