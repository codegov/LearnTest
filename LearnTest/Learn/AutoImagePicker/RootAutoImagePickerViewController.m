//
//  RootAutoImagePickerViewController.m
//  LearnTest
//
//  Created by syq on 15/5/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "RootAutoImagePickerViewController.h"
#import "AutoImagePickerViewController.h"

@interface RootAutoImagePickerViewController ()

@end

@implementation RootAutoImagePickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.dataArray addObject:@{@"title": @"测试拍照1",  @"class": @"AutoImagePickerViewController"}];
    }
    return self;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *className = [dic objectForKey:@"class"];
    UIViewController *con = [NSClassFromString(className) new];
    con.title = [dic objectForKey:@"title"];
    if ([con isKindOfClass:[UIImagePickerController class]])
    {
        UIImagePickerController *picker = (UIImagePickerController *)con;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    } else
    {
        [self.navigationController presentViewController:con animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"1==image==%@     %@", image, editingInfo);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
}

@end
