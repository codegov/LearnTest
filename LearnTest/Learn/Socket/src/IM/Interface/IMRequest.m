//
//  IMRequest.m
//  LearnTest
//
//  Created by syq on 15/5/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMRequest.h"
#import "IMRequestURL.h"
#import "IMConfig.h"

@interface IMRequest ()<NSURLConnectionDelegate>
{
    NSURLConnection *_asynConnection;
    
    FinishBlock _finishBlock;
    FailBlock   _failBlock;
    
    NSMutableData *returnInfoData;
    
    IMResponse *_response;
}
@end

@implementation IMRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _response = [[IMResponse alloc] init];
    }
    return self;
}

- (BOOL)isRequestSucceeded:(NSInteger)statusCode
{
    return (statusCode >= 200 && statusCode < 300);
}


- (void)getSynRequest:(NSString *)urlstring headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    _finishBlock = finish;
    _failBlock   = fail;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlstring]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 60];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    if (headerDic.count)
    {
        [request setAllHTTPHeaderFields:headerDic];
    }
    _response.userInfo = userInfo;
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        _response.statusCode = @(IM_ERROR).stringValue;
        _response.statusCodeOfLocalizedString = error.description;
    } else
    {
        _response.result = returnData;
        _response.statusCode = @([response statusCode]).stringValue;
        _response.statusCodeOfLocalizedString = [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]];
    }
    if ([self isRequestSucceeded:_response.statusCode.integerValue])
    {
        if (finish) finish(_response);
    } else
    {
        if (fail) fail(_response);
    }
}


- (void)getAsynRequest:(NSString *)urlstring headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    _finishBlock = finish;
    _failBlock   = fail;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlstring]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];//表示不cache
    [request setTimeoutInterval: 60];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    if (headerDic.count)
    {
        [request setAllHTTPHeaderFields:headerDic];
    }
    _response.userInfo = userInfo;
    
    _asynConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_asynConnection start];
}

- (void)postAsynRequest:(NSString *)urlstring body:(NSString *)body headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail
{
    _finishBlock = finish;
    _failBlock   = fail;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlstring]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];//表示不cache
    [request setTimeoutInterval: 60];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"POST"];
    
    if (headerDic.count)
    {
        [request setAllHTTPHeaderFields:headerDic];
    }
    NSData *bodyData = [[body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];//把bodyString转换为NSData数据
    [request setHTTPBody:bodyData];//body 数据
    
    _response.userInfo = userInfo;

    _asynConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [_asynConnection start];
}

#pragma mark- NSURLConnectionDelegate 协议方法


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    if ([aResponse isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)aResponse;
        _response.statusCode = @([response statusCode]).stringValue;
        _response.statusCodeOfLocalizedString = [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]];
    } else
    {
        _response.statusCode = @(IM_ERROR).stringValue;
    }
    
    returnInfoData = [[NSMutableData alloc]init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [returnInfoData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _response.statusCode = @(IM_ERROR).stringValue;
    _response.statusCodeOfLocalizedString = error.description;
    
    if (_failBlock) _failBlock (_response);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _response.result = returnInfoData;
    
    if ([self isRequestSucceeded:_response.statusCode.integerValue])
    {
        if (_finishBlock) _finishBlock(_response);
    } else
    {
        if (_failBlock) _failBlock(_response);
    }
}

- (void)cancelRequest
{
    if (_asynConnection)
    {
        [_asynConnection cancel];
        _asynConnection = nil;
    }
}

@end
