//
//  IMChat.h
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMessage.h"

//类型
typedef enum
{
    CHAT_TYPE_COMMON  = 0,           //普通聊天
    CHAT_TYPE_GROUP   = 1,           //群组聊天
    CHAT_TYPE_PUSH    = 2,           //推送消息
    CHAT_TYPE_EVENT   = 3,           //事件
    CHAT_TYPE_SESSION = 4            //会话
} ChatType;

@interface IMChat : NSObject

@property (nonatomic, copy) NSString *beginMsgVer; // 本地获取得到的消息版本
@property (nonatomic, copy) NSString *endMsgVer;   // 本地获取得到的消息版本
@property (nonatomic, copy) NSString *lastMsgVer;  // 最后的消息版本
@property (nonatomic, copy) NSString *readVer;     // 最后上报已读的消息版本
@property (nonatomic, copy) NSString *chatVer;     // 会话版本
@property (nonatomic, copy) NSString *unread;      // 未读数

@property (nonatomic)       ChatType  type;         // 会话类型

@property (nonatomic, copy) NSString *lastMsgId;    // 最后消息的ID
@property (nonatomic, copy) NSString *lastMsgBody;  // 最后消息的内容
@property (nonatomic, copy) NSString *lastMsgTime;  // 最后消息的时间
@property (nonatomic, copy) NSString *lastMsgUserId;// 最后消息的发送者

@property (nonatomic, copy) NSString *sessId;       // 服务器会话ID
@property (nonatomic, copy) NSString *chatId;       // 单聊是对方的userId；群聊是groupId；系统\圈子\工作\其他ID

@property (nonatomic) NSInteger indexOfSort;        // 排序标
@property (nonatomic) BOOL      canDelete;          // 是否能删除

@property (nonatomic, copy) NSString *body;

- (void)copy:(IMChat *)chat;

@end
