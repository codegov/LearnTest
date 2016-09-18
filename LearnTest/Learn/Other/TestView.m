//
//  TestView.m
//  LearnTest
//
//  Created by syq on 14/11/10.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestView.h"

@implementation TestView


- (void)layoutSubviews
{
    [super layoutSubviews];

    
    // UILabel设置text时会调用needsLayoutSubviews
//    self.text = [NSString stringWithFormat:@"%@9", self.text];// 导致死循环
//    self.text = [NSString stringWithFormat:@"%@9", @"---"];   // 重复绘制两遍, 在第二次绘制时发现text没变化，跳过绘制方法而已
}

@end
