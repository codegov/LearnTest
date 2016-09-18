//
//  IMHeaderParam.h
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMHeaderParam : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *appId;      //
@property (nonatomic, strong) NSString *appVer;
@property (nonatomic, strong) NSString *deviceType; // 设备类型
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *lastLoginTime;


- (NSDictionary *)paramDictionary;

@end
