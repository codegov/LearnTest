//
//  LearnTableViewController.m
//  LearnTest
//
//  Created by syq on 14/10/24.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "LearnTableViewController.h"

@interface LearnTableViewController ()

@end

@implementation LearnTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray      = [[NSMutableArray alloc] init];
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden

{
    return NO;//隐藏为YES，显示为NO
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        // iOS 7
        
        [self prefersStatusBarHidden];
        
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    NSString *className = [dic objectForKey:@"class"];
    UIViewController *con = [NSClassFromString(className) new];
    con.title = [dic objectForKey:@"title"];
    [self.navigationController pushViewController:con animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
