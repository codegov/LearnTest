//
//  IMGroupMember.h
//  LearnTest
//
//  Created by syq on 15/5/28.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMGroupMember : NSObject

@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *joinTime;
@property (nonatomic, strong) NSString *remarkName; // 群聊的别名
@property (nonatomic, strong) NSString *role;       // 1:创建者 0:成员

@end
