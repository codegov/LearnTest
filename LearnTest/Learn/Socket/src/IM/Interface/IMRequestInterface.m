//
//  IMRequestCenter.m
//  LearnTest
//
//  Created by syq on 15/5/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMRequestInterface.h"
#import "IMRequestURL.h"

@interface IMRequestInterface ()

@end

@implementation IMRequestInterface

- (void)requestLoginWithParam:(IMLoginParam *)param finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    NSString *path = [NSString stringWithFormat:@"?username=%@&password=%@&loginType=%@&appId=%@&appVer=%@&deviceType=%@&deviceToken=%@&deviceId=%@", param.username, param.password, param.loginType, param.appId, param.appVersion, param.deviceType, param.deviceToken, param.deviceId];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfLoginWithUserName, path];
    NSLog(@"path == %@", path);
    _request = [[IMRequest alloc] init];
    [_request getAsynRequest:path headerDic:nil userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestLoginWithToken:(NSString *)token userId:(NSString *)userId param:(IMLoginParam *)param finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    NSString *path = [NSString stringWithFormat:@"?token=%@&userId=%@&loginType=%@&appId=%@&appVer=%@&deviceType=%@&deviceToken=%@&deviceId=%@", token, userId, param.loginType, param.appId, param.appVersion, param.deviceType, param.deviceToken, param.deviceId];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfLoginWithToken, path];
    NSLog(@"path == %@", path);
    _request = [[IMRequest alloc] init];
    [_request getAsynRequest:path headerDic:nil userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestSendMsg:(IMMessage *)msg sessId:(NSString *)sessId header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
    if (msg.to.length) {
        [params addObject:[NSString stringWithFormat:@"to=%@", msg.to]];
    }
    if (msg.clientTime.length) {
        [params addObject:[NSString stringWithFormat:@"clientTime=%@", msg.clientTime]];
    }
    if (!sessId.length) {
        sessId = @"0";
    }
    [params addObject:[NSString stringWithFormat:@"sessId=%@", sessId]];
    
    [params addObject:[NSString stringWithFormat:@"subType=%@", @(msg.mediaType).stringValue]];
    
    if (msg.body.length) {
        [params addObject:[NSString stringWithFormat:@"body=%@", msg.body]];
    }
    if (msg.msgCid.length) {
        [params addObject:[NSString stringWithFormat:@"cMsgId=%@", msg.msgCid]];
    }
    if (header.appId.length) {
        [params addObject:[NSString stringWithFormat:@"appId=%@", header.appId]];
    }
    NSString *body = [params componentsJoinedByString:@"&"];
    NSLog(@"path == %@", url.pathOfSendMessage);
    NSLog(@"body == %@", body);
    [_request postAsynRequest:url.pathOfSendMessage body:body headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestChatList:(NSString *)userId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?userId=%@&version=%@&limit=%@", userId, version, pageNum];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfChatList, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestChatDetail:(NSString *)sessIds header:(IMHeaderParam *)header userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?sessIds=%@", sessIds];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfChatDetail, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:userInfo finishBlock:finish failBlock:fail];
}

- (void)requestChatDetailList:(NSString *)userId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?userId=%@&version=%@&limit=%@", userId, version, pageNum];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfChatDetailList, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestGetMsgIds:(NSString *)sessId version:(NSString *)version pageNum:(NSString *)pageNum header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?sessionId=%@&version=%@&limit=%@", sessId, version, pageNum];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfGetMsgIds, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestGetMsgs:(NSString *)msgIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *body = [NSString stringWithFormat:@"msgIds=%@", msgIds];
    NSString *path = url.pathOfGetMsgs;
    NSLog(@"path == %@", path);
    NSLog(@"body == %@", body);
    [_request postAsynRequest:path body:body headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestCreateGroup:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?name=%@&desc=%@&logo=%@&items=%@", title, subtitle, logo, memberIds];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfCreateGroup, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestInviteGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?groupId=%@&sessId=%@&items=%@", groupId, sessId, memberIds];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfInviteGroupMember, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestKickGroupMember:(NSString *)groupId sessId:(NSString *)sessId memberIds:(NSString *)memberIds header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?groupId=%@&sessId=%@&items=%@", groupId, sessId, memberIds];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfKickGroupMember, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestLeaveGroup:(NSString *)groupId sessId:(NSString *)sessId header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?groupId=%@&sessId=%@", groupId, sessId];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfLeaveGroup, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

- (void)requestUpdateGroup:(NSString *)groupId sessId:(NSString *)sessId title:(NSString *)title subtitle:(NSString *)subtitle logo:(NSString *)logo header:(IMHeaderParam *)header finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    IMRequestURL *url = [[IMRequestURL alloc] init];
    _request = [[IMRequest alloc] init];
    NSString *path = [NSString stringWithFormat:@"?groupId=%@&sessId=%@&name=%@&desc=%@&logo=%@", groupId, sessId, title, subtitle, logo];
    path = [NSString stringWithFormat:@"%@%@", url.pathOfUpdateGroup, path];
    NSLog(@"path == %@", path);
    [_request getAsynRequest:path headerDic:header.paramDictionary userInfo:nil finishBlock:finish failBlock:fail];
}

@end
