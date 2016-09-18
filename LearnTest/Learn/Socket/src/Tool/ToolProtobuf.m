//
//  ToolProtobuf.m
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "ToolProtobuf.h"

@implementation ToolProtobuf

+ (NSData *)encodeMessageBuf:(MessageBuf *)buf  // 编码
{
    NSLog(@"encodeMessageBuf ==%@", buf);
    NSData *bufData = [buf data];
    size_t preLen   = sizeof(short);//short类型字节长度
    size_t allLen   = bufData.length + preLen; // 总长度
    char *a = (char*)malloc(sizeof(Byte) * allLen); // 开辟一块长度为allLen字节的内存
    *((short*)a) = htons(bufData.length); // a前preLen(short类型)长度的内存赋值
    memcpy((void *)a + preLen, bufData.bytes, bufData.length); // a前preLen(short类型)长度之后的内存赋值
    NSData *data1 = [NSData dataWithBytes:a length:allLen]; // a转data
    return data1;
}

+ (MessageBuf *)decodeData:(NSData *)data       // 解码
{
    size_t preLen = sizeof(short);
    const char *a = [data bytes];
    short len = ntohs(*((short*)a));
    NSData *data1 = [NSData dataWithBytes:(a + preLen) length:len];
    MessageBuf *pbuf = [MessageBuf parseFromData:data1];
    NSLog(@"decodeData ==%@", pbuf);
    return pbuf;
}


@end
