//
//  IMMessage.m
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMMessage.h"

@implementation IMMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.cmdType = IMGroupChatCommandNone;
    }
    return self;
}

@end
