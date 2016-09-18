//
//  WebViewCacheViewController.m
//  LearnTest
//
//  Created by syq on 15/5/12.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "WebViewCacheViewController.h"

#import "CustomURLCache.h"
#import "MBProgressHUD.h"

@interface WebViewCacheViewController ()

@end

@implementation WebViewCacheViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                                                     diskCapacity:200 * 1024 * 1024
                                                                         diskPath:nil
                                                                        cacheTime:0];
        [CustomURLCache setSharedURLCache:urlCache];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    CustomURLCache *urlCache = (CustomURLCache *)[NSURLCache sharedURLCache];
    [urlCache removeAllCachedResponses];
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}

@end

