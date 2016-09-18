//
//  TestBlock1ViewController.m
//  LearnTest
//
//  Created by syq on 14/10/24.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import "TestBlock1ViewController.h"
#import "UIFont+TestFont.h"

#if NS_BLOCKS_AVAILABLE

typedef void (^FinishBlock)(NSDictionary *userInfo, id jsonValue);
typedef void (^FailureBlock)(NSDictionary *userInfo, id jsonValue);

#endif

@interface TestBlock1ViewController ()
{
    FinishBlock  _finish;
    FailureBlock _fail;
}
@end


@implementation TestBlock1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    __weak TestBlock1ViewController *weakSelf = self;
//    
//    [self testWitUserInfo:@{@"title": @"test1"}
//                   finish:^(NSDictionary *userInfo, id jsonValue)
//     {
//         NSString *name = [NSString stringWithFormat:@"%@执行finish1", [userInfo objectForKey:@"title"]];
//         [weakSelf updateUI:name];
//     } fail:^(NSDictionary *userInfo, id jsonValue) {
//         NSLog(@"fail1");
//     }];
//    
//    [self testWitUserInfo:@{@"title": @"test2"}
//                   finish:^(NSDictionary *userInfo, id jsonValue)
//    {
//        
//        NSString *name = [NSString stringWithFormat:@"%@执行finish2", [userInfo objectForKey:@"title"]];
//        [weakSelf updateUI:name];
//    } fail:^(NSDictionary *userInfo, id jsonValue) {
//        NSLog(@"fail2");
//    }];
}

- (void)makeBlock
{
    [self updateUI:@"生成了"];
    __weak TestBlock1ViewController *weakSelf = self;
    
    [self testWitUserInfo:@{@"title": @"test2"}
                   finish:^(NSDictionary *userInfo, id jsonValue)
     {
         
         NSString *name = [NSString stringWithFormat:@"%@执行finish2", [userInfo objectForKey:@"title"]];
         [weakSelf updateUI:name];
     } fail:^(NSDictionary *userInfo, id jsonValue) {
         NSLog(@"fail2");
     }];

}

- (void)doBlock
{
    if (_finish) {
        [self updateUI:@"等待执行"];
        [self performSelector:@selector(finish:) withObject:@{@"title": @"test1"} afterDelay:10];
    } else {
        [self updateUI:@"没有可以执行的Block"];
    }
}

- (void)cancelBlock
{
    if (_finish) {
        [self updateUI:@"释放了"];
        [TestBlock1ViewController cancelPreviousPerformRequestsWithTarget:self];
        _finish = nil;
    } else {
        [self updateUI:@"没有可以释放的Block"];
    }
}

- (void)updateUI:(NSString *)name
{
    NSLog(@"%@", name);
    [self.dataArray addObject:name];
    [self.tableView reloadData];
}

- (void)testWitUserInfo:(NSDictionary *)userInfo
                 finish:(FinishBlock)finish
                   fail:(FailureBlock)fail
{
    _finish = finish;
    _fail   = fail;
//    [self finish:userInfo];
//    [NSThread detachNewThreadSelector:@selector(finish:) toTarget:self withObject:userInfo];
//    [self performSelector:@selector(finish:) withObject:userInfo afterDelay:5];
}

- (void)finish:(NSDictionary *)userInfo
{
    if (_finish) _finish (userInfo, @"完成");
}

- (void)fail
{
    if (_fail) _fail (nil, @"失败");
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float width = self.view.bounds.size.width/3;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40.0)];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 40.0)];
    [button1 setTitle:@"生成Block" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor brownColor];
    [button1 addTarget:self action:@selector(makeBlock) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button1];
    
    float x = button1.frame.size.width + button1.frame.origin.x;
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, view.frame.size.height)];
    [button2 setTitle:@"等待10s执行" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(doBlock) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    x = button2.frame.size.width + button2.frame.origin.x;
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, view.frame.size.height)];
    [button3 setTitle:@"释放Block" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor blueColor];
    [button3 addTarget:self action:@selector(cancelBlock) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button3];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
