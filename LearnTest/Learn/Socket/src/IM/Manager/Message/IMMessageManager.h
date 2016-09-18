//
//  IMMessageManager.h
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessage.h"
#import "IMChat.h"

@interface IMMessageManager : NSObject

@property (nonatomic, strong) IMChat *currentChat;

- (void)sendMessage:(IMMessage *)msg;
- (void)sendMessageSuccess:(IMMessage *)msg;
- (void)sendMessageFail:(NSString *)msgId code:(NSString *)code errstring:(NSString*)errstring;
- (void)sendMessageMediaSuccess:(NSString *)msgId path:(NSString *)path;

- (void)resendMessage:(IMMessage *)msg;  // 重发消息
- (void)readedMessage:(IMMessage *)msg;  // 读了消息
- (void)receiveMessage:(IMMessage *)msg; // 收到消息
- (void)saveOrUpdateMessage:(IMMessage *)msg;

- (BOOL)isSendingMsg:(NSString *)msgId; // 是否是正在发送的消息
- (BOOL)isFailedMsg:(NSString *)msgId;  // 是否是发送失败的消息

- (IMMessage *)queryMesage:(NSString *)msgId;
- (NSArray *)queryMesages;

@end
