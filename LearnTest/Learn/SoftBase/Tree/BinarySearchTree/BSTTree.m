//
//  BSTTree.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "BSTTree.h"
#import "BSTNode.h"

@implementation BSTTree
{
    BSTNode *_root;
}

- (id)getValue:(NSString *)key
{
    BSTNode *node = [self getNodeWithKey:key node:_root];
    return node.value;
}

- (BSTNode *)getNodeWithKey:(NSString *)key node:(BSTNode *)node
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

- (void)putValue:(NSString *)key value:(id)value
{
    _root = [self putNodeWithKey:key value:value node:_root];
}

- (BSTNode *)putNodeWithKey:(NSString *)key value:(id)value node:(BSTNode *)node
{
    if (node == nil)
    {
        node = [[BSTNode alloc] init];
        node.key = key;
        node.value = value;
        node.number = 1;
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
    }
    return node;
}

- (NSInteger)count
{
    return _root.number;
}

- (void)log
{
    NSLog(@"count==%@", @([self count]));
    [self getMinValue];
    [self getMaxValue];
    [self middleLogWithNode:_root];
}

- (void)middleLogWithNode:(BSTNode *)node
{
    if (node == nil) return;
    [self middleLogWithNode:node.right];
    NSLog(@"====%@", node.key);
    [self middleLogWithNode:node.left];
}

- (id)getMinValue
{
    BSTNode *node = [self getMinNode:_root];
    NSLog(@"min==%@", node.key);
    return node.value;
}

- (BSTNode *)getMinNode:(BSTNode *)node
{
    if (node.left == nil) return node;
    return [self getMinNode:node.left];
}

- (id)getMaxValue
{
    BSTNode *node = [self getMaxNode:_root];
    NSLog(@"max==%@", node.key);
    return node.value;
}

- (BSTNode *)getMaxNode:(BSTNode *)node
{
    if (node.right == nil) return node;
    return [self getMaxNode:node.right];
}

- (void)delMin
{
    _root = [self delMinNode:_root];
}

- (BSTNode *)delMinNode:(BSTNode *)node
{
    if (node.left == nil) return node.right;
    
    node.left = [self delMinNode:node.left];
    node.number = node.left.number + node.right.number + 1;
    return node;
}

- (void)delKey:(NSString *)key
{
    NSLog(@"del=%@", key);
    _root = [self delKey:key node:_root];
}

- (BSTNode *)delKey:(NSString *)key node:(BSTNode *)node
{
    if (node == nil) return nil;
    NSComparisonResult res = [key compare:node.key];
    if (res == NSOrderedSame) // 等于
    {
        if (node.left == nil)
        {
            return node.right;
        } else if (node.right == nil)
        {
            return node.left;
        } else
        {
            BSTNode *t = node;
            node = [self getMinNode:t.right];
            node.right = [self delMinNode:t.right];
            node.left = t.left;
        }
    } else if (res == NSOrderedDescending) // 大于
    {
        node.right = [self delKey:key node:node.right];
    } else // 小于
    {
        node.left = [self delKey:key node:node.left];
    }
    
    node.number = node.left.number + node.right.number + 1;
    
    return node;
}

@end
