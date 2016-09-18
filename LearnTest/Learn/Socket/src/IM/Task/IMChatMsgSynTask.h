//
//  IMChatSynTask.h
//  LearnTest
//
//  Created by syq on 15/6/2.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMHeaderParam.h"
#import "IMChat.h"

@class IMChatMsgSynTask;

@protocol IMChatMsgSynTaskDelegate <NSObject>

- (void)chatMsgSynTaskSuccess:(IMChatMsgSynTask *)task;       // 同步会话消息
- (void)chatMsgSynTaskFail:(IMChatMsgSynTask *)task;

@end

@interface IMChatMsgSynTask : NSObject

@property (nonatomic, weak) id<IMChatMsgSynTaskDelegate> delegate;

@property (nonatomic, strong) IMChat *chat;
@property (nonatomic) int chatSynType;

- (void)requestGetMsgIds:(NSString *)sessId version:(NSString *)version pageNum:(NSString *)pageNum headerParam:(IMHeaderParam *)headerParam;
- (void)requestGetMsgs:(NSString *)msgIds headerParam:(IMHeaderParam *)headerParam;

@end
