//
//  Linearlist.m
//  LearnTest
//
//  Created by syq on 14/11/4.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "Linearlist.h"

@interface Linearlist ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) int len;

@end

@implementation Linearlist

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setNull // 将线性表置成空表
{
    _len = 0;
}

- (int)length// 求给定线性表的长度
{
    return _len;
}

- (id)get:(int)i // 取线性表第i个位置上的元素
{
    if (i <= _len && _len > 0) {
        return [_dataArray objectAtIndex:i];
    }
    return nil;
}

- (id)prior:(id)x//求线性表中元素值为x的直接前趋
{
    id value = nil;
    for (int i = 1; i <= _len; i++) {
        if ([_dataArray objectAtIndex:i] == x) {
            break;
        }
        value = [_dataArray objectAtIndex:i];
    }
    return value;
}

- (id)next:(id)x //求线性表中元素值为x的直接后趋
{
    id value = nil;
    for (int i = 1; i <= _len; i++) {
        if ([_dataArray objectAtIndex:i] == x) {
            if (i < _len) {
                value = [_dataArray objectAtIndex:(i + 1)];
            }
            break;
        }
    }
    return value;
}

- (int)locate:(id)x//求线性表中查找值为x的元素位置
{
    int value = 0;
    for (int i = 1; i <= _len; i++) {
        if ([_dataArray objectAtIndex:i] == x) {
            value = i;
            break;
        }
    }
    return value;
}

- (void)insert:(id)x i:(int)i//在线性表中第i个位置上插入值为x的元素
{
    if (i > 0 && i <= _len && x) {
        for (int j = _len; j >= i; j--) {
            id value = [_dataArray objectAtIndex:j];
            [_dataArray insertObject:value atIndex:(j + 1)];
        }
        [_dataArray insertObject:x atIndex:i];
        _len ++;
    }
}

- (void)delete:(int)i//删除线性表中第i个位置上的元素
{
    if (i > 0 && i <= _len) {
        for (int j = i + 1; j <= _len; j++) {
            id value = [_dataArray objectAtIndex:j];
            [_dataArray insertObject:value atIndex:(j - 1)];
        }
        _len --;
    }
}

@end
