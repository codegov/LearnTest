//
//  BST2And3Tree.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "BST2And3Tree.h"

@implementation BST2And3Tree
{
    BST2And3Node *_rootNode;
}

- (BOOL)addNodeWithKey:(NSString *)key value:(id)value
{
    _rootNode = [self addNodeWithKey:key value:value node:_rootNode];
    return YES;
}

- (BST2And3Node *)addNodeWithKey:(NSString *)key value:(id)value node:(BST2And3Node *)node
{
    if (node == nil)
    {
        node = [[BST2And3Node alloc] init];
        node.minKey   = key;
        node.minValue = value;
    } else if ([node is2Node])
    {
        NSComparisonResult res = [key compare:_rootNode.minKey];
        if (res == NSOrderedSame) // 等于
        {
            node.minValue = value;
        } else if (res == NSOrderedDescending) // 大于
        {
            node.maxKey   = key;
            node.maxValue = value;
        } else // 小于
        {
            NSString *tempKey  = node.minKey;
            id tempValue       = node.minValue;
            node.minKey   = key;
            node.minValue = value;
            
            node.maxKey   = tempKey;
            node.maxValue = tempValue;
        }
    } else if ([node is3Node])
    {
        
    }
    return node;
}

- (BOOL)removeNodeWithKey:(NSString *)key
{
    
    return YES;
}

- (BST2And3Node *)queryNodeWithKey:(NSString *)key
{
    return [self queryNodeWithKey:key node:_rootNode];
}

- (BST2And3Node *)queryNodeWithKey:(NSString *)key node:(BST2And3Node *)node
{
    if (node == nil) return nil;
    
    if ([node is2Node])
    {
        NSComparisonResult res = [key compare:node.minKey];
        if (res == NSOrderedSame) // 等于
        {
            return node;
        } else if (res == NSOrderedDescending) // 大于
        {
            return [self queryNodeWithKey:key node:node.rightNode];
        } else // 小于
        {
            return [self queryNodeWithKey:key node:node.leftNode];
        }
    } else if ([node is3Node])
    {
        NSComparisonResult res = [key compare:node.minKey];
        if (res == NSOrderedSame) // 等于
        {
            return node;
        } else if (res == NSOrderedDescending) // 大于
        {
            res = [key compare:node.maxKey];
            if (res == NSOrderedSame)
            {
                return node;
            } else if (res == NSOrderedDescending)
            {
                return [self queryNodeWithKey:key node:node.rightNode];
            } else
            {
                return [self queryNodeWithKey:key node:node.middleNode];
            }
        } else // 小于
        {
            return [self queryNodeWithKey:key node:node.leftNode];
        }
    }
    return nil;
}

@end
