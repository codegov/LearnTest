//
//  IMGroupInfo.h
//  LearnTest
//
//  Created by syq on 15/5/28.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMGroupInfo : NSObject

@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *createUserId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *maxUserNum;
@property (nonatomic, strong) NSString *curUserNum;


@end
