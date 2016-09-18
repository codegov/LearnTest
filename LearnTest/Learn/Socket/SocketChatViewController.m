//
//  SocketChatViewController.m
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "SocketChatViewController.h"
#import "IMRequestCenter.h"
#import "SocketMessageViewController.h"

@implementation SocketChatViewController
{
    NSMutableArray *_functionArray;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidChangeNotification:) name:IM_ChatDidChange_Notification object:nil];
        _functionArray = [[NSMutableArray alloc] init];
        [_functionArray addObject:@{@"title": @"创建单聊会话", @"action": @"createChat"}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"获取" style:UIBarButtonItemStyleDone target:self action:@selector(chatList)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)chatDidChangeNotification:(NSNotification *)notification
{
    IMResponse *response = notification.object;
    self.dataArray = response.result;
    
    [self.tableView reloadData];
}

- (void)chatList
{
    [[IMRequestCenter defaultCenter] requestChatList];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _functionArray.count;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tempId];
    }
    
    NSString *title = nil;
    if (indexPath.section == 0)
    {
        NSDictionary *dic = [_functionArray objectAtIndex:indexPath.row];
        title = [dic objectForKey:@"title"];
    } else
    {
        IMChat *chat = [self.dataArray objectAtIndex:indexPath.row];
        title = [NSString stringWithFormat:@"和%@的会话", chat.chatId];
    }
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        IMChat *chat = [self.dataArray objectAtIndex:indexPath.row];
        SocketMessageViewController *message = [[SocketMessageViewController alloc] init];
        message.title = chat.chatId;
        message.bid = _bid;
        message.chat = chat;
        [self.navigationController pushViewController:message animated:YES];
    } else
    {
        IMChat *chat = [[IMChat alloc] init];
        chat.chatId = _to;
        SocketMessageViewController *message = [[SocketMessageViewController alloc] init];
        message.title = chat.chatId;
        message.bid = _bid;
        message.chat = chat;
        [self.navigationController pushViewController:message animated:YES];
    }
}

@end
