//
//  IMChatData.h
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChat.h"
#import "IMConfig.h"


@interface IMChatMem : NSObject

- (void)addChat:(IMChat *)chat;
- (void)addChats:(NSArray *)array;
- (void)deleteChat:(NSString *)chatId;
- (void)updateChat:(IMChat *)chat;
- (NSArray *)queryChats;

- (void)addOrupdateChat:(IMChat *)chat;

@end
