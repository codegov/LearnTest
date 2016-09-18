//
//  IMChatManagerQueue.h
//  LearnTest
//
//  Created by syq on 15/6/1.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatManager.h"
#import "IMHeaderParam.h"
#import "Message.pb.h"

@interface IMChatSynTask : NSObject

@property (nonatomic, readwrite, strong) IMHeaderParam *headerParam;

- (void)requestChatList;
- (void)receiveChatWithSession:(MessageBufSession *)session;

@end
