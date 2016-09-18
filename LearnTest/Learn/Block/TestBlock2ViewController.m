//
//  TestBlock2ViewController.m
//  LearnTest
//
//  Created by syq on 14/11/17.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestBlock2ViewController.h"

@interface TestBlock2ViewController ()

@end

@implementation TestBlock2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self doBlock2];
}

- (void)doBlock1
{
    typedef int (^block1)(int);
    
    __block int i1 = 0; // block里既能使用，也能修改
    block1 b1= ^(int value){
        return i1 += value;
    };
    
    int i2 = 2;   // block里只能使用，不能修改
    block1 b2 = ^(int value){
        return i2 * value;
    };
    
    NSString *name = [NSString stringWithFormat:@"block1 b1=%d b2=%d", b1(7), b2(4)];
    [self updateUI:name];
}

- (void)doBlock2
{
    typedef NSString* (^block2)(NSString *v1, NSString *v2);
    
    __weak __block NSString *bs1 = @"bs1 tring";
    block2 b1 = ^(NSString *v1, NSString *v2){
        return [NSString stringWithFormat:@"%@-%@-%@", bs1, v1, v2];
    };
    
    __block NSString *bs2 = @"bs2 tring";// 等同 __strong __block NSString *bs2 = @"bs2 tring";
    block2 b2 = ^(NSString *v1, NSString *v2){
        return [NSString stringWithFormat:@"%@-%@-%@", bs2, v1, v2];
    };

    
    block2 b3 = [b2 copy];
    
    NSString *name = [NSString stringWithFormat:@"block2 b1=%@ b2=%@ b3=%@", b1(@"1", @"2"), b2(@"3", @"4"), b3(@"5", @"6")];
    [self updateUI:name];
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
