//
//  IMLoginTask.h
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMConfig.h"
#import "IMLoginParam.h"
#import "IMMessageTask.h"

typedef enum {
    IMLoginStateHttpStart     = 1,
    IMLoginStateHttpDoing     = 2,
    IMLoginStateHttpSuccess   = 3,
    IMLoginStateSocketStart   = 4,
    IMLoginStateSocketDoing   = 5,
    IMLoginStateSocketSuccess = 6
} IMLoginState;

@interface IMLoginTask : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (void)requestLoginWithParam:(IMLoginParam *)param;
- (void)requestLogout;

@property (nonatomic, readwrite, strong) IMMessageTask *messageTask;
@property (nonatomic, readwrite, strong) IMHeaderParam *headerParam;

@end
