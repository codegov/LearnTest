//
//  TestCoreAnimation1ViewController.m
//  LearnTest
//
//  Created by syq on 14/11/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestCoreAnimation1ViewController.h"

@interface TestCoreAnimation : NSObject
{
    NSString *name;
}

@property (nonatomic, strong) NSString *test;

@end

@implementation TestCoreAnimation



@end

@interface TestCoreAnimation1ViewController ()
{
    CALayer *theLayer;
}
@end

@implementation TestCoreAnimation1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    
    theLayer = [[CALayer alloc] init];
    theLayer.backgroundColor = [UIColor brownColor].CGColor;
    theLayer.bounds = view.bounds;
    theLayer.position = view.center;
    [view.layer addSublayer:theLayer];
    
    self.tableView.tableHeaderView = view;
    
    
    
    [self doCoreAnimation];
    [self doCoreAnimation1];
    [self performSelector:@selector(doCoreAnimation6) withObject:nil afterDelay:2];
}

- (void)doCoreAnimation
{
    [self.view.layer setValue:@"layerTest" forKey:@"test"];  // CALayer支持键值对
    NSString *value2 = [self.view.layer valueForKey:@"test"];
    [self updateUI:value2];
    
    TestCoreAnimation *test = [[TestCoreAnimation alloc] init];
    [test setValue:@"textCoreAnimation" forKey:@"test"]; // 相当于给test对象的test变量赋值
    test.test = @"==";
    [test setValue:@"namw" forKey:@"name"]; // 相当于给test对象的name变量赋值
    [self updateUI:[test valueForKey:@"test"]];
    [self updateUI:[test valueForKey:@"name"]];
}

- (void)doCoreAnimation1
{
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration = 3.0;
    theAnimation.repeatCount = 2;
    theAnimation.autoreverses = YES; // 当你设定这个属性为 YES 时,在它到达目的地之后,动画的返回到开始的值,代替了直接跳转到 开始的值。
    theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    theAnimation.toValue = [NSNumber numberWithFloat:0.0];
    [theLayer addAnimation:theAnimation forKey:@"animateOpacity"];
}

- (void)doCoreAnimation2
{
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];

    [filter setDefaults];

    [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];

    // name the filter so we can use the keypath to animate the inputIntensity
    // attribute of the filter

//    [filter setName:@"pulseFilter"];
    
    // set the filter to the selection layer's filters
    
    [theLayer setFilters:[NSArray arrayWithObject:filter]];
    
    
    // create the animation that will handle the pulsing.
    
    CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
    
    // the attribute we want to animate is the inputIntensity
    
    // of the pulseFilter
    
    pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
    
   
    // we want it to animate from the value 0 to 1

    pulseAnimation.fromValue = [NSNumber numberWithFloat: 1.0];
    
    pulseAnimation.toValue = [NSNumber numberWithFloat: 0.0];
    
    
    // over a one second duration, and run an infinite
    
    // number of times
    
    pulseAnimation.duration = 3.0;
    
    pulseAnimation.repeatCount = 2;
    
    
    // we want it to fade on, and fade off, so it needs to
    
    // automatically autoreverse.. this causes the intensity
    
    // input to go from 0 to 1 to 0
    
    pulseAnimation.autoreverses = YES;
    
    
    // use a timing curve of easy in, easy out..
    
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    
    
    // add the animation to the selection layer. This causes
    
    // it to begin animating. We'll use pulseAnimation as the
    
    // animation key name
    [theLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
}

// 重载隐式动画的时间
- (void)doCoreAnimation3
{
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:10.0] forKey:kCATransactionAnimationDuration];
    theLayer.zPosition = 200.0;
    theLayer.opacity = 0.5;
    [CATransaction commit];
}

// 暂时禁用图层的行为
- (void)doCoreAnimation4
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
    [theLayer removeFromSuperlayer];
    [CATransaction commit];
}

- (void)doCoreAnimation5
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom" keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", @0.8, nil];//CIBloom CISepiaTone
    CIImage *outputImage = [filter outputImage];
    UIImage *newImage = [UIImage imageWithCIImage:outputImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    imageView.image = newImage;
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.tableHeaderView = imageView;
    
    [self logAllFilters];
}

// 复杂的滤镜链
- (void)doCoreAnimation6
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    CIImage *img = [CIImage imageWithContentsOfURL:fileNameAndPath];
    float intensity = 0.8;
    
    // 1
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
    [sepia setValue:img forKey:kCIInputImageKey];
    [sepia setValue:@(intensity) forKey:@"inputIntensity"];
    // 2
    CIFilter *random = [CIFilter filterWithName:@"CIRandomGenerator"];
    // 3
    CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
    [lighten setValue:random.outputImage forKey:kCIInputImageKey];
    [lighten setValue:@(1 - intensity) forKey:@"inputBrightness"];
    [lighten setValue:@0.0 forKey:@"inputSaturation"];
    // 4
    CIImage *croppedImage = [lighten.outputImage imageByCroppingToRect:[img extent]];

    UIImage *newImage = [UIImage imageWithCIImage:croppedImage];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
    imageView.image = newImage;
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.tableView.tableHeaderView = imageView;
    
    [self logAllFilters];
}

// 打印可用的滤镜
-(void)logAllFilters
{
    NSArray *properties = [CIFilter filterNamesInCategory: kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties)
    {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
    
    /**
     CIAccordionFoldTransition,
     CIAdditionCompositing,//影像合成
     CIAffineClamp,
     CIAffineTile,
     CIAffineTransform,//仿射变换
     CIAreaHistogram,
     CIAztecCodeGenerator,
     CIBarsSwipeTransition,
     CIBlendWithAlphaMask,
     CIBlendWithMask,
     CIBloom,
     CIBumpDistortion,
     CIBumpDistortionLinear,
     CICheckerboardGenerator,//棋盘发生器
     CICircleSplashDistortion,
     CICircularScreen,
     CICode128BarcodeGenerator,
     CIColorBlendMode,//CIColor混合模式
     CIColorBurnBlendMode,//CIColor燃烧混合模式
     CIColorClamp,
     CIColorControls,
     CIColorCrossPolynomial,
     CIColorCube,//立方体
     CIColorCubeWithColorSpace,
     CIColorDodgeBlendMode,//CIColor避免混合模式
     CIColorInvert,//CIColor反相
     CIColorMap,
     CIColorMatrix,//CIColor矩阵
     CIColorMonochrome,//黑白照
     CIColorPolynomial,
     CIColorPosterize,
     CIConstantColorGenerator,//恒定颜色发生器
     CIConvolution3X3,
     CIConvolution5X5,
     CIConvolution9Horizontal,
     CIConvolution9Vertical,
     CICopyMachineTransition,
     CICrop,//裁剪
     CIDarkenBlendMode,
     CIDifferenceBlendMode,
     CIDisintegrateWithMaskTransition,
     CIDissolveTransition,
     CIDivideBlendMode,
     CIDotScreen,
     CIEightfoldReflectedTile,
     CIExclusionBlendMode,
     CIExposureAdjust,
     CIFalseColor,
     CIFlashTransition,
     CIFourfoldReflectedTile,
     CIFourfoldRotatedTile,
     CIFourfoldTranslatedTile,
     CIGammaAdjust,
     CIGaussianBlur,
     CIGaussianGradient,
     CIGlassDistortion,
     CIGlideReflectedTile,
     CIGloom,
     CIHardLightBlendMode,
     CIHatchedScreen,
     CIHighlightShadowAdjust,
     CIHistogramDisplayFilter,
     CIHoleDistortion,
     CIHueAdjust,
     CIHueBlendMode,
     CILanczosScaleTransform,
     CILightenBlendMode,
     CILightTunnel,
     CILinearBurnBlendMode,
     CILinearDodgeBlendMode,
     CILinearGradient,
     CILinearToSRGBToneCurve,
     CILineScreen,
     CILuminosityBlendMode,
     CIMaskToAlpha,
     CIMaximumComponent,
     CIMaximumCompositing,
     CIMinimumComponent,
     CIMinimumCompositing,
     CIModTransition,
     CIMultiplyBlendMode,
     CIMultiplyCompositing,
     CIOverlayBlendMode,
     CIPerspectiveCorrection,
     CIPhotoEffectChrome,
     CIPhotoEffectFade,
     CIPhotoEffectInstant,
     CIPhotoEffectMono,
     CIPhotoEffectNoir,
     CIPhotoEffectProcess,
     CIPhotoEffectTonal,
     CIPhotoEffectTransfer,
     CIPinchDistortion,
     CIPinLightBlendMode,
     CIPixellate,
     CIQRCodeGenerator,
     CIRadialGradient,
     CIRandomGenerator,
     CISaturationBlendMode,
     CIScreenBlendMode,
     CISepiaTone,
     CISharpenLuminance,
     CISixfoldReflectedTile,
     CISixfoldRotatedTile,
     CISmoothLinearGradient,
     CISoftLightBlendMode,
     CISourceAtopCompositing,
     CISourceInCompositing,
     CISourceOutCompositing,
     CISourceOverCompositing,
     CISRGBToneCurveToLinear,
     CIStarShineGenerator,
     CIStraightenFilter,
     CIStripesGenerator,
     CISubtractBlendMode,
     CISwipeTransition,
     CITemperatureAndTint,
     CIToneCurve,
     CITriangleKaleidoscope,
     CITwelvefoldReflectedTile,
     CITwirlDistortion,
     CIUnsharpMask,
     CIVibrance,
     CIVignette,
     CIVignetteEffect,
     CIVortexDistortion,
     CIWhitePointAdjust
     */
}

#pragma mark - 更新UI

- (void)updateUI:(NSString *)name
{
    NSLog(@"%@\n", name);
    [self.dataArray addObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
