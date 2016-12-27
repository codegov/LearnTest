//
//  ViewController.m
//  LearnTest
//
//  Created by syq on 14/10/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "ViewController.h"
#import "LTFont.h"
#import "DLFontManager.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import "MSNetworksManager.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>

{
    NSURLSession *backgroundSession;
}

@end

@implementation ViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self)
//    {
//        NSLog(@"****ViewController*执行*initWithNibName");
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"学习";
        [self.dataArray addObject:@{@"title": @"多线程学习",  @"class": @"ThreadRootViewController"}];
        [self.dataArray addObject:@{@"title": @"Block学习",  @"class": @"BlockRootViewController"}];
        [self.dataArray addObject:@{@"title": @"其他学习",    @"class": @"OtherRootViewController"}];
        [self.dataArray addObject:@{@"title": @"软件技术基础", @"class": @"SoftBaseRootViewController"}];
        [self.dataArray addObject:@{@"title": @"webView学习", @"class": @"WebViewRootViewController"}];
        [self.dataArray addObject:@{@"title": @"GCD学习",     @"class": @"GcdRootViewController"}];
        [self.dataArray addObject:@{@"title": @"核心动画学习",  @"class": @"CoreAnimationRootViewController"}];
        [self.dataArray addObject:@{@"title": @"runtime学习", @"class": @"RuntimeRootViewController"}];
        [self.dataArray addObject:@{@"title": @"算法学习", @"class": @"AlgorithmRootViewController"}];
        [self.dataArray addObject:@{@"title": @"test", @"class": @"AlgorithmRootViewController"}];
        [self.dataArray addObject:@{@"title": @"KeyChain", @"class": @"KeyChainRootViewController"}];
        [self.dataArray addObject:@{@"title": @"dealloc", @"class": @"TestDeallocViewController"}];
        [self.dataArray addObject:@{@"title": @"支持64位", @"class": @"Support64RootViewController"}];
        [self.dataArray addObject:@{@"title": @"自动拍照",  @"class": @"RootAutoImagePickerViewController"}];
        [self.dataArray addObject:@{@"title": @"蓝牙学习",  @"class": @"BlueYaRootViewController"}];
        [self.dataArray addObject:@{@"title": @"套接字学习", @"class": @"SocketRootViewController"}];
        [self.dataArray addObject:@{@"title": @"GIF学习", @"class": @"GIFViewController"}];
        [self.dataArray addObject:@{@"title": @"授权账户", @"class": @"AccountViewController"}];
        [self.dataArray addObject:@{@"title": @"leetcode", @"class": @"LeetcodeViewController"}];
        [self.dataArray addObject:@{@"title": @"绘制学习", @"class": @"DrawRootViewController"}];
        [self.dataArray addObject:@{@"title": @"OpenGL学习", @"class": @"LearnGLRootViewController"}];
        
//        NSLog(@"****ViewController*执行*init");
        
//        [[self fuc1:^int(int x) {
//            NSLog(@"x====%@", @(x));
//            return 3;
//        }] fuc2:^int(int y) {
//            NSLog(@"y====%@", @(y));
//            return 5;
//        }];
        
    }
    return self;
}

//- (ViewController *)fuc1:(int(^)(int x))block
//{
//    NSLog(@"fuc1===1");
//    int i = block (6);
//    NSLog(@"fun1===2");
//    return self;
//}
//
//- (ViewController *)fuc2:(int(^)(int y))block
//{
//    
//    return self;
//}

// 连接的wifi
+ (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80.0, 80.0, 100.0, 100.0)];
//    view.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:view];
//    
//    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 90.0, 90.0)];
//    subView1.backgroundColor = [UIColor redColor];
//    [view addSubview:subView1];
//    
//    CALayer *subLayer = [[CALayer alloc] init];
//    subLayer.bounds = CGRectMake(0.0, 0.0, 80.0, 80.0);
//    subLayer.position = CGPointMake(40.0, 40.0);
//    subLayer.backgroundColor = [UIColor yellowColor].CGColor;
//    [view.layer addSublayer:subLayer];
//    
//    NSLog(@"====%@", @(view.layer.sublayers.count).stringValue);
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self getImageFromView:view]];
//    imageView.frame = CGRectMake(80.0, 190.0, 110.0, 110.0);
//    [self.view addSubview:imageView];
    
//    NSURL *url = [NSURL URLWithString: @"http://sto.chanapp.chanjet.com/ecaf1c0b-3794-4a06-864a-17ce0d3245c3/2015/07/27/77c69a5d67784208bc3bac02e96446ff.png.big.png"];
//    
//    NSURLSessionConfiguration *backgroundConfigObject = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"123"];
//    backgroundConfigObject.networkServiceType = NSURLNetworkServiceTypeBackground;
//    backgroundConfigObject.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    backgroundConfigObject.sessionSendsLaunchEvents = YES;
//    backgroundSession = [NSURLSession sessionWithConfiguration: backgroundConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
//    NSURLSessionDownloadTask *downloadTask = [backgroundSession downloadTaskWithURL: url];
//    
//    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"didBecomeInvalidWithError");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSLog(@"didReceiveChallenge");
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession");
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"downloadTask1==%@", location.absoluteString);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"downloadTask2==%@   %@   %@", @(bytesWritten).stringValue, @(totalBytesWritten).stringValue, @(totalBytesExpectedToWrite).stringValue);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"downloadTask3==%@   %@ ", @(fileOffset).stringValue, @(expectedTotalBytes).stringValue);
}


- (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//- (void)loadView
//{
//    [super loadView];
//    NSLog(@"****ViewController*执行*loadView");
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"****ViewController*执行*viewDidLoad");
//    
//    NSDictionary *ifs = [[self class] fetchSSIDInfo];
//    NSString *ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
//    NSLog(@"ssid：%@   %@",ssid, ifs);
    
//    [[MSNetworksManager sharedNetworksManager] scan];
    
//    NSLog(@"=====%@", [UIFont fontWithName:@"DFWaWaSC-W5.otf" size:16]);
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80.0, 80.0, 40.0)];
//    label.font = [UIFont fontWithName:@"fontIcon" size:16];
////    label.font = [UIFont systemFontOfSize:16];
//    label.text = @"\"\\e602\"";
//    
////    label.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:label];
    
    
//    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(20.0, 150.0, 100.0, 100.0)];
//    webview.backgroundColor = [UIColor brownColor];
//    [webview loadHTMLString:@"" baseURL:<#(NSURL *)#>]
    
    
//    BOOL downloaded = [[DLFontManager shareInstance] isFontDownLoaded:@"DFWaWaSC-W5"];
//    if (downloaded)
//    {
//    }
//    else
//    {
//        [[DLFontManager shareInstance] downLoadFont:@"DFWaWaSC-W5" success:^(BOOL finished) {
//            NSLog(@"下载成功");
//            label.font = [UIFont fontWithName:@"DFWaWaSC-W5" size:16];
//
//        } failed:^(NSString *error) {
//            NSLog(@"下载失败");
//        }];
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"****ViewController*执行*viewWillAppear");
//}
//
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    NSLog(@"****ViewController*执行*viewWillLayoutSubviews");
//}
//
//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    NSLog(@"****ViewController*执行*viewDidLayoutSubviews");
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog(@"****ViewController*执行*viewDidAppear");
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog(@"****ViewController*执行*viewWillDisappear");
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
