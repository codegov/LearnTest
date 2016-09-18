//
//  IMRequestCenter.h
//  LearnTest
//
//  Created by syq on 15/5/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMRequest.h"
#import "IMLoginParam.h"
#import "IMMessage.h"
#import "IMHeaderParam.h"

@interface IMRequestInterface : NSObject

@property (nonatomic, readonly, strong) IMRequest *request;

- (void)requestLoginWithParam:(IMLoginParam *)param finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestLoginWithToken:(NSString *)token userId:(NSString *)userId param:(IMLoginParam *)param finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestChatList:(NSString *)userId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestChatDetail:(NSString *)sessIds header:(IMHeaderParam *)header userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestChatDetailList:(NSString *)userId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestGetMsgIds:(NSString *)sessId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestGetMsgs:(NSString *)msgIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestCreateGroup:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestInviteGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestKickGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestLeaveGroup:(NSString *)groupId sessId:(NSString *)sessId header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)requestUpdateGroup:(NSString *)groupId sessId:(NSString *)sessId title:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;


@end
