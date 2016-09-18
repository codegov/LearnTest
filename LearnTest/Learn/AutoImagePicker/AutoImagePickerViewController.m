//
//  AutoImagePickerViewController.m
//  LearnTest
//
//  Created by syq on 15/5/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "AutoImagePickerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

///* the use of UIGetScreenImage() may no longer be sanctioned, even
// * though it was previously "allowed".  define this to 0 to rip it out
// * and fall back to cameraMode=Default (manual capture)
// */
//#ifndef USE_PRIVATE_APIS
//# define USE_PRIVATE_APIS 0
//#endif
//
//#ifndef MIN_QUALITY
//# define MIN_QUALITY 10
//#endif
//
//#if USE_PRIVATE_APIS
//// expose undocumented API
//CF_RETURNS_RETAINED
//CGImageRef UIGetScreenImage(void);
//#endif

@interface AutoImagePickerViewController ()
{
    UILabel *label;
    UIImageView *imageView;
    NSTimer *timer;
    int time;
}
@end

@implementation AutoImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showsCameraControls = NO;
    self.allowsEditing = NO;
    
    time = 6;
    float width = 100.0;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 300.0)];
    imageView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, width)];
    label.center = self.view.center;
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:80.0];
    label.text = @(time).stringValue;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = 6;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.0];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
}

- (void)updateLabel
{
    NSInteger ti = label.text.integerValue;
    ti --;
    label.text = @(ti).stringValue;
    if (ti == 0)
    {
        [timer invalidate];
        timer = nil;
        
        [label removeFromSuperview];
        label = nil;
        
        
        
        [self takePicture];
        
//        CGImageRef image = UIGetScreenImage();
//        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView.image = [UIImage imageWithCGImage:image];
//            
//            NSLog(@"image  ===%@", imageView.image);
//        });
        
//        extern CGImageRef UIGetScreenImage();//需要先extern
//        UIImage *image = [UIImage imageWithCGImage:UIGetScreenImage()];
//        imageView.image = image;
//        UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
        
//        UIGraphicsBeginImageContext(self.view.frame.size);
//        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [timer invalidate];
    timer = nil;
    
    [label removeFromSuperview];
    label = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
