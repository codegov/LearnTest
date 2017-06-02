//
//  PingImp.m
//  LearnTest
//
//  Created by javalong on 2017/6/1.
//  Copyright © 2017年 com.chanjet. All rights reserved.
//

#import "PingImp.h"
#include "Ping.hpp"

@implementation PingImp

+ (void)ping
{
//    Ping().pingImp();
    
    NSString *yourcmd = [NSString stringWithFormat: @"ping -c 2 -i 1 -t 4 www.qq.com"];
    NSString *output = [self executeCommand: yourcmd];
    NSLog(@"命令结果为：%@", output);
}

+ (NSString *)executeCommand:(NSString *)cmd
{
    NSString *output = [NSString string];
    FILE *pipe = popen([cmd cStringUsingEncoding: NSASCIIStringEncoding], "r");
    if (!pipe) return nil;
    
    char buf[1024];
    while(fgets(buf, 1024, pipe)) {
        output = [output stringByAppendingFormat: @"%s", buf];
    }
    pclose(pipe);
    return output;
}



@end
