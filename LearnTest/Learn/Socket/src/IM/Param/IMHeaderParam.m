//
//  IMHeaderParam.m
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMHeaderParam.h"
#import <CommonCrypto/CommonCryptor.h>

static Byte keyBytes[] =
{
    0x11, 0x22, 0x4F, 0x58,
    (char)0x88, 0x10, 0x40, 0x38,
    0x28, 0x25, 0x79, 0x51,
    (char)0xCB, (char)0xDD, 0x55, 0x66,
    0x77, 0x29, 0x74, (char)0x98,
    0x30, 0x40, 0x36, (char)0xE2
};

@implementation IMHeaderParam

- (NSDictionary *)paramDictionary
{
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    [headerDic setObject:self.encoder forKey:@"Authorization"];
    return headerDic;
}

- (NSString *)encoder
{
    NSString *authorization = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",
                               self.userId,
                               self.deviceType,
                               self.deviceId,
                               self.token,
                               self.lastLoginTime,
                               self.appVer,
                               self.appId];
    return [IMHeaderParam encrypt:authorization];
}

//字节数组转化16进制数
+ (NSString *)parseByteHexString:(Byte[])bytes
{
    NSMutableString *hexStr = [[NSMutableString alloc] init];
    int i = 0;
    
    if (bytes)
    {
        while (bytes[i] != '\0')
        {
            //16进制数
            NSString *hexByte = [NSString stringWithFormat:@"%x", bytes[i] & 0xff];
            if (1 == [hexByte length])
            {
                [hexStr appendFormat:@"0%@", hexByte];
            }
            else
            {
                [hexStr appendFormat:@"%@", hexByte];
            }
            
            i++;
        }
    }
    
    return [hexStr uppercaseString];
}

//将16进制数据转化成NSData数组
+ (NSData *)parseHexToByteData:(NSString *)hexString
{
    int j = 0;
    Byte bytes[hexString.length];
    
    for (int i = 0; i < [hexString length]; i++)
    {
        int int_ch; //两位16进制数转化后的10进制数
        unichar hex_char_h = [hexString characterAtIndex:i];    //两位16进制数中的第一位(高位*16)
        int int_ch_h;
        
        if (hex_char_h >= '0' && hex_char_h <= '9')
        {
            //0的AscII-48
            int_ch_h = (hex_char_h - 48) * 16;
        }
        else if (hex_char_h >= 'A' && hex_char_h <= 'F')
        {
            //A的AscII-65
            int_ch_h = (hex_char_h - 55) * 16;
        }
        else
        {
            //a的AscII-97
            int_ch_h = (hex_char_h - 87) * 16;
        }
        
        i++;
        
        unichar hex_char_l = [hexString characterAtIndex:i];    //两位16进制数中的第二位(低位)
        int int_ch_l;
        
        if (hex_char_l >= '0' && hex_char_l <= '9')
        {
            //0的AscII-48
            int_ch_l = (hex_char_l - 48);
        }
        else if (hex_char_l >= 'A' && hex_char_l <= 'F')
        {
            //A的AscII-65
            int_ch_l = hex_char_l - 55;
        }
        else
        {
            //a的AscII-97
            int_ch_l = hex_char_l - 87;
        }
        
        int_ch = int_ch_h + int_ch_l;
        bytes[j] = int_ch;  //将转化后的数放入Byte数组里
        
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    
    return newData;
}



//加密
+ (NSString *)encrypt:(NSString *)text
{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x00, bufferPtrSize);
    
    const void *vkey = (const void *)keyBytes;
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *resultData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    if (bufferPtr)
    {
        free(bufferPtr);
    }
    
    //将data转成16进制字符串
    NSString *string = [resultData description];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [string uppercaseString];
}

//解密
+ (NSString *)decrypt:(NSString *)text
{
    NSData *encryptData = [self parseHexToByteData:text];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x00, bufferPtrSize);
    
    const void *vkey = (const void *)keyBytes;
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    if (bufferPtr)
    {
        free(bufferPtr);
    }
    
    return result;
}

@end
