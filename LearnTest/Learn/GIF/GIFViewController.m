//
//  GIFViewController.m
//  LearnTest
//
//  Created by syq on 15/8/4.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "GIFViewController.h"
#import "SCGIFImageView.h"
#import "SvGifView.h"

@interface GIFViewController ()
{
    SvGifView *gifView1;
}
@end

@implementation GIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [UIColor brownColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jiafei" ofType:@"gif"];
    NSData *mediaData = [NSData dataWithContentsOfFile:filePath];
    SCGIFImageView *gifView = [[SCGIFImageView alloc] initWithGIFData:mediaData];
    gifView.frame = CGRectMake(25.0, 80.0, 270, 155);
    [self.view addSubview:gifView];
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"jiafei" withExtension:@"gif"];
    gifView1 = [[SvGifView alloc] initWithCenter:CGPointMake(160.0, 340.0) fileURL:fileUrl];
    gifView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gifView1];
    [gifView1 startGif];
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
