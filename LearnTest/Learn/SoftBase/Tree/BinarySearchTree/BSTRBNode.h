//
//  BSTRBNode.h
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTRBNode : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic) NSInteger number;
@property (nonatomic) BOOL isRed;

@property (nonatomic, strong) BSTRBNode *left;
@property (nonatomic, strong) BSTRBNode *right;


@end
