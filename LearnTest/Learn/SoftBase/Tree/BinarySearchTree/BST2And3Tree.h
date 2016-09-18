//
//  BST2And3Tree.h
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BST2And3Node.h"

@interface BST2And3Tree : NSObject

- (BOOL)addNodeWithKey:(NSString *)key value:(id)value;
- (BOOL)removeNodeWithKey:(NSString *)key;
- (BST2And3Node *)queryNodeWithKey:(NSString *)key;

@end
