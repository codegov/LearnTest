//
//  IMRequestURL.h
//  LearnTest
//
//  Created by syq on 15/5/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMRequestURL : NSObject

@property (nonatomic, strong) NSString *domain;    // 域名
@property (nonatomic, strong) NSString *catalog;   // 目录

@property (nonatomic, strong) NSString *pathOfLoginWithUserName;
@property (nonatomic, strong) NSString *pathOfLoginWithToken;    // 获取socket连接需要的数据
@property (nonatomic, strong) NSString *pathOfSendMessage;       // 发消息
@property (nonatomic, strong) NSString *pathOfGetMsgs;           // 根据消息ID得到消息内容
@property (nonatomic, strong) NSString *pathOfGetMsgIds;         // 获取消息ID
@property (nonatomic, strong) NSString *pathOfChatList;
@property (nonatomic, strong) NSString *pathOfChatDetail;
@property (nonatomic, strong) NSString *pathOfChatDetailList;

@property (nonatomic, strong) NSString *pathOfCreateGroup;        // 创建群聊
@property (nonatomic, strong) NSString *pathOfInviteGroupMember;  // 邀请群成员
@property (nonatomic, strong) NSString *pathOfKickGroupMember;    // 踢群成员
@property (nonatomic, strong) NSString *pathOfLeaveGroup;         // 离开群聊
@property (nonatomic, strong) NSString *pathOfUpdateGroup;        // 更新群聊

@end
