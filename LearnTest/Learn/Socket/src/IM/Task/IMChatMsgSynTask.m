//
//  IMChatSynTask.m
//  LearnTest
//
//  Created by syq on 15/6/2.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMChatMsgSynTask.h"
#import "CDVJSON.h"
#import "IMRequestInterface.h"

@implementation IMChatMsgSynTask

- (void)chatMsgSynTaskSuccess
{
    if ([_delegate respondsToSelector:@selector(chatMsgSynTaskSuccess:)]) {
        [_delegate chatMsgSynTaskSuccess:self];
    }
}

- (void)chatMsgSynTaskFail
{
    if ([_delegate respondsToSelector:@selector(chatMsgSynTaskFail:)]) {
        [_delegate chatMsgSynTaskFail:self];
    }
}


- (void)requestGetMsgIds:(NSString *)sessId version:(NSString *)version pageNum:(NSString *)pageNum headerParam:(IMHeaderParam *)headerParam
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestGetMsgIds:sessId version:version pageNum:pageNum header:headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            //            NSString *code = response.statusCode.length ? response.statusCode : @(IM_ERROR).stringValue;
            //            [self responseOfChat:code msg:@"错误：接口getSessionsInfo返回数据为空" result:nil];
            [self chatMsgSynTaskFail];
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"errorMsg"]);
        NSArray *list = [dic objectForKey:@"data"];
        NSMutableArray *ids = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in list)
        {
            NSString *mid = @([[dic objectForKey:@"MessageId"] longLongValue]).stringValue;
            if (mid.length)
            {
                [ids addObject:mid];
            }
        }
        [self requestGetMsgs:[ids componentsJoinedByString:@","] headerParam:headerParam];
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
        [self chatMsgSynTaskFail];
    }];
}


- (void)requestGetMsgs:(NSString *)msgIds headerParam:(IMHeaderParam *)headerParam
{
    IMRequestInterface *request = [[IMRequestInterface alloc] init];
    [request requestGetMsgs:msgIds header:headerParam finishBlock:^(IMResponse *response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) {
            [self chatMsgSynTaskFail];
            return;
        }
        NSLog(@"dic=%@ %@", dic, [dic objectForKey:@"msg"]);
        
        [self chatMsgSynTaskSuccess];
        
    } failBlock:^(IMResponse *response) {
        NSLog(@"%@  %@", response.statusCode, response.statusCodeOfLocalizedString);
        [self chatMsgSynTaskFail];
    }];
}











@end
