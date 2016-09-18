//
//  IMMessageManager.m
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMMessageManager.h"
#import "IMResponse.h"
#import "IMConfig.h"

@implementation IMMessageManager
{
    NSMutableArray      *_dataArray;
    NSMutableDictionary *_dataDictionary;
    
    NSMutableDictionary *_waitingDictionary;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _waitingDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - 设置当前会话

- (void)setCurrentChat:(IMChat *)currentChat
{
    _currentChat = currentChat;
    if (!currentChat)
    {
        [self clearMemMessage];
    } else
    {
        _dataArray      = [[NSMutableArray alloc] init];
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
}

#pragma mark - 发消息

- (void)addSendMessage:(IMMessage *)msg
{
    if (msg.msgCid.length)
    {
        [_dataDictionary setObject:msg forKey:msg.msgCid];
        [_dataArray addObject:msg];
        [_waitingDictionary setObject:msg forKey:msg.msgCid];
        [self responseOfMessageDidChange:@(IM_ERROR).stringValue string:@"正在发送...."];
    }
}

#pragma mark - 删除消息

- (void)removeMessage:(NSString *)msgId
{
    if (msgId.length)
    {
        IMMessage *m = [_dataDictionary objectForKey:msgId];
        if (m)
        {
            [_dataArray removeObject:m];
            [_dataDictionary removeObjectForKey:msgId];
        }
    }
}

#pragma mark - 发送消息成功

- (void)updateMessageOfSendSuccess:(NSDictionary *)dic code:(NSString *)code
{
    NSString *msgCid = @([[dic objectForKey:@"clientTime"] longLongValue]).stringValue;
    
    if (msgCid.length)
    {
        [_waitingDictionary removeObjectForKey:msgCid];
        IMMessage *msg = [_dataDictionary objectForKey:msgCid];
        if (msg)
        {
            [_dataArray removeObject:msg];
            [_dataDictionary removeObjectForKey:msgCid];
            
            msg.msgSid = @([[dic objectForKey:@"msgId"] longLongValue]).stringValue;
//            msg.version = @([[dic objectForKey:@"msgVer"] integerValue]).stringValue;
            msg.serverTime = @([[dic objectForKey:@"serverTime"] longLongValue]).stringValue;
            msg.failed = @(NO);
            if (msg.msgSid.length)
            {
                [_dataDictionary setObject:msg forKey:msg.msgSid];
            }
        }
        [self responseOfMessageSendOrReceive:code string:@"发送成功" message:msg];
        [self responseOfMessageDidChange:code string:@"发送成功"];
    }
}

#pragma mark - 发送消息失败

- (void)updateMessageOfSendFail:(NSString *)msgId code:(NSString *)code errstring:(NSString*)errstring
{
    if (!msgId.length) return;
    
    [_waitingDictionary removeObjectForKey:msgId];
    
    IMMessage *msg = [_dataDictionary objectForKey:msgId];
    if (msg)
    {
        msg.failed = @(YES);
    }
    [self responseOfMessageSendOrReceive:code string:errstring message:msg];
    [self responseOfMessageDidChange:code string:errstring];
}

#pragma mark - 接收消息

- (void)receiveMessage:(IMMessage *)msg
{
    if (msg.msgSid.length)
    {
        [_dataDictionary setObject:msg forKey:msg.msgSid];
        [_dataArray addObject:msg];
        [self responseOfMessageSendOrReceive:@(IM_SUCCESS).stringValue string:@"收到消息" message:msg];
        [self responseOfMessageDidChange:@(IM_SUCCESS).stringValue string:@"收到消息"];
    }
}

#pragma mark - 清除内存数据

- (void)clearMemMessage
{
    [_dataDictionary removeAllObjects];
    [_dataArray removeAllObjects];
    _dataDictionary = nil;
    _dataArray = nil;
}

#pragma mark - 消息发送变化通知

- (void)responseOfMessageDidChange:(NSString *)code string:(NSString *)string
{
    IMResponse *response = [[IMResponse alloc] init];
    response.statusCode = code;
    response.statusCodeOfLocalizedString = string;
    response.result = [NSArray arrayWithArray:_dataArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_MessageDidChange_Notification object:response];
}

#pragma mark - 发送或者接收消息

- (void)responseOfMessageSendOrReceive:(NSString *)code string:(NSString *)string message:(IMMessage *)message
{
    IMResponse *response = [[IMResponse alloc] init];
    response.statusCode = code;
    response.statusCodeOfLocalizedString = string;
    response.result = message;
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_MessageOfSendOrReceive_Notification object:response];
}

@end
