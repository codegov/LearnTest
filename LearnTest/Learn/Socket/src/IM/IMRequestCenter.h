//
//  IMRequestCenter.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMConfig.h"
#import "IMResponse.h"
#import "IMLoginParam.h"
#import "IMChat.h"
#import "IMMessage.h"
#import "IMGroupInfo.h"
#import "IMGroupMember.h"

@interface IMRequestCenter : NSObject

+ (IMRequestCenter *)defaultCenter;

#pragma mark - 登录相关接口

- (void)requestLoginWithParam:(IMLoginParam *)param; // 登录
- (void)requestLogoutWithUserName:(NSString *)name password:(NSString *)password; // 登出

#pragma mark - 会话相关接口

- (void)requestChatList; // 会话列表

#pragma mark - 消息相关接口

- (void)setCurrentChat:(IMChat *)chat;  // 设置当前会话
- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId; // 发消息，sessId没有，可以为空
- (void)requestReSendMsg:(IMMessage *)msg sessId:(NSString *)sessId; // 重发消息
- (BOOL)isSendingMsg:(NSString *)msgId; // 是否是正在发送的消息
- (BOOL)isFailedMsg:(NSString *)msgId;  // 是否是发送失败的消息

#pragma mark - 群聊相关

- (void)requestCreateGroup:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo memberIds:(NSString *)memberIds;
- (void)requestInviteGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds;
- (void)requestKickGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds;
- (void)requestLeaveGroup:(NSString *)groupId sessId:(NSString *)sessId;
- (void)requestUpdateGroup:(NSString *)groupId sessId:(NSString *)sessId title:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo;

- (IMGroupInfo *)queryGroupInfo:(NSString *)groupId;
- (NSArray *)queryGroupMembers:(NSString *)groupId;
- (BOOL)isGroupMember:(NSString *)groupId userId:(NSString *)userId;

@end
