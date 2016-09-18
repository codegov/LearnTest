//
//  IMMessageTask.h
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChat.h"
#import "IMConfig.h"
#import "IMHeaderParam.h"
#import "IMMessageManager.h"

@interface IMMessageTask : NSObject

@property (nonatomic, readwrite, strong) IMHeaderParam *headerParam;
@property (nonatomic, readonly, strong) IMMessageManager *messageManager;

- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId;
- (void)requestReSendMsg:(IMMessage *)msg sessId:(NSString *)sessId; // 重发消息

@end
