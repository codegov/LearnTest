//
//  IMMessage.h
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    IMMessageMediaTypeText = 0,
    IMMessageMediaTypeImage,
    IMMessageMediaTypeAudio,
    IMMessageMediaTypeVideo,
    IMMessageMediaTypeFile,
    IMMessageMediaTypeNotify,
    IMMessageMediaTypeCommand,      // IM命令消息
    IMMessageMediaTypeUnknown,
    IMMessageMediaTypeSubSys = 20,  //系统消息
    IMMessageMediaTypeSubTeam,      //圈子消息
    IMMessageMediaTypeSubTPlus,     //T+消息
    IMMessageMediaTypeSubTask,      //任务消息
    IMMessageMediaTypeSubApprocal,  //审批消息
    IMMessageMediaTypeSubNotice,    //公告消息
    IMMessageMediaTypeSubFile,      //文件柜消息
    IMMessageMediaTypeSubLeave      //请假消息
} IMMessageMediaType;

typedef enum {
    IMGroupChatCommandNone = 0,
    IMGroupChatCommandInvite,
    IMGroupChatCommandRemove,
    IMGroupChatCommandLeave,
    IMGroupChatCommandRename
} IMGroupChatCommandType;

@interface IMMessage : NSObject

@property (nonatomic, copy) NSString *to;      // 接收者
@property (nonatomic, copy) NSString *from;    // 发送者

@property (nonatomic, copy) NSString *clientTime; // 本地消息时间
@property (nonatomic, copy) NSString *msgCid;     // 本地给服务器的判重消息ID
@property (nonatomic, copy) NSString *serverTime; // 服务器时间
@property (nonatomic, copy) NSString *msgSid;     // 服务器消息ID

@property (nonatomic, copy) NSString *body;       // 消息内容

@property (nonatomic)       IMMessageMediaType mediaType;    // 多媒体信息
@property (nonatomic, copy) NSNumber *mediaWidth;
@property (nonatomic, copy) NSNumber *mediaHeight;
@property (nonatomic, copy) NSString *mediaPath;
@property (nonatomic, copy) NSNumber *mediaLenght;
@property (nonatomic, copy) NSNumber *mediaTime;

@property (nonatomic)       IMGroupChatCommandType cmdType;  // 群聊操作指令类型
@property (nonatomic, copy) NSNumber *readed;         // 是否已读
@property (nonatomic, copy) NSNumber *failed;         // 是否发送失败


@end
