//
//  IMChatTask.h
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChat.h"
#import "IMConfig.h"
#import "IMHeaderParam.h"
#import "Message.pb.h"

@interface IMChatTask : NSObject

@property (nonatomic, readwrite, strong) IMHeaderParam *headerParam;

- (void)receiveChatWithSession:(MessageBufSession *)session;
- (void)requestChatList;

- (void)requestCreateGroup:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo memberIds:(NSString *)memberIds;
- (void)requestInviteGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds;
- (void)requestKickGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds;
- (void)requestLeaveGroup:(NSString *)groupId sessId:(NSString *)sessId;
- (void)requestUpdateGroup:(NSString *)groupId sessId:(NSString *)sessId title:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo;

@end
