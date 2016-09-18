//
//  IMSocket.m
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMSocket.h"

@implementation IMSocket

- (IMSocket *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.host = [dictionary objectForKey:@"host"];
        self.port = @([[dictionary objectForKey:@"port"] integerValue]).stringValue;
        self.token = [dictionary objectForKey:@"token"];
        self.userId = @([[dictionary objectForKey:@"userId"] longLongValue]).stringValue;
        self.creatTime = @([NSDate date].timeIntervalSince1970 * 1000 * 1000).stringValue;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [coder encodeObject:self.host forKey:@"host"];
//    [coder encodeObject:self.port forKey:@"port"];
    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.creatTime forKey:@"creatTime"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
//        self.host = [coder decodeObjectForKey:@"host"];
//        self.port = [coder decodeObjectForKey:@"port"];
        self.token = [coder decodeObjectForKey:@"token"];
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.creatTime = [coder decodeObjectForKey:@"creatTime"];
    }
    return self;
}

+ (BOOL)saveWithSocket:(IMSocket *)socket userName:(NSString *)name password:(NSString *)password
{
    if (!socket) return NO;
    if (!name.length && !password.length) return NO;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:socket];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[NSString stringWithFormat:@"%@_%@", name, password]];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (IMSocket *)queryWithUserName:(NSString *)name password:(NSString *)password
{
    if (!name.length && !password.length) return nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@", name, password]];
    if (data.length)
    {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

+ (BOOL)removeWithUserName:(NSString *)name password:(NSString *)password
{
    if (!name.length && !password.length) return NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@", name, password]];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
