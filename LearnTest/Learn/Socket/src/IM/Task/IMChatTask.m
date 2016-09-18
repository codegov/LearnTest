//
//  IMChatTask.m
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMChatTask.h"
#import "IMRequestInterface.h"
#import "CDVJSON.h"
#import "IMChatManager.h"
#import "IMChatSynTask.h"

@interface IMChatTask ()
{
    IMChatSynTask *_synTask; // 会话同步任务
}
@end

@implementation IMChatTask


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _synTask = [[IMChatSynTask alloc] init];
    }
    return self;
}

#pragma mark - 响应

- (void)responseOfChat:(NSString *)code msg:(NSString *)msg result:(id)result
{
    IMResponse *response = [[IMResponse alloc] init];
    response.statusCode = code;
    response.statusCodeOfLocalizedString = msg;
    response.result = result;
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_ChatDidChange_Notification object:response];
}

- (void)setHeaderParam:(IMHeaderParam *)headerParam
{
    _headerParam = headerParam;
    _synTask.headerParam = headerParam;
}

- (void)receiveChatWithSession:(MessageBufSession *)session
{
    [_synTask receiveChatWithSession:session];
}

- (void)requestChatList
{
    [_synTask requestChatList];
}

//#pragma mark - 获取会话列表
//
//- (void)requestChatList
//{
//    IMRequestInterface *request = [[IMRequestInterface alloc] init];
//    [request requestChatDetailList:_headerParam.userId version:[_managerQueue queryMaxChatVersion] pageNum:@"1000" header:_headerParam finishBlock:^(IMResponse *response) {
//        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [content JSONObject];
//        if (!dic) {
//            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//            [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan返回数据为空" result:nil];
//            return;
//        }
//        
//        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
//        
//        NSArray *list = [dic objectForKey:@"data"];
//        for (NSDictionary *dictionary in list)
//        {
//            NSString *sid = @([[dictionary objectForKey:@"sessId"] longLongValue]).stringValue;
//            if (sid.length)
//            {
//                IMChat *chat     = [[IMChat alloc] init];
//                chat.sessId      = sid;
//                chat.lastMsgId   = @([[dictionary objectForKey:@"lastMsgId"] longLongValue]).stringValue;
//                chat.lastMsgVer  = @([[dictionary objectForKey:@"msgVer"] integerValue]).stringValue;
//                chat.readVer     = @([[dictionary objectForKey:@"readVer"] longLongValue]).stringValue;
//                chat.unread      = @([[dictionary objectForKey:@"unReadNum"] integerValue]).stringValue;
//                chat.chatVer     = @([[dictionary objectForKey:@"sessVer"] longLongValue]).stringValue;
//                
//                chat.lastMsgUserId  = @([[dictionary objectForKey:@"lastUserId"] longLongValue]).stringValue;
//                chat.lastMsgBody    = [dictionary objectForKey:@"summary"];
//                chat.lastMsgTime    = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
//                chat.type           = [[dictionary objectForKey:@"type"] intValue];
//                NSString *userId1   = @([[dictionary objectForKey:@"userId1"] longLongValue]).stringValue;
//                NSString *userId2   = @([[dictionary objectForKey:@"userId2"] longLongValue]).stringValue;
//                if (!userId1.length || [_headerParam.userId isEqualToString:userId1])
//                {
//                    chat.chatId = userId2;
//                } else if (!userId2.length || [_headerParam.userId isEqualToString:userId2])
//                {
//                    chat.chatId = userId1;
//                }
//                chat.body           = [dictionary objectForKey:@"body"];
//                [_managerQueue requestSynChat:chat];
//            }
//        }
//    } failBlock:^(IMResponse *response) {
//        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//        [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan请求失败" result:nil];
//    }];
//}
//
//- (void)receiveChatWithSession:(MessageBufSession *)session
//{
//    if (session && session.sessId > 0)
//    {
//        NSString *sid = @(session.sessId).stringValue;
//        IMChat *chat  = [[IMChat alloc] init];
//        chat.sessId   = sid;
//        chat.lastMsgId  = @(session.msgId).stringValue;
//        chat.lastMsgVer = @(session.msgVer).stringValue;
//        chat.readVer = @(session.readVer).stringValue;
//        chat.unread  = @(session.unReadNum).stringValue;
//        chat.chatVer = @(session.sessVer).stringValue;
//
//        [self requestReceiveChatDetail:chat];
//    }
//}

- (void)requestChatListWithVersion:(NSString *)version pageNum:(NSString *)pageNum
{
//    IMRequestInterface *request = [[IMRequestInterface alloc] init];
//    [request requestChatList:_headerParam.userId version:version pageNum:pageNum header:_headerParam finishBlock:^(IMResponse *response) {
//        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [content JSONObject];
//        if (!dic) {
//            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//            [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan返回数据为空" result:nil];
//            return;
//        }
//        NSArray *list = [dic objectForKey:@"data"];
//        for (NSDictionary *dictionary in list)
//        {
//            NSString *sid = @([[dictionary objectForKey:@"sessId"] longLongValue]).stringValue;
//            if (sid.length)
//            {
//                IMChat *chat = [[IMChat alloc] init];
//                chat.sessId  = sid;
//                chat.lastMsgId   = @([[dictionary objectForKey:@"lastMsgId"] longLongValue]).stringValue;
//                chat.lastMsgVer  = @([[dictionary objectForKey:@"msgVer"] integerValue]).stringValue;
//                chat.readVer = @([[dictionary objectForKey:@"readVer"] longLongValue]).stringValue;
//                chat.unread  = @([[dictionary objectForKey:@"unReadNum"] integerValue]).stringValue;
//                chat.chatVer = @([[dictionary objectForKey:@"sessVer"] longLongValue]).stringValue;
//                [_managerQueue addQueueWithChat:chat];
//            }
//        }
//        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
//    } failBlock:^(IMResponse *response) {
//        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//        [self responseOfChat:code msg:@"错误：接口getSessionQueueLaterThan请求失败" result:nil];
//    }];
}


//- (void)requestReceiveChatDetail:(IMChat *)chat
//{
//    IMRequestInterface *request = [[IMRequestInterface alloc] init];
//    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
//    [userInfo setObject:chat forKey:chat.sessId];
//    [request requestChatDetail:chat.sessId header:_headerParam userInfo:userInfo finishBlock:^(IMResponse *response) {
//        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [content JSONObject];
//        if (!dic) {
//            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//            [self responseOfChat:code msg:@"错误：接口getSessionsInfo返回数据为空" result:nil];
//            return;
//        }
//        NSArray *list = [dic objectForKey:@"data"];
//        for (NSDictionary *dictionary in list)
//        {
//            NSString *sessId = @([[dictionary objectForKey:@"SessId"] longLongValue]).stringValue;
//            if (sessId.length)
//            {
//                IMChat *chat    = [response.userInfo objectForKey:sessId];
//                chat.lastMsgUserId  = @([[dictionary objectForKey:@"LastUserId"] longLongValue]).stringValue;
//                chat.lastMsgBody    = [dictionary objectForKey:@"Summary"];
//                chat.lastMsgTime    = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
//                chat.type           = [[dictionary objectForKey:@"Type"] intValue];
//                NSString *userId1   = @([[dictionary objectForKey:@"UserId1"] longLongValue]).stringValue;
//                NSString *userId2   = @([[dictionary objectForKey:@"UserId2"] longLongValue]).stringValue;
//                if (!userId1.length || [_headerParam.userId isEqualToString:userId1])
//                {
//                    chat.chatId = userId2;
//                } else if (!userId2.length || [_headerParam.userId isEqualToString:userId2])
//                {
//                    chat.chatId = userId1;
//                }
//                [_managerQueue receiveSynChat:chat];
//            }
//        }
//        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
//    } failBlock:^(IMResponse *response) {
//        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
//        [self responseOfChat:code msg:@"错误：接口getSessionsInfo请求失败" result:nil];
//    }];
//}
//
//- (void)requestGetMsgIds:(NSString *)sessId version:(NSString *)version pageNum:(NSString *)pageNum
//{
//    IMRequestInterface *request = [[IMRequestInterface alloc] init];
//    [request requestGetMsgIds:sessId version:version pageNum:pageNum header:_headerParam finishBlock:^(IMResponse *response) {
//        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [content JSONObject];
//        if (!dic) {
////            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
////            [self responseOfChat:code msg:@"错误：接口getSessionsInfo返回数据为空" result:nil];
//            return;
//        }
//        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
//        NSArray *list = [dic objectForKey:@"data"];
//        NSMutableArray *ids = [[NSMutableArray alloc] init];
//        for (NSDictionary *dic in list)
//        {
//            NSString *mid = @([[dic objectForKey:@"MessageId"] longLongValue]).stringValue;
//            if (mid.length)
//            {
//                [ids addObject:mid];
//            }
//        }
//        [self requestGetMsgs:[ids componentsJoinedByString:@","]];
//        
//    } failBlock:^(IMResponse *response) {
//        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
//    }];
//}
//
//
//- (void)requestGetMsgs:(NSString *)msgIds
//{
//    IMRequestInterface *request = [[IMRequestInterface alloc] init];
//    [request requestGetMsgs:msgIds header:_headerParam finishBlock:^(IMResponse *response) {
//        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
//        NSDictionary *dic = [content JSONObject];
//        if (!dic) {
//            return;
//        }
//        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
//        
//    } failBlock:^(IMResponse *response) {
//        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
//    }];
//}

- (void)requestCreateGroup:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo memberIds:(NSString *)memberIds
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestCreateGroup:title subtitle:subtitle logo:logo memberIds:memberIds header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
    }];
}

- (void)requestInviteGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestInviteGroupMember:groupId sessId:sessId memberIds:memberIds header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
    }];
}

- (void)requestKickGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestKickGroupMember:groupId sessId:sessId memberIds:memberIds header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
    }];
}

- (void)requestLeaveGroup:(NSString *)groupId sessId:(NSString *)sessId
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestLeaveGroup:groupId sessId:sessId header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
    }];
}

- (void)requestUpdateGroup:(NSString *)groupId sessId:(NSString *)sessId title:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestUpdateGroup:groupId sessId:sessId title:title subtitle:subtitle logo:logo header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
    }];
}


@end
