//
//  Bloom.h
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bloom : NSObject

- (id)initWithSize:(int)s hashfunclist:(NSArray *)h;

- (void)add:(const char *)text;
- (BOOL)check:(const char *)text;

@end
