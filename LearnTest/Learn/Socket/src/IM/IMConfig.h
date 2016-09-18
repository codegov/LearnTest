//
//  IMConfig.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#ifndef LearnTest_IMConfig_h
#define LearnTest_IMConfig_h

#define IM_LoginDidChange_Notification         @"IM_LoginDidChange_Notification"         // 登录
#define IM_ChatDidChange_Notification          @"IM_ChatDidChange_Notification"          // 会话
#define IM_MessageDidChange_Notification       @"IM_MessageDidChange_Notification"       // 消息
#define IM_MessageOfSendOrReceive_Notification @"IM_MessagefSendOrReceive_Notification"  // 发送消息或者接收到消息

#define IM_SUCCESS 0
#define IM_ERROR   1

#define IM_ERROR_LOGIN                  7001 //登录：失败
#define IM_ERROR_USERORPASSWORD_LOGIN   7002 //登录：用户名密码出错
#define IM_ERROR_PARAM                  7003 //传入参数错误
#define IM_ERROR_SERVER                 7004 //调用服务错误
#define IM_ERROR_NETWORKORSERVER        7005 //网络或服务异常，请稍后再试
#define IM_ERROR_MSG_REPEAT             7006 //消息重复
#define IM_ERROR_APNS                   7007 //处理apns设备失败
#define IM_ERROR_KICK                   7008 //处理终端互踢失败
#define IM_ERROR_USERAUTH_LGOIN         7009 //登录：认证失败
#define IM_ERROR_NOUSER_LOGIN           7010 //登录：没有该用户
#define IM_ERROR_TOKEN_LOGIN            7011 //登录：token验证失败


//sys(60000001951L, 0), // 系统消息
//team(60000001952L, 1), // 圈子消息
//app(50000001000L, 2), // 工作消息
//t(50000001001L, 3), // T+消息
//
//// 工作消息，拆分为各个轻应用的消息
//enterpriseAddList(50000001004L, 4), // 企业通讯录
//approval(50000001005L, 5), // 审批
//vacation(50000001006L, 6), // 请假
//reimbursement(50000001007L, 7), // 报销
//loan(50000001008L, 8), // 借款
//upcoming(50000001009L, 9), // 即将推出
//checkin(50000001010L, 10), // 外勤签到
//todo(50000001011L, 11), // 任务
//notice(50000001012L, 12), // 公告
//tplusapproval(50000001013L, 13), // T+审批
//customermanager(50000001014L, 14), // 客户管家
//dhhy(50000001015L, 15), // 电话会议
//tplussubscriberlist(50000001016L, 16); // T+订阅列表

//#define IM_ChatId_Type_Sys   @"60000001951"
//#define IM_ChatId_Type_Team  @""
//#define IM_ChatId_Type_Work  @""
//#define IM_ChatId_Type_TPlus @""
//#define IM_ChatId_Type_Sys   @""

#endif
