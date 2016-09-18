//
//  DrawView.m
//  LearnTest
//
//  Created by syq on 15/8/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
{
    int _changex;
    int _changey;
    
    int _flag;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    for (int i = 100; i > 17; i--)
    int i = 18;
    {
        NSString *action = [NSString stringWithFormat:@"test%@", @(i).stringValue];
        SEL sel = NSSelectorFromString(action);
        if ([self respondsToSelector:sel])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop
//            break;
        }
    }
}

- (void)test1
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 30.0);
    CGContextMoveToPoint(context, 50.0, 100.0);
    CGContextAddLineToPoint(context, 200.0, 100.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextStrokePath(context);
}

- (void)test2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 10.0);
    CGPoint addLines[] =
    {
        CGPointMake(10.0, 90.0),
        CGPointMake(40.0, 60.0),
        CGPointMake(70.0, 90.0),
        CGPointMake(100.0, 60.0),
    };
    CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextStrokePath(context);
}

- (void)test3
{
    //画多条线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGPoint addLines[] =
    {
        CGPointMake(10.0, 90.0),
        CGPointMake(70.0, 60.0),
        CGPointMake(130.0, 90.0),
        CGPointMake(190.0, 60.0),
    };
//    CGContextStrokeLineSegments(context, addLines, sizeof(addLines)/sizeof(CGPoint));
    CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(CGPoint));
    CGContextStrokePath(context);
}

- (void)test4
{
    /**
     这个函数设置虚线参数，第一个是画布，第二个是在开始画线时跳过多少个像素。第三个参数dashPattern是个数组，第四个参数dashCount是指取数组dashPattern中前多少个元素。假如说dashPattern［0］，dashPattern［1］，dashPattern［2］；分别为10，20,30，如果设置dashCount为3,则取这三个元素，那么线条是10像素的实线，20像素的虚线，30像素的实线，然后又是10像素的虚线，20像素的实线，30像素的虚线...如果dashCount为2,则只取前两个元素循环
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGFloat lengths[] = {10, 20, 30};
    CGContextSetLineDash(context, 1, lengths, 3);
    CGContextMoveToPoint(context, 10.0, 100.0);
    CGContextAddLineToPoint(context, 300.0, 100.0);
    CGContextStrokePath(context);
}

- (void)test5
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 10.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    
    //画一个矩形边框，这个方法使用的是默认的笔头宽度
    CGContextStrokeRectWithWidth(context, CGRectMake(30.0, 30.0, 120.0, 60.0), 5.0);
    
    //画一个以（30，30）为起点，长60,高60画一个矩形。这个矩形长高相等，就是正方形。这个函数没有实现画到画布上的过程。
//    CGContextAddRect(context, CGRectMake(30.0, 30.0, 60.0, 60.0));
//    CGContextStrokePath(context);
}

- (void)test6
{
    // 同时画多个长方形
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGRect rects[] =
    {
        CGRectMake(120.0, 30.0, 60.0, 60.0),
        CGRectMake(120.0, 120.0, 60.0, 60.0),
        CGRectMake(120.0, 210.0, 60.0, 60.0),
    };
    CGContextAddRects(context, rects, sizeof(rects)/sizeof(CGRect));
    CGContextStrokePath(context);
}

- (void)test7
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
   //画一个椭圆，内切于以（10，10）为起点，长宽为60的矩形，就是内切于正方形，画出来的就是圆。
    CGContextAddEllipseInRect(context, CGRectMake(10.0, 10.0, 60.0, 60.0));
    CGContextStrokePath(context);
    //直接画一个圆框到画布上
//    CGContextStrokeEllipseInRect(context, CGRectMake(80.0, 10.0, 60.0, 60.0));
    //直接画一个实心圆，就是填充了颜色的圆到画布上。
//    CGContextFillEllipseInRect(context, CGRectMake(10.0, 80.0, 60.0, 60.0));
}

- (void)test8
{
    /**
     这个方法不会直接画到画布上，这个方法是以（150，60）为圆心，30为半径，开始弧度为0,结束弧度为2PI画圆，画弧也可以用这个方法。最后一个参数 0为顺时针，1为逆时针
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0, 1, 1, 1);
    CGContextSetLineWidth(context, 2.0);
    CGContextAddArc(context, 150.0, 60.0, 30.0, 0.0, M_PI * 2.0, false);
    CGContextStrokePath(context);
}

- (void)test9
{
    /**
     理大概是先把笔头移到210，30，然后画两条切线，点（210，30）和点（210，60）画一条，点（210，60）和（240，60）画一条。然后根据半径确定圆心，然后画弧，根据点的坐标，弧的方向基本可以确定。这个方法只能画90度的圆弧，其他角度的圆弧没法画成。如果画不成圆弧，当然也就没有圆心这个说法。
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0, 1, 1, 1);
    CGContextSetLineWidth(context, 2.0);
    CGPoint p[3] =
    {
        CGPointMake(210.0, 30.0),
        CGPointMake(210.0, 60.0),
        CGPointMake(240.0, 60.0),
    };
    // 切线1
    CGContextMoveToPoint(context, p[0].x, p[0].y);
    CGContextAddLineToPoint(context, p[1].x, p[1].y);
    CGContextStrokePath(context);
    // 切线2
    CGContextSetRGBStrokeColor(context, 1, 0, 1, 1);
    CGContextMoveToPoint(context, p[1].x, p[1].y);
    CGContextAddLineToPoint(context, p[2].x, p[2].y);
    CGContextStrokePath(context);
    // 圆弧
    CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
    CGContextMoveToPoint(context, p[0].x, p[0].y);
    CGContextAddArcToPoint(context, p[1].x, p[1].y, p[2].x, p[2].y, 30.0);
    CGContextStrokePath(context);
}

- (void)test10
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGFloat radius = 10.0;
    CGRect rrect = CGRectMake(210.0, 90.0, 60.0, 60.0);
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    NSLog(@"x=%f  %f  %f", minx, midx, maxx);
    NSLog(@"y=%f  %f  %f", miny, midy, maxy);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)test11
{
    // 三次曲线函数
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGPoint s = CGPointMake(30.0 + _changex, 120.0 + _changey);
    CGPoint e = CGPointMake(300.0, 120.0);
    CGPoint cp1 = CGPointMake(120.0, 30.0);
    CGPoint cp2 = CGPointMake(210.0, 210.0);
    CGContextMoveToPoint(context, s.x, s.y);
    CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 1.0, 0, 1.0, 1.0);
    CGContextMoveToPoint(context, s.x, s.y);
    CGContextAddLineToPoint(context, cp1.x, cp1.y);
    
    CGContextMoveToPoint(context, e.x, e.y);
    CGContextAddLineToPoint(context, cp2.x, cp2.y);
    CGContextStrokePath(context);
}



- (void)test12
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGPoint s = CGPointMake(30.0, 120.0);
    CGPoint e = CGPointMake(300.0, 120.0);
    CGPoint cp1 = CGPointMake(_changex, _changey);
    CGContextMoveToPoint(context, s.x, s.y);
    CGContextAddQuadCurveToPoint(context, cp1.x, cp1.y, e.x, e.y);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 1.0, 1.0);
    CGContextMoveToPoint(context, s.x, s.y);
    CGContextAddLineToPoint(context, cp1.x, cp1.y);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 0.0, 1.0);
    CGContextMoveToPoint(context, e.x, e.y);
    CGContextAddLineToPoint(context, cp1.x, cp1.y);
    CGContextStrokePath(context);
}

- (void)test13
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGPoint center = CGPointMake(_changex, _changey);
    CGContextMoveToPoint(context, center.x, center.y + 60.0);
    float num = 5;
    for (int i = 1; i < num; ++i)
    {
        CGFloat x = 60.0 *sinf(4 * i * M_PI / num);
        CGFloat y = 60.0 *cosf(4 * i * M_PI / num);
        CGContextAddLineToPoint(context, center.x + x, center.y + y);
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)test14
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    image = CGImageRetain(img.CGImage);
    CGRect imageRect = CGRectMake(8.0, 8.0, 64.0, 64.0);
    CGContextTranslateCTM(context, 0.0,  imageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, imageRect, image);
}

- (void)test15
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef image;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    image = CGImageRetain(img.CGImage);
    CGRect imageRect = CGRectMake(8.0, 8.0, 64.0, 64.0);
    
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextClipToRect(context, CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height));//设置平铺区域的大小
    CGContextDrawTiledImage(context, imageRect, image); //以平铺的方式绘制
    
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, imageRect);
}

- (void)test16
{
    // 颜色渐变
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        204.0/255.0, 224.0/255.0, 244.0/255.0, 1.00,
        29.0 /255.0, 156.0/255.0, 215.0/255.0, 1.00,
        0.0  /255.0, 50.0 /255.0, 126.0/255.0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0]) * 4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, self.bounds.size.height), kCGGradientDrawsBeforeStartLocation);
}

//- (void)test17
//{
//    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 100.0)];
//    view.backgroundColor = [UIColor blueColor];
//    view.text = @"好大一棵树";
//    CGSize s = view.bounds.size;
//    
//    //第一个参数表示区域大小; 第二个参数表示是否是非透明的,如果需要显示半透明效果,需要传NO,否则传YES; 第三个参数是屏幕密度
//    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [view.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    context = UIGraphicsGetCurrentContext();
////    CGContextTranslateCTM(context, 0.0, s.height);
////    CGContextScaleCTM(context, 1.0, -1.0);
//    CGImageRef imageRef = CGImageRetain(image.CGImage);
//    CGContextDrawImage(context, view.frame, imageRef);
//}


- (void)test18
{
    CGRect rect = CGRectMake(_changex, _changey, 60, 60);
    
    CGFloat width  = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetShouldAntialias(context, YES);// 抗锯齿
    CGContextSetAllowsAntialiasing(context, YES);
//    CGContextTranslateCTM(context, minX, minY);
    CGContextAddEllipseInRect(context, CGRectMake(minX, minY, 2 * (width), 2 * (height)));
    CGContextAddRect(context, CGRectMake(minX, minY, 2 * ( width), 2 * (  height)));
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddEllipseInRect(context, rect);
    CGContextAddRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddEllipseInRect(context, rect);
    CGContextAddRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextAddEllipseInRect(context, rect);
    CGContextAddRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddEllipseInRect(context, rect);
    CGContextAddRect(context, rect);
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddEllipseInRect(context, rect);
    CGContextAddRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextStrokePath(context);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point  = [touch locationInView:self];
    _changex = point.x;
    _changey = point.y;
    [self setNeedsDisplay];
}


@end
