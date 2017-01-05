//
//  DrawViewCoreGraphics.m
//  LearnTest
//
//  Created by javalong on 2016/12/21.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "DrawViewCoreGraphics.h"

@implementation DrawViewCoreGraphics
{
    CGContextRef context;
    
    UIBezierPath *_path;
    NSMutableArray *touchPoints;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        CAShapeLayer *layer = (CAShapeLayer *)(self.layer);
        layer.lineWidth = 5;
        layer.lineCap = @"round";
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor   = [UIColor clearColor].CGColor;
        _path = [UIBezierPath bezierPath];
        touchPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *layer = (CAShapeLayer *)(self.layer);
        layer.lineWidth = 5;
        layer.lineCap = @"round";
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.fillColor   = [UIColor clearColor].CGColor;
        _path = [UIBezierPath bezierPath];
        touchPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    context = UIGraphicsGetCurrentContext();
    
    [self drawImage];
    [self drawCircle];
    [self drawCircleFill];
    [self drawLine];
    [self drawARC];
    [self drawRects];
    [self drawBezierPath];
    [self drawTouchPoints];
}

- (void)drawImage
{
    UIImage *image = [UIImage imageNamed:@"image"];
    float width  = image.size.width/2.0;
    float height = image.size.height/2.0;
    // 1、使用这个使图片上下颠倒了，参考http://blog.csdn.net/koupoo/article/details/8670024
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
//    // 2、平铺图 使图片上下颠倒了
//    CGContextDrawTiledImage(context, CGRectMake(width, height, width, height), image.CGImage);
    // 3、在坐标中画出图片 图片不颠倒
    [image drawInRect:CGRectMake(width, 0, width, height)];
    // 4、保持图片大小在point点开始画图片 图片不颠倒
    [image drawAtPoint:CGPointMake(0, height)];
}

- (void)drawCircle
{
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1); // 填充颜色
    CGContextSetLineWidth(context, 2.5);
    CGContextAddArc(context, 20, 20, 15, 0, 2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawCircleFill
{
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddArc(context, 60, 20, 17.5, 0, 2 *M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawLine
{
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGPoint points[2];
    points[0] = CGPointMake(100, 20);
    points[1] = CGPointMake(130, 20);
    CGContextAddLines(context, points, 2);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawARC // 绘制圆弧
{
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    // 即从三个点绘制圆弧：(20,60)->(30,50)->(40,60)
    // 半径为20.
    CGPoint points[3] = {CGPointMake(20, 60), CGPointMake(30, 50), CGPointMake(40, 60)};
    CGContextMoveToPoint(context, points[0].x, points[0].y); // 设置开始坐标点
    CGContextAddArcToPoint(context, points[1].x, points[1].y, points[2].x, points[2].y, 20);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 60, 60);
    CGContextAddArcToPoint(context, 70, 50, 80, 60, 20);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 30, 80);
    CGContextAddArcToPoint(context, 50, 90, 70, 80, 40);
    CGContextStrokePath(context);
}

- (void)drawRects
{
    // 1、画方框
    CGContextStrokeRect(context, CGRectMake(100, 120, 10, 10));
    
    // 2、填充框
    CGContextFillRect(context, CGRectMake(120, 120, 10, 10));
    
    // 3、矩形，并填弃颜色
    CGContextSetLineWidth(context, 2);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextAddRect(context, CGRectMake(140, 120, 60, 30));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //4、矩形，并填弃渐变颜色
    //关于颜色参考http://blog.sina.com.cn/s/blog_6ec3c9ce01015v3c.html
    //http://blog.csdn.net/reylen/article/details/8622932
    //第一种填充方式，第一种方式必须导入类库quartcore并#import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(210, 120, 60, 30);
    gradient.colors = @[(id)[UIColor whiteColor].CGColor,
                        (id)[UIColor grayColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor brownColor].CGColor
                        ];
    [self.layer insertSublayer:gradient atIndex:0];
    
    //5、第二种填充方式
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        1,1,1, 1.00,
        1,1,0, 1.00,
        1,0,0, 1.00,
        1,0,1, 1.00,
        0,1,1, 1.00,
        0,1,0, 1.00,
        0,0,1, 1.00,
        1,0,0, 1.00,
    };
    size_t count = sizeof(colors)/(sizeof(colors[0])*4);
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(rgb, colors, NULL, count);
    CGColorSpaceRelease(rgb);
    //CGContextSaveGState与CGContextRestoreGState的作用
    /*
     CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
     */
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 210, 80);
    CGContextAddLineToPoint(context, 270, 80);
    CGContextAddLineToPoint(context, 270, 110);
    CGContextAddLineToPoint(context, 210, 110);
    CGContextClip(context);//context裁剪路径,后续操作的路径
    //gradient渐变颜色,Point1开始渐变的起始位置,Point2结束坐标,options开始坐标之前or开始之后开始渐变
    CGContextDrawLinearGradient(context, gradientRef,CGPointMake(210,80) ,CGPointMake(270,110),kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);// 恢复到之前的context
    
    //6、再写一个看看效果
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 210, 20);
    CGContextAddLineToPoint(context, 270, 20);
    CGContextAddLineToPoint(context, 270, 50);
    CGContextAddLineToPoint(context, 210, 50);
    CGContextClip(context);//裁剪路径
    //说白了，开始坐标和结束坐标是控制渐变的方向和形状
    CGContextDrawLinearGradient(context, gradientRef,CGPointMake(210, 20) ,CGPointMake(210, 50),kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);// 恢复到之前的context
    
    //7、下面再看一个颜色渐变的圆
    CGContextDrawRadialGradient(context, gradientRef, CGPointMake(100, 100), 0.0, CGPointMake(100, 100), 10, kCGGradientDrawsBeforeStartLocation);
    
    //8、画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);//填充颜色
    //以10为半径围绕圆心画指定角度扇形
    CGContextMoveToPoint(context, 160, 190);
    CGContextAddArc(context, 160, 190, 30,  -60 * M_PI / 180, -120 * M_PI / 180, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    
    //9、画椭圆
    CGContextAddEllipseInRect(context, CGRectMake(190, 160, 30, 15)); //椭圆
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //10、画三角形
    //只要三个点就行跟画一条线方式一样，把三点连接起来
    CGPoint sPoints[3] = {CGPointMake(100, 220),CGPointMake(130, 220),CGPointMake(130, 160)};//坐标点
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    //11、画圆角矩形
    float fw = 180;
    float fh = 280;
    CGContextMoveToPoint(context, fw, fh-20);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, fw, fh, fw-20, fh, 10);  // 右下角角度
    CGContextAddArcToPoint(context, 120, fh, 120, fh-20, 10); // 左下角角度
    CGContextAddArcToPoint(context, 120, 250, fw-20, 250, 10); // 左上角
    CGContextAddArcToPoint(context, fw, 250, fw, fh-20, 10); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    /*画贝塞尔曲线*/
    //12、二次曲线
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextMoveToPoint(context, 120, 60);//设置Path的起点
    CGContextAddQuadCurveToPoint(context,190, 110, 120, 200);//设置贝塞尔曲线的控制点坐标和终点坐标
    CGContextStrokePath(context);
    //13、三次曲线函数
    CGContextMoveToPoint(context, 10, 100);//设置Path的起点
    CGContextAddCurveToPoint(context, 100, 50, 200, 200, 300, 100);//设置贝塞尔曲线的控制点坐标和控制点坐标终点坐标
    CGContextStrokePath(context);
}

- (void)drawBezierPath
{
    UIColor *color = [UIColor blueColor];
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;   //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    //设置起始点
    [aPath moveToPoint:CGPointMake(100.0, 0.0)];
    
    //创建line, line的起点是之前的一个点, 终点即指定的点.
    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];
    [aPath addLineToPoint:CGPointMake(160.0, 140.0)];
    [aPath addLineToPoint:CGPointMake(40.0, 140.0)];
    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];
    //第五条线通过调用closePath方法得到的, 连接起始点与终点.
    [aPath closePath];
    
    [aPath stroke]; //绘制图形
    //    [aPath fill]; //填充图形
    
    //绘制矩形
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRect:CGRectMake(10, 10, 100, 100)];
    bPath.lineWidth = 2.0;
    aPath.lineCapStyle = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineCapRound;
    [bPath stroke];
    
    //绘制圆形
    UIBezierPath *cPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 10, 100, 100)];
    cPath.lineWidth = 2.0;
    cPath.lineCapStyle = kCGLineCapRound;
    cPath.lineJoinStyle = kCGLineCapRound;
    [cPath stroke];
    
    //绘制一段弧线
    UIBezierPath *dPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 100) radius:75 startAngle:0 endAngle:(135 *M_PI)/180 clockwise:YES];
    dPath.lineWidth = 2.0;
    dPath.lineCapStyle = kCGLineCapRound;
    dPath.lineJoinStyle = kCGLineCapRound;
    [dPath stroke];
    
    [[UIColor blueColor] set];
    
    //二次曲线
    UIBezierPath *ePath = [UIBezierPath bezierPath];
    ePath.lineWidth = 2.0;
    ePath.lineCapStyle = kCGLineCapRound;
    ePath.lineJoinStyle = kCGLineCapRound;
    [ePath moveToPoint:CGPointMake(20, 100)];
    [ePath addQuadCurveToPoint:CGPointMake(120, 100) controlPoint:CGPointMake(70, 0)];
    [ePath stroke];
    
    //三次曲线
    UIBezierPath *fPath = [UIBezierPath bezierPath];
    fPath.lineWidth = 2.0;
    fPath.lineCapStyle = kCGLineCapRound;
    fPath.lineJoinStyle = kCGLineCapRound;
    [fPath moveToPoint:CGPointMake(100, 100)];
    [fPath addCurveToPoint:CGPointMake(300, 100) controlPoint1:CGPointMake(150, 50) controlPoint2:CGPointMake(250, 150)];
    [fPath stroke];
}

- (void)drawTouchPoints
{
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetLineWidth(context, 10);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGPoint preP = [touchPoints.firstObject CGPointValue];
    for (id rawPoint in touchPoints)
    {
        CGPoint p = [rawPoint CGPointValue];
        CGContextMoveToPoint(context, preP.x, preP.y);
        CGContextAddLineToPoint(context, p.x, p.y);
        CGContextStrokePath(context);
        preP = p;
    }
//    [_path stroke];
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        // 获取该touch的point
        CGPoint p = [t locationInView:self];
        [touchPoints addObject:[NSValue valueWithCGPoint:p]];
        [_path moveToPoint:p];
        [_path addLineToPoint:p];
        [self dealPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint p = [t locationInView:self];
        [touchPoints addObject:[NSValue valueWithCGPoint:p]];
        [_path addLineToPoint:p];
        [self dealPoint];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dealPoint];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dealPoint];
}


- (void)dealPoint
{
    ((CAShapeLayer *)self.layer).path = _path.CGPath;
//    [self setNeedsDisplay];
}

@end
