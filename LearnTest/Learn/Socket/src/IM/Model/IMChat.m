//
//  IMChat.m
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMChat.h"

@implementation IMChat

- (void)copy:(IMChat *)chat
{
    self.beginMsgVer = chat.beginMsgVer;
    self.endMsgVer   = chat.endMsgVer;
    self.lastMsgVer  = chat.lastMsgVer;
    self.readVer     = chat.readVer;
    self.unread      = chat.unread;
    self.chatVer     = chat.chatVer;
    
    self.type        = chat.type;
    
    self.lastMsgId   = chat.lastMsgId;
    self.lastMsgUserId = chat.lastMsgUserId;
    self.lastMsgBody = chat.lastMsgBody;
    self.lastMsgTime = chat.lastMsgTime;
    
    self.sessId      = chat.sessId;
    self.chatId      = chat.chatId;
}

@end
