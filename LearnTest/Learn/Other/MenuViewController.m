//
//  MenuViewController.m
//  LearnTest
//
//  Created by syq on 14/11/4.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "MenuViewController.h"
#import "TestView.h"


@interface MenuViewController ()
{
    TestView *_test;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TestView *test = [[TestView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 50.0)];
    test.backgroundColor = [UIColor blueColor];
    [self.view addSubview:test];
//    self.tableView.tableHeaderView = test;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    cell.textLabel.text = @"视图初始化";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _test.text = @"---";
//    _test.frame = CGRectMake(0.0, 0.0, 200.0, 40.0);
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
