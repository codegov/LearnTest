//
//  IMSocket.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSocket : NSObject

@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *creatTime;

- (IMSocket *)initWithDictionary:(NSDictionary *)dictionary;

+ (BOOL)saveWithSocket:(IMSocket *)socket userName:(NSString *)name password:(NSString *)password;
+ (IMSocket *)queryWithUserName:(NSString *)name password:(NSString *)password;
+ (BOOL)removeWithUserName:(NSString *)name password:(NSString *)password;

@end
