//
//  IMChatManagerQueue.m
//  LearnTest
//
//  Created by syq on 15/6/1.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMChatSynTask.h"
#import "IMChatMsgSynTask.h"
#import "CDVJSON.h"
#import "IMRequestInterface.h"

@interface IMChatSynTask ()<IMChatMsgSynTaskDelegate>
{
    NSMutableArray      *_dataArray;
    NSMutableDictionary *_dataDictionary;
    IMChatManager       *_chatManager;
    
    BOOL _isSynChat;  // 正在同步
}
@end

@implementation IMChatSynTask

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _dataArray   = [[NSMutableArray alloc] init];
        _dataDictionary = [[NSMutableDictionary alloc] init];
        _chatManager = [[IMChatManager alloc] init];
    }
    return self;
}

#pragma mark - 请求得到的会话，同步此会话

- (void)requestSynChat:(IMChat *)chat
{
    [self synChat:chat type:0];
}

#pragma mark - 收到会话消息得到的会话，同步此会话

- (void)receiveSynChat:(IMChat *)chat
{
    [self synChat:chat type:1];
}

#pragma mark - 同步此会话

- (void)synChat:(IMChat *)chat type:(int)type
{
    IMChatMsgSynTask *task = [[IMChatMsgSynTask alloc] init];
    task.delegate = self;
    task.chat = chat;
    task.chatSynType = type;
    
    [_dataArray addObject:task];
    [_dataDictionary setObject:task forKey:chat.sessId];
    
    [self start];
}

- (void)start
{
    if (!_dataArray.count) return;
    
    if (_isSynChat) return;
    
    _isSynChat = YES;
    
    IMChatMsgSynTask *task = _dataArray.firstObject;
    
    
    if (task.chatSynType == 1)
    {
        NSInteger sver = task.chat.chatVer.integerValue - [self queryMaxChatVer].integerValue;
        if (sver < 1)
        {
            [self synChatFinishWithTask:task]; return;
        }
        
        IMChat *localChat   = [_chatManager queryChat:task.chat.chatId];
        NSInteger mver = task.chat.lastMsgVer.integerValue - localChat.lastMsgVer.integerValue;
        if (sver == 1)
        {
            if (mver == 1)
            {
                [self startWithTask:task localChat:localChat];
            } else
            {
                [self synChatFinishWithTask:task];
            }
        } else if (sver > 1)
        {
            if (sver == mver)
            {
                [self startWithTask:task localChat:localChat];
            } else
            {
                [self synChatFinishWithTask:task];
                [self requestChatList];
            }
        }
    } else if (task.chatSynType == 0)
    {
        IMChat *localChat   = [_chatManager queryChat:task.chat.chatId];
        [self startWithTask:task localChat:localChat];
    }
}

- (void)startWithTask:(IMChatMsgSynTask *)task localChat:(IMChat *)localChat
{
    if (localChat == nil)
    {
        
    } else
    {
        
    }
}

#pragma mark - 同步会话完成

- (void)synChatFinishWithTask:(IMChatMsgSynTask *)task
{
    [_dataArray removeObject:task];
    _isSynChat = NO;
}

#pragma mark - IMChatMsgSynTaskDelegate

- (void)chatMsgSynTaskSuccess:(IMChatMsgSynTask *)task
{
    [self successSaveMaxChatVer:task.chat.chatVer];
    [self synChatFinishWithTask:task];
    [self start];
}

- (void)chatMsgSynTaskFail:(IMChatMsgSynTask *)task
{
    [self failSaveMinChatVer:task.chat.chatVer];
    [self synChatFinishWithTask:task];
    [self start];
}

#pragma mark - 会话同步成功，保存最大会话版本；会话同步失败，保存最小会话版本

- (void)successSaveMaxChatVer:(NSString *)ver
{
    NSString *min = [self queryMinFailChatVer];
    if (min.length)
    {
        if (ver.integerValue == min.integerValue)
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self keyOfMin]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else
    {
        NSString *max = [self queryMaxChatVer];
        if (ver.integerValue > max.integerValue)
        {
            [[NSUserDefaults standardUserDefaults] setObject:ver forKey:[self keyOfMax]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)failSaveMinChatVer:(NSString *)ver
{
    NSString *min = [self queryMinFailChatVer];
    if (ver.integerValue < min.integerValue)
    {
        [[NSUserDefaults standardUserDefaults] setObject:ver forKey:[self keyOfMin]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)queryMaxChatVer
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self keyOfMax]];
}

- (NSString *)queryMinFailChatVer
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self keyOfMin]];
}

- (NSString *)keyOfMax
{
    return [NSString stringWithFormat:@"%@_MAXCHATVER", _headerParam.userId];
}

- (NSString *)keyOfMin
{
    return [NSString stringWithFormat:@"%@_MINFAILCHATVER", _headerParam.userId];
}

#pragma mark 请求会话需要的版本

- (NSString *)chatVerOfRequest
{
    NSInteger value = 0;
    NSString *min = [self queryMinFailChatVer];
    if (min.length)
    {
        value = (min.integerValue - 1);
    } else
    {
        value = [self queryMaxChatVer].integerValue;
    }
    value = value > 0 ? value : 0;
    return @(value).stringValue;
}


#pragma mark - 获取会话列表

- (void)requestChatList
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestChatDetailList:_headerParam.userId version:[self chatVerOfRequest] pageNum:@"1000" header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            //            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
            //            [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan返回数据为空" result:nil];
            return;
        }
        
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
        
        NSArray *list = [dic objectForKey:@"data"];
        for (NSDictionary *dictionary in list)
        {
            NSString *sid = @([[dictionary objectForKey:@"sessId"] longLongValue]).stringValue;
            if (sid.length)
            {
                IMChat *chat     = [[IMChat alloc] init];
                chat.sessId      = sid;
                chat.lastMsgId   = @([[dictionary objectForKey:@"lastMsgId"] longLongValue]).stringValue;
                chat.lastMsgVer  = @([[dictionary objectForKey:@"msgVer"] integerValue]).stringValue;
                chat.readVer     = @([[dictionary objectForKey:@"readVer"] longLongValue]).stringValue;
                chat.unread      = @([[dictionary objectForKey:@"unReadNum"] integerValue]).stringValue;
                chat.chatVer     = @([[dictionary objectForKey:@"sessVer"] longLongValue]).stringValue;
                
                chat.lastMsgUserId  = @([[dictionary objectForKey:@"lastUserId"] longLongValue]).stringValue;
                chat.lastMsgBody    = [dictionary objectForKey:@"summary"];
                chat.lastMsgTime    = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
                chat.type           = [[dictionary objectForKey:@"type"] intValue];
                NSString *userId1   = @([[dictionary objectForKey:@"userId1"] longLongValue]).stringValue;
                NSString *userId2   = @([[dictionary objectForKey:@"userId2"] longLongValue]).stringValue;
                if (!userId1.length || [_headerParam.userId isEqualToString:userId1])
                {
                    chat.chatId = userId2;
                } else if (!userId2.length || [_headerParam.userId isEqualToString:userId2])
                {
                    chat.chatId = userId1;
                }
                chat.body           = [dictionary objectForKey:@"body"];
                [self requestSynChat:chat];
            }
        }
    } failBlock:^(IMResponse *response) {
//        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//        [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan请求失败" result:nil];
    }];
}

#pragma mark - 收到会话消息

- (void)receiveChatWithSession:(MessageBufSession *)session
{
    if (session && session.sessId > 0)
    {
        NSString *sid = @(session.sessId).stringValue;
        IMChat *chat  = [[IMChat alloc] init];
        chat.sessId   = sid;
        chat.lastMsgId  = @(session.msgId).stringValue;
        chat.lastMsgVer = @(session.msgVer).stringValue;
        chat.readVer = @(session.readVer).stringValue;
        chat.unread  = @(session.unReadNum).stringValue;
        chat.chatVer = @(session.sessVer).stringValue;
        
        [self requestReceiveChatDetail:chat];
    }
}

- (void)requestReceiveChatDetail:(IMChat *)chat
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:chat forKey:chat.sessId];
    [request requestChatDetail:chat.sessId header:_headerParam userInfo:userInfo finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            //            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
            //            [self responseOfChat:code msg:@"错误：接口getSessionsInfo返回数据为空" result:nil];
            return;
        }
        NSArray *list = [dic objectForKey:@"data"];
        for (NSDictionary *dictionary in list)
        {
            NSString *sessId = @([[dictionary objectForKey:@"SessId"] longLongValue]).stringValue;
            if (sessId.length)
            {
                IMChat *chat    = [response.userInfo objectForKey:sessId];
                chat.lastMsgUserId  = @([[dictionary objectForKey:@"LastUserId"] longLongValue]).stringValue;
                chat.lastMsgBody    = [dictionary objectForKey:@"Summary"];
                chat.lastMsgTime    = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
                chat.type           = [[dictionary objectForKey:@"Type"] intValue];
                NSString *userId1   = @([[dictionary objectForKey:@"UserId1"] longLongValue]).stringValue;
                NSString *userId2   = @([[dictionary objectForKey:@"UserId2"] longLongValue]).stringValue;
                if (!userId1.length || [_headerParam.userId isEqualToString:userId1])
                {
                    chat.chatId = userId2;
                } else if (!userId2.length || [_headerParam.userId isEqualToString:userId2])
                {
                    chat.chatId = userId1;
                }
                [self receiveSynChat:chat];
            }
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
    } failBlock:^(IMResponse *response) {
//        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//        [self responseOfChat:code msg:@"错误：接口getSessionsInfo请求失败" result:nil];
    }];
}

@end
