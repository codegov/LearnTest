//
//  BSTRBTree.h
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTRBTree : NSObject

- (id)getValue:(NSString *)key;
- (void)putValue:(NSString *)key value:(id)value;
- (void)delKey:(NSString *)key;

- (void)log;

@end
