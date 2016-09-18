//
//  IMRequestURL.m
//  LearnTest
//
//  Created by syq on 15/5/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMRequestURL.h"

@implementation IMRequestURL

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _domain  = @"http://172.18.22.20";
        _catalog = @"/api/rest/";
    }
    return self;
}

- (NSString *)pathOfLoginWithUserName
{
    return [NSString stringWithFormat:@"%@%@getProfile", _domain, _catalog];
}

- (NSString *)pathOfLoginWithToken
{
    return [NSString stringWithFormat:@"%@%@getProfileByToken", _domain, _catalog];
}

- (NSString *)pathOfSendMessage
{
    return @"http://172.18.22.14:30103/chat/rest/sendMsg";
}

- (NSString *)pathOfGetMsgs
{
    return @"http://172.18.22.14:30103/chat/rest/getMsgs";
}

- (NSString *)pathOfGetMsgIds
{
    return @"http://172.18.22.119:8080/imp_session_rest/imp/session/rest/msgqueue/getMessageQueueLaterThan";
}

- (NSString *)pathOfChatList
{
    return @"http://172.18.22.119:8080/imp_session_rest/imp/session/rest/sessqueue/getSessionQueueLaterThan";
}

- (NSString *)pathOfChatDetail
{
    return @"http://172.18.22.119:8080/imp_session_rest/imp/session/rest/sessentity/getSessionsInfo";
}

- (NSString *)pathOfChatDetailList
{
    return @"http://172.18.22.119:8080/imp_session_rest/imp/session/rest/sessentity/getSessionQueueLaterThanWithEntity";
}

//@property (nonatomic, strong) NSString *pathOfCreateGroup;        // 创建群聊
//@property (nonatomic, strong) NSString *pathOfInviteGroupMember;  // 邀请群成员
//@property (nonatomic, strong) NSString *pathOfKickGroupMember;    // 踢群成员
//@property (nonatomic, strong) NSString *pathOfLeaveGroup;         // 离开群聊
//@property (nonatomic, strong) NSString *pathOfUpdateGroup;        // 更新群聊


- (NSString *)pathOfCreateGroup
{
    return @"http://172.18.22.14:30104/groupchat/rest/createGroup";
}

- (NSString *)pathOfInviteGroupMember
{
    return @"http://172.18.22.14:30104/groupchat/rest/inviteGroupMem";
}

- (NSString *)pathOfKickGroupMember
{
    return @"http://172.18.22.14:30104/groupchat/rest/kickGroupMem";
}

- (NSString *)pathOfLeaveGroup
{
    return @"http://172.18.22.14:30104/groupchat/rest/leaveGroup";
}


@end
