//
//  DrawCAShapeLayer.m
//  LearnTest
//
//  Created by javalong on 16/5/13.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "DrawCAShapeLayer.h"

@interface DrawCAShapeLayer ()

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIColor *maskLayerColor;
@property (nonatomic, strong) UIBezierPath *maskPath;

@end

@implementation DrawCAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.backgroundColor = [UIColor redColor].CGColor;
        float width = 200;
        CGRect rect = CGRectMake(frame.size.width/2.0 - width/2, frame.size.height/2.0 - width/2, width, width);
        width = 100;
        CGRect rect0 = CGRectMake(frame.size.width/2.0 - width/2, frame.size.height/2.0 - width/2, width, width);
        UIBezierPath *p0 = [UIBezierPath bezierPathWithOvalInRect:rect0];
        UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:rect];
        [p appendPath:p0];
        UIBezierPath *p1 = [UIBezierPath bezierPathWithRect:rect];
        [p1 appendPath:p];
        self.maskPath = p1;
        [self.layer addSublayer:self.maskLayer];
    }
    return self;
}

- (void)setMaskPath:(UIBezierPath *)maskPath
{
    if (![_maskPath isEqual:maskPath]) {
        _maskPath = maskPath;
        
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.frame];
        [clipPath appendPath:maskPath];
        clipPath.usesEvenOddFillRule = YES;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = [CATransaction animationDuration];
        pathAnimation.timingFunction = [CATransaction animationTimingFunction];
        [self.maskLayer addAnimation:pathAnimation forKey:@"path"];
        
        self.maskLayer.path = [clipPath CGPath];
    }
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.fillColor = self.maskLayerColor.CGColor;
    }
    return _maskLayer;
}

- (UIColor *)maskLayerColor
{
    if (!_maskLayerColor) {
        _maskLayerColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
    }
    return _maskLayerColor;
}

@end
