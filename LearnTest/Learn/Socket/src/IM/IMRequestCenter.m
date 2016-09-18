//
//  IMRequestCenter.m
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMRequestCenter.h"
#import "IMLoginTask.h"
#import "IMChatTask.h"
#import "IMMessageTask.h"
#import "IMSocket.h"

static IMRequestCenter *defaultCenterInstance = nil;

@interface IMRequestCenter ()
{
    IMLoginTask    *_loginTask;
    IMMessageTask  *_messageTask;
    IMChatTask     *_chatTask;
    
    IMHeaderParam  *_headerParam;
}
@end

@implementation IMRequestCenter

+ (IMRequestCenter *)defaultCenter
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            defaultCenterInstance = [[self alloc] init];
        });
    }
    return defaultCenterInstance;
}



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _headerParam = [[IMHeaderParam alloc] init];
        _headerParam.userId = @"";
        _headerParam.appId  = @"568fe1fc-9e43-4d6f-b558-5030e9cd4260";
        _headerParam.appVer = @"1.0";
        _headerParam.deviceType = @"IPH";
        _headerParam.deviceId   = @"";
        
        _headerParam.token      = @"121212";
        _headerParam.lastLoginTime = @"";
    }
    return self;
}

- (BOOL)isWaitingMessage:(NSString *)msgId
{
    return NO;
}

- (BOOL)isFailMessage:(NSString *)msgId
{
    return NO;
}

#pragma mark - 登录相关接口

- (void)requestLoginWithParam:(IMLoginParam *)param
{
    if (_loginTask) { // 任务存在
        if ([_loginTask.username isEqualToString:param.username] && [_loginTask.password isEqualToString:param.password]) // 相同的任务
        {
            
        } else // 不相同的任务
        {
            [_loginTask requestLogout];
            _loginTask.username = param.username;
            _loginTask.password = param.password;
        }
    } else // 任务不存在
    {
        _loginTask = [[IMLoginTask alloc] init];
        _loginTask.username = param.username;
        _loginTask.password = param.password;
    }
    
    _headerParam.userId     = param.userId;
    _headerParam.deviceId   = param.deviceId;
    _headerParam.deviceType = param.deviceType;
    _headerParam.appId      = param.appId;
    _headerParam.appVer     = param.appVersion;
    _loginTask.headerParam  = _headerParam;
    [_loginTask requestLoginWithParam:param];
}

- (void)requestLogoutWithUserName:(NSString *)name password:(NSString *)password
{
    if (_loginTask)
    {
        if ([_loginTask.username isEqualToString:name] && [_loginTask.password isEqualToString:password]) // 存在需要退出的任务
        {
            [_loginTask requestLogout];
            _loginTask = nil;
            
            _chatTask  = nil;
            
            _messageTask = nil;
            
            _headerParam.userId = @"";
        }
    }
}




#pragma mark - 会话相关接口

- (void)requestChatList
{
    if (!_chatTask)
    {
        _chatTask = [[IMChatTask alloc] init];
        _chatTask.headerParam = _headerParam;
    }
    [_chatTask requestChatList];
}





#pragma mark - 消息相关接口

- (void)setCurrentChat:(IMChat *)chat
{
    if (chat)
    {
        if (!_messageTask)
        {
            _messageTask = [[IMMessageTask alloc] init];
            _messageTask.headerParam= _headerParam;
        }
        if (!chat.sessId.length) {
            chat.sessId = @"0";
        }
        _messageTask.messageManager.currentChat = chat;
    } else
    {
        _messageTask.messageManager.currentChat = nil;
    }
}

- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId
{
    IMChat *chat = _messageTask.messageManager.currentChat;
    if (!_messageTask || !chat)
    {
        NSLog(@"消息发送失败，请开启会话任务");return;
    }
    if (![chat.chatId isEqualToString:msg.to])
    {
        NSLog(@"消息发送失败，发送的消息不属于会话任务的消息，请切换会话任务");return;
    }
    
    if (!sessId.length) {
        sessId = @"0";
    }
    
    [_messageTask requestSendMsg:msg sessId:sessId];
}

- (void)requestReSendMsg:(IMMessage *)msg sessId:(NSString *)sessId // 重发消息
{
    IMChat *chat = _messageTask.messageManager.currentChat;
    if (!_messageTask || !chat)
    {
        NSLog(@"消息发送失败，请开启会话任务");return;
    }
    if (![chat.chatId isEqualToString:msg.to])
    {
        NSLog(@"消息发送失败，发送的消息不属于会话任务的消息，请切换会话任务");return;
    }
    
    if (!sessId.length) {
        sessId = @"0";
    }
    [_messageTask requestReSendMsg:msg sessId:sessId];
}




@end
