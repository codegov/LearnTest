//
//  IMLoginParam.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMLoginParam : NSObject

@property (nonatomic, strong) NSString *username;    // 用户账号，不能空
@property (nonatomic, strong) NSString *password;    // 用户密码，不能为空
@property (nonatomic, strong) NSString *loginType;   // 登录类型 1：手动 0：自动，不能为空
@property (nonatomic, strong) NSString *userId;      // 用户ID，不能为空
@property (nonatomic, strong) NSString *appId;       // 应用ID，不能为空
@property (nonatomic, strong) NSString *appVersion;  // 应用版本，不能为空
@property (nonatomic, strong) NSString *deviceType;  // 设备类型 @"IPH"：iphone，不能为空
@property (nonatomic, strong) NSString *deviceToken; // 设备Token，不能为空
@property (nonatomic, strong) NSString *deviceId;    // 设备UUID，不能为空

@end
