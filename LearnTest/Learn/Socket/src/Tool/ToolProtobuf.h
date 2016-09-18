//
//  ToolProtobuf.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.pb.h"

@interface ToolProtobuf : NSObject

+ (NSData *)encodeMessageBuf:(MessageBuf *)buf;  // 编码
+ (MessageBuf *)decodeData:(NSData *)data;       // 解码

@end
