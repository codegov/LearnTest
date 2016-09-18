//
//  Linearlist.h
//  LearnTest
//
//  Created by syq on 14/11/4.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Linearlist : NSObject

- (void)setNull; // 将线性表置成空表
- (int)length; // 求给定线性表的长度
- (id)get:(int)i; // 取线性表第i个位置上的元素
- (id)prior:(id)x;//求线性表中元素值为x的直接前趋
- (id)next:(id)x; //求线性表中元素值为x的直接后趋
- (int)locate:(id)x;//求线性表中查找值为x的元素位置
- (void)insert:(id)x i:(int)i;//在线性表中第i个位置上插入值为x的元素
- (void)delete:(int)i;//删除线性表中第i个位置上的元素

@end
