//
//  SocketTest1ViewController.m
//  LearnTest
//
//  Created by syq on 15/5/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "SocketTest1ViewController.h"
#import "IMRequestCenter.h"
#import "SocketChatViewController.h"
#import "CommonCrypto/CommonDigest.h"

@implementation SocketTest1ViewController
{
    UILabel *_statusLabel;
    
    IMLoginParam  *_param;

    NSString *_bid;
    NSString *_toUID;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginDidChangeNotification:) name:IM_LoginDidChange_Notification object:nil];
        
        [self.dataArray addObject:@{@"title": @"登录",    @"method": @"login"}];
        [self.dataArray addObject:@{@"title": @"登出",    @"method": @"logout"}];
        [self.dataArray addObject:@{@"title": @"会话",    @"method": @"enterChat"}];
    }
    return self;
}

+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // huqw:60000001366 javakafeilong:60000006099
    
    NSString *currentModel = [[UIDevice currentDevice] model];
    
    NSString *account = @"fuwz@chanjet.com";
    NSString *password = @"111111";
    
    account = @"18612932411";
    password = @"222222";
    
    if ([currentModel isEqualToString:@"iPhone Simulator"])
    {
        _bid = @"60000006100";// 付
        _toUID   = @"60000021682";// 胡
        NSLog(@"模拟器");
    }
    else
    {
        // 手机
        _bid = @"60000021682";
        _toUID   = @"60000006100";
        
        
        
        NSLog(@"真机");
    }
    
    _param = [[IMLoginParam alloc] init];
    _param.username    = account;//@"javakafeilong@qq.com";//@"huqw@chanjet.com";
    _param.password    = [SocketTest1ViewController md5:password];//@"96e79218965eb72c92a549dd5a330112";
    _param.loginType   = @"1";
    _param.userId      = _bid;
    _param.appId       = @"568fe1fc-9e43-4d6f-b558-5030e9cd4260";
    _param.appVersion  = @"1.0";
    _param.deviceType  = @"IPH";
    _param.deviceToken = @"121212";
    _param.deviceId    = @"000000000000000";
}

- (void)enterChat
{
    SocketChatViewController *chat = [[SocketChatViewController alloc] init];
    chat.title = @"会话";
    chat.bid = _bid;
    chat.to = _toUID;
    [self.navigationController pushViewController:chat animated:YES];
}


- (void)loginDidChangeNotification:(NSNotification *)notification
{
    IMResponse *response = notification.object;
    _statusLabel.text = [NSString stringWithFormat:@"code=%@;msg=%@", response.statusCode, response.statusCodeOfLocalizedString];
}

- (void)login
{
    [[IMRequestCenter defaultCenter] requestLoginWithParam:_param];
}

- (void)logout
{
    [[IMRequestCenter defaultCenter] requestLogoutWithUserName:_param.username password:_param.password];
}


#pragma mark - Delegate

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
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *method = [dic objectForKey:@"method"];
    SEL selm = NSSelectorFromString(method);
    if ([self respondsToSelector:selm])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selm withObject:nil];
#pragma clang diagnostic pop
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 60.0)];
    view.backgroundColor = [UIColor brownColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, view.frame.size.width, 40.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    _statusLabel = label;
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
