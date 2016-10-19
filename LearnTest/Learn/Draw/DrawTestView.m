//
//  DrawTestView.m
//  LearnTest
//
//  Created by javalong on 16/10/13.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "DrawTestView.h"
#import "DrawTestSubView.h"

@implementation DrawTestView
{
    NSInteger _index;
    double _index2;
    BOOL isAdd;
    CADisplayLink *_displayLink;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(doAction:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)doAction:(CADisplayLink *)sender
{
    NSLog(@"doaction");
    _index += 2;
    if (_index2 >= 5)
    {
        isAdd = YES;
    } else if (_index2 <= -5)
    {
        isAdd = NO;
    }
    isAdd ? (_index2 -= 0.1) : (_index2 += 0.1);
    _displayLink.paused = YES;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];

    CGContextRef gc = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] setFill];
    CGFloat cenx = CGRectGetMidX(self.bounds);
    CGFloat ceny = CGRectGetMidY(self.bounds);
    CGContextTranslateCTM(gc, cenx, ceny);
    //不断绘图并设置旋转
    CGContextRotateCTM(gc, _index * M_PI/180);
    for(int i = 0; i < 12; i++)
    {
//        CGContextAddRect(gc, CGRectMake(-5, 0, 10, 100));
        CGRect tRect = CGRectMake(-5, 50, 10, 50);
        CGContextAddRect(gc, tRect);
        CGContextFillPath(gc);
        CGContextRotateCTM(gc, 30 * M_PI/180);
    }
    CGRect tRect = CGRectMake(0, 0, 50, 100);
    UIBezierPath* path = [UIBezierPath bezierPath];
    [[UIColor blueColor] setFill];
    [path moveToPoint:CGPointMake(CGRectGetMinX(tRect), CGRectGetMinY(tRect))];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMinX(tRect), CGRectGetMaxY(tRect)) controlPoint:CGPointMake(CGRectGetMidX(tRect) * _index2, CGRectGetMidY(tRect))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(tRect), CGRectGetMaxY(tRect))];
    [path addQuadCurveToPoint:CGPointMake(CGRectGetMaxX(tRect), CGRectGetMinY(tRect)) controlPoint:CGPointMake(CGRectGetMidX(tRect) * _index2 + CGRectGetMaxX(tRect), CGRectGetMidY(tRect))];
    [path closePath];
    [path fill];
    _displayLink.paused = NO;
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    if (_index == 0)
//    {
//        DrawTestSubView *subView = [[DrawTestSubView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
//        subView.backgroundColor = [UIColor redColor];
//        [subView.layer renderInContext:context];
//    } else
//    {
//        DrawTestSubView *subView = [[DrawTestSubView alloc] initWithFrame:CGRectMake(10, 50, 40, 40)];
//        subView.backgroundColor = [UIColor blueColor];
//        [subView.layer renderInContext:context];
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _index ++;
    NSLog(@"touchesEnded==%@", @(_index));
    [self setNeedsDisplay];
}


@end
