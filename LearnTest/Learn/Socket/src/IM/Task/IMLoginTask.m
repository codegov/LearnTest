//
//  IMLoginTask.m
//  LearnTest
//
//  Created by syq on 15/5/20.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMLoginTask.h"
#import "IMSocket.h"
#import "IMRequestInterface.h"
#import "CDVJSON.h"
#import "GCDAsyncSocket.h"

#import "Message.pb.h"
#import "ToolProtobuf.h"

@interface IMLoginTask ()
{
    GCDAsyncSocket     *_requestSocket;
    IMRequestInterface *_requestHttp;
    
    IMLoginState _loginState;
    
    IMLoginParam *_param;
    IMSocket     *_socket;
    int           _socketConnectNum;
    
    int      _keepAliveTime;
    NSTimer *_keepAliveTimer;
    
    int      _keepLoginTime;
    NSTimer *_keepLoginTimer;
}
@end

@implementation IMLoginTask

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _loginState = IMLoginStateHttpStart;
    }
    return self;
}

#pragma mark - 登出

- (void)requestLogout
{
    _loginState = IMLoginStateHttpStart;
    if (_requestHttp)
    {
        [_requestHttp.request cancelRequest];
        _requestHttp = nil;
    }
    
    [self closeAliveTimer];
    [self closeLoginTimer];
    
    if (_requestSocket)
    {
        [_requestSocket disconnect];
        _requestSocket.delegate = nil;
        _requestSocket.delegateQueue = nil;
        _requestSocket = nil;
    }
    NSLog(@"IM登出");
}

#pragma mark - 重登

- (void)openLoginTimerWithTime:(int)time
{
    [self closeLoginTimer];
    _keepLoginTime = time;
    _keepLoginTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealLoginTime) userInfo:nil repeats:YES];
    [_keepLoginTimer fire];
}

- (void)closeLoginTimer
{
    if (_keepLoginTimer)
    {
        [_keepLoginTimer invalidate];
        _keepLoginTimer = nil;
    }
}

- (void)dealLoginTime
{
    _keepLoginTime --;
    NSLog(@"IM自动重登机制：%@", @(_keepLoginTime).stringValue);
    if (_keepLoginTime == 0)
    {
        [self closeLoginTimer];
        [self autoLogin];
    }
}

- (void)reLoginWithCode:(NSString *)code state:(IMLoginState)state
{
    if (code.integerValue == IM_ERROR_LOGIN) // IM登录失败，启动定时登录
    {
        if (state == IMLoginStateSocketStart)
        {
            _socketConnectNum ++;
            NSLog(@"第%@次重新连接socket", @(_socketConnectNum).stringValue);
            if (_socketConnectNum > 3)
            {
                NSLog(@"达到重新连接socket次数上限，走HTTP逻辑");
                _requestSocket.delegate = nil;
                _requestSocket.delegateQueue = nil;
                _requestSocket = nil;
                _socketConnectNum = 0;
                _loginState = IMLoginStateHttpStart;
                [IMSocket removeWithUserName:_param.username password:_param.password];
                [self closeLoginTimer];
                [self autoLogin];
                return;
            }
        }
        [self openLoginTimerWithTime:10];
    }
}

#pragma mark - 登录响应

- (void)responseOfLogin:(NSString *)code msg:(NSString *)msg state:(IMLoginState)state
{
    IMResponse *response = [[IMResponse alloc] init];
    response.statusCode = code;
    response.statusCodeOfLocalizedString = msg;
    _loginState = state;
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_LoginDidChange_Notification object:response];
    
    [self reLoginWithCode:code state:state]; // 重登
}

#pragma mark - 登录

- (void)requestLoginWithParam:(IMLoginParam *)param
{
    _param  = param;
    [self closeLoginTimer]; // 关闭定时重登
    [self autoLogin];
}

- (void)autoLogin
{
    if (!_param.username.length || !_param.password.length)
    {
        [self responseOfLogin:@(IM_ERROR).stringValue msg:@"登录参数的用户名或密码为空" state:IMLoginStateHttpStart];
        return;
    }
    
    if (_loginState != IMLoginStateHttpStart)
    {
        if (_socket)
        {
            _loginState = IMLoginStateSocketStart;
            [self connectSocket]; // 建立长连接
        }
        return;
    }
    
    _loginState  = IMLoginStateHttpDoing;
    _requestHttp = [[IMRequestInterface alloc] init];
    _socket      = [IMSocket queryWithUserName:_param.username password:_param.password];
    
    if (_socket && _socket.token.length && _socket.userId.length) // 通过token登录
    {
        [self dealHeaderParam:_socket];
        [self loginWithToken];
    } else
    {
        [self loginWithUser];
    }
}

- (void)dealHeaderParam:(IMSocket *)socket
{
    if (socket)
    {
        _headerParam.userId = socket.userId;
        _headerParam.token  = socket.token;
        _headerParam.lastLoginTime = socket.creatTime;
    }
}

- (void)loginWithToken
{
    [_requestHttp requestLoginWithToken:_socket.token userId:_socket.userId param:_param finishBlock:^(IMResponse * response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) // 数据为空
        {
            [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfileByToken返回数据为空" state:IMLoginStateHttpStart]; return;
        }
        NSLog(@"dic==%@ == %@", dic, [dic objectForKey:@"msg"]);
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == IM_ERROR_USERAUTH_LGOIN) {
            [self responseOfLogin:@(code).stringValue msg:@"认证失败" state:IMLoginStateHttpStart];
        } else if (code == IM_ERROR_TOKEN_LOGIN && [IMSocket removeWithUserName:_param.username password:_param.password]) // token验证失败
        {
            _loginState = IMLoginStateHttpStart;
            [self requestLoginWithParam:_param]; // 通过用户名和密码去登录
        } else if (code == IM_SUCCESS) // 获取成功
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            _socket = [[IMSocket alloc] initWithDictionary:dataDic];
            [self dealHeaderParam:_socket];
            [IMSocket saveWithSocket:_socket userName:_param.username password:_param.password];
            _loginState = IMLoginStateSocketStart;
            [self connectSocket]; // 建立长连接
        } else
        {
            [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfileByToken返回服务器错误码" state:IMLoginStateHttpStart];
        }
    } failBlock:^(IMResponse *response) {
        [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfileByToken请求失败" state:IMLoginStateHttpStart];
    }];
}

- (void)loginWithUser
{
    [_requestHttp requestLoginWithParam:_param finishBlock:^(IMResponse * response) {
        NSString *content = [[NSString alloc] initWithData:response.result encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [content JSONObject];
        if (!dic) // 数据为空
        {
            [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfile返回数据为空" state:IMLoginStateHttpStart]; return;
        }
        NSLog(@"dic==%@ == %@", dic, [dic objectForKey:@"msg"]);
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        if (code == IM_ERROR_USERAUTH_LGOIN) {
            [self responseOfLogin:@(code).stringValue msg:@"认证失败" state:IMLoginStateHttpStart];
        } else if (code == IM_SUCCESS)
        {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            _socket = [[IMSocket alloc] initWithDictionary:dataDic];
            [self dealHeaderParam:_socket];
            [IMSocket saveWithSocket:_socket userName:_param.username password:_param.password];
            _loginState = IMLoginStateSocketStart;
            [self connectSocket]; // 建立长连接
        } else
        {
            [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfile返回服务器错误码" state:IMLoginStateHttpStart];
        }
    } failBlock:^(IMResponse * response) {
        [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"接口getProfile请求失败" state:IMLoginStateHttpStart];
    }];
}


- (void)connectSocket
{
    if (!_socket.host.length || !_socket.port.length) // IP或端口号为空，长连接建立不成功
    {
        [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:@"IP或端口号为空" state:IMLoginStateHttpStart]; return;
    }
    
    [self dealHeaderParam:_socket];
    
    if (_loginState != IMLoginStateSocketStart) return;
    
    _loginState = IMLoginStateSocketDoing;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    _requestSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
    
    NSError *error = nil;
    if (![_requestSocket connectToHost:_socket.host onPort:[_socket.port integerValue] error:&error])
    {
        [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:[NSString stringWithFormat:@"socket连接出错：%@", error.localizedDescription] state:IMLoginStateSocketStart]; // socket连接出错，重试3次
    }
}


#pragma mark Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    [self keepLoginWithTag:1];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure:%p", sock);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    @try {
        if (data.length)
        {
            MessageBuf *buf = [ToolProtobuf decodeData:data];
            if (buf.requestType == MessageBufRequestTypeEnumReceipt) // 回执
            {
                if (buf.receipt.type == MessageBufACKTypeEnumLoginAck) // 登录回执
                {
                    [self ackOfLoginWithBuf:buf];
                }
            } if (buf.requestType == MessageBufRequestTypeEnumKeepalive) { // 心跳包回执
                NSLog(@"心跳包回执");
                [self closeAliveTimer];
                [self openAliveTimerWithTime:40 action:@selector(delayAlive)];
            } if (buf.requestType == MessageBufRequestTypeEnumSingleMsg) { // 收到消息
                NSLog(@"收到消息");
                IMMessage *msg  = [[IMMessage alloc] init];
                msg.msgSid      = @(buf.message.msgId).stringValue;
                msg.mediaType   = buf.message.subType;
                msg.from        = @(buf.message.from).stringValue;
                msg.to          = @(buf.message.to).stringValue;
                msg.body        = buf.message.body;
                msg.clientTime  = @(buf.message.clientTime).stringValue;
                msg.serverTime  = @(buf.message.serverTime).stringValue;
                msg.failed      = @(YES);
                [_messageTask.messageManager receiveMessage:msg];
            }
        } else // 空包，心跳包回执
        {
            
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)ackOfLoginWithBuf:(MessageBuf *)buf
{
    SInt64 ver = buf.receipt.loginAck.sessVer;
    NSString *key = [NSString stringWithFormat:@"%@_sessVer", _socket.userId];
    NSInteger oldVer = [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
    if (ver > oldVer)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(ver) forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        /**未完待续**/// 此版本大于本地，需要拉会话和消息
    }
    [self closeAliveTimer];
    [self responseOfLogin:@(IM_SUCCESS).stringValue msg:@"IM登录成功" state:IMLoginStateSocketSuccess];
    [self KeepAliveWithTag:99];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    [self closeAliveTimer]; //关闭心跳定时器
    
    if (!_requestSocket) return; // 手动退出，导致的断链
    
    if (err) // socket连接出错，重试3次
    {
        [self responseOfLogin:@(IM_ERROR_LOGIN).stringValue msg:[NSString stringWithFormat:@"socket连接出错：%@", err.localizedDescription] state:IMLoginStateSocketStart];
    } else
    {
        [self responseOfLogin:@(IM_ERROR).stringValue msg:@"IM连接断开" state:IMLoginStateSocketStart];
        _requestSocket.delegate = nil;
        _requestSocket.delegateQueue = nil;
        _requestSocket = nil;
        [self connectSocket];
    }
}

- (void)keepLoginWithTag:(int)tag
{
    MessageBufBuilder *bufBuilder = [MessageBuf builder];
    bufBuilder.requestType = MessageBufRequestTypeEnumLogin;
    bufBuilder.isRequest = YES;
    
    MessageBufUserBuilder *userBuilder = [MessageBufUser builder];
    userBuilder.userId = [_socket.userId integerValue];
    userBuilder.token  = _socket.token;
    userBuilder.appId  = _param.appId;
    userBuilder.loginType  = [_param.loginType intValue];
    userBuilder.deviceType = _param.deviceType;
    userBuilder.deviceId   = _param.deviceId;
    userBuilder.version    = 0;
    
    
    bufBuilder.user = [userBuilder build];
    MessageBuf *msgBuf = [bufBuilder build];
    NSData *enData = [ToolProtobuf encodeMessageBuf:msgBuf];
    
    [_requestSocket writeData:enData withTimeout:-1.0 tag:tag];
    [_requestSocket readDataWithTimeout:-1.0 tag:tag];
    
    // 登录成功，开启心跳
    [self openAliveTimerWithTime:10 action:@selector(dealAliveTime)];
}


#pragma mark - 心跳

- (void)KeepAliveWithTag:(int)tag
{
    MessageBufBuilder *bufBuilder = [MessageBuf builder];
    bufBuilder.requestType = MessageBufRequestTypeEnumKeepalive;
    bufBuilder.isRequest = YES;
    
    MessageBufKeepAliveBuilder *kaBuilder = [MessageBufKeepAlive builder];
    kaBuilder.ping = @"1";
    
    bufBuilder.keepAlive = [kaBuilder build];
    MessageBuf *msgBuf = [bufBuilder build];
    NSData *enData = [ToolProtobuf encodeMessageBuf:msgBuf];
    
    [_requestSocket writeData:enData withTimeout:-1.0 tag:tag];
    [_requestSocket readDataWithTimeout:-1.0 tag:tag];
    
    // 心跳发出，等待回执
    [self openAliveTimerWithTime:40 action:@selector(dealAliveTime)];
}

- (void)openAliveTimerWithTime:(int)time action:(SEL)action
{
    [self closeAliveTimer];
    _keepAliveTime = time;
    _keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:action userInfo:nil repeats:YES];
    [_keepAliveTimer fire];
}

- (void)closeAliveTimer
{
    if (_keepAliveTimer)
    {
        [_keepAliveTimer invalidate];
        _keepAliveTimer = nil;
    }
}

- (void)dealAliveTime
{
    _keepAliveTime --;
    NSLog(@"IM心跳超时机制：%@", @(_keepAliveTime).stringValue);
    if (_keepAliveTime == 0)
    {
        [self closeAliveTimer];
        [_requestSocket disconnect];
    }
}

- (void)delayAlive
{
    _keepAliveTime --;
    NSLog(@"IM心跳延迟机制：%@", @(_keepAliveTime).stringValue);
    if (_keepAliveTime == 0)
    {
        [self closeAliveTimer];
        [self KeepAliveWithTag:99];
    }
}





@end
