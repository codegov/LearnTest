//
//  IMMessageTask.m
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMMessageTask.h"
#import "IMRequestInterface.h"
#import "CDVJSON.h"

@implementation IMMessageTask

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _messageManager = [[IMMessageManager alloc] init];
    }
    return self;
}

#pragma mark - 请求响应

//- (void)responseOfSend:(NSString *)code msg:(NSString *)msg
//{
//    IMResponse *response = [[IMResponse alloc] init];
//    response.statusCode = code;
//    response.statusCodeOfLocalizedString = msg;
//    [[NSNotificationCenter defaultCenter] postNotificationName:IM_MESSAGEDIDCHANGE_NOTIFICATION object:response];
//}

- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId
{
    [_messageManager sendMessage:msg];
    
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestSendMsg:msg sessId:sessId header:_headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            
            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
            [_messageManager sendMessageFail:msg.msgCid code:code errstring:@"发送消息接口返回数据为空"];return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == IM_SUCCESS)
        {
            NSDictionary *dic1 = [dic objectForKey:@"data"];
            msg.msgSid = @([[dic1 objectForKey:@"msgId"] longLongValue]).stringValue;
            msg.serverTime = @([[dic1 objectForKey:@"serverTime"] longLongValue]).stringValue;
            msg.failed = @(NO);
            [_messageManager sendMessageSuccess:msg];
        } else
        {
            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
            [_messageManager sendMessageFail:msg.msgCid code:code errstring:@"发送消息接口返回服务器错误码"];
        }
    } failBlock:^(IMResponse *response) {
        NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
        [_messageManager sendMessageFail:msg.msgCid code:code errstring:@"发送消息接口请求失败"];
    }];
}

- (void)requestReSendMsg:(IMMessage *)msg sessId:(NSString *)sessId // 重发消息
{
    [_messageManager resendMessage:msg];
    [self requestSendMsg:msg sessId:sessId];
}

@end
