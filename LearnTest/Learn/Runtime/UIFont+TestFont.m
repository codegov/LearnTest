//
//  UIFont+TestFont.m
//  LearnTest
//
//  Created by javalong on 16/4/12.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "UIFont+TestFont.h"

@implementation UIFont (TestFont)

+ (UIFont *)testFont
{
    UIFont *font = [[UIFont alloc] init];
    return font;
}

+ (CGFloat)labelFontSize
{
    return 10;
}

+ (CGFloat)buttonFontSize
{
    return 10;
}
+ (CGFloat)smallSystemFontSize
{
    return 10;
}
+ (CGFloat)systemFontSize
{
    return 10;
}



@end
