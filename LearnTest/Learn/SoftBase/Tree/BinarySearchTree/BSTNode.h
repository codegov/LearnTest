//
//  BSTNode.h
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTNode : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic) NSInteger number;

@property (nonatomic, strong) BSTNode *left;
@property (nonatomic, strong) BSTNode *right;

@end
