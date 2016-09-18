//
//  SocketMessageViewController.m
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "SocketMessageViewController.h"
#import "IMRequestCenter.h"

@implementation SocketMessageViewController
{
    int _msgCount;
    
    IMMessage *_reMsg;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageDidChangeNotification:) name:IM_MessageDidChange_Notification object:nil];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendMsg)];
    self.navigationItem.rightBarButtonItem = item;
    
    [[IMRequestCenter defaultCenter] setCurrentChat:_chat];
}

- (void)dealloc
{
    [[IMRequestCenter defaultCenter] setCurrentChat:nil];
}

- (void)messageDidChangeNotification:(NSNotification *)notification
{
    IMResponse *response = notification.object;
    self.dataArray.array = response.result;
    [self.tableView reloadData];
}

- (void)sendMsg
{
    IMMessage *msg = [[IMMessage alloc] init];
    msg.to         = _chat.chatId;
    msg.from       = _bid;
    msg.clientTime = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
    msg.msgCid     = msg.clientTime;
    msg.mediaType  = IMMessageMediaTypeText;
    msg.body       = [NSString stringWithFormat:@"TEST_%d", _msgCount++];
    
    _reMsg = msg;
    
    [[IMRequestCenter defaultCenter] requestSendMsg:msg sessId:_chat.sessId];
}

- (void)reSendMsg
{
    _reMsg.clientTime = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
    [[IMRequestCenter defaultCenter] requestReSendMsg:_reMsg sessId:_chat.sessId];
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tempId = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tempId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tempId];
    }
    
    IMMessage *message = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = message.from;
    cell.detailTextLabel.text = message.body;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
