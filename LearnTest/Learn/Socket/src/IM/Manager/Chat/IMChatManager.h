//
//  IMChatManager.h
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChat.h"
#import "IMGroupInfo.h"
#import "IMGroupMember.h"

@interface IMChatManager : NSObject

#pragma mark - 会话

- (void)saveOrUpdateChatWithSendMsg:(IMMessage *)msg;       // 发送消息更新或创建会话
- (void)updateChatWithReceiveMsg:(IMMessage *)msg;          // 接收到消息更新会话
- (void)saveOrUpdateChat:(IMChat *)chat;                    // 更新或保存会话
- (void)saveOrUpdateChats:(NSArray *)array;
- (void)deleteChat:(NSString *)chatId;
- (IMChat *)queryChat:(NSString *)chatId;
- (NSArray *)queryChats;

#pragma mark - 群聊基本信息

- (void)saveGroupInfo:(IMGroupInfo *)info;
- (void)updateGroupNameWithWithChatId:(NSString *)chatId name:(NSString *)name;
- (IMGroupInfo *)queryGroupInfoWithChatId:(NSString *)chatId;

#pragma mark - 群聊成员

- (void)saveGroupMember:(IMGroupMember *)member;
- (void)removeGroupMemberWithChatId:(NSString *)chatId memberIds:(NSArray *)memberIds;
- (void)addGroupMemberWithChatId:(NSString *)chatId memberIds:(NSArray *)memberIds;
- (NSArray *)queryGroupMembersWithChatId:(NSString *)chatId;

@end
