//
//  TreeView.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "TreeView.h"

@implementation TreeView


- (void)setTree:(BSTTree *)tree
{
    _tree = tree;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}


@end
