//
//  BST2And3Node.h
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BST2And3Node : NSObject

@property (nonatomic, strong) NSString *minKey;
@property (nonatomic, strong) id minValue;

@property (nonatomic, strong) NSString *maxKey;
@property (nonatomic, strong) id maxValue;

@property (nonatomic, strong) BST2And3Node *leftNode;
@property (nonatomic, strong) BST2And3Node *middleNode;
@property (nonatomic, strong) BST2And3Node *rightNode;

- (BOOL)is2Node;
- (BOOL)is3Node;

@end
