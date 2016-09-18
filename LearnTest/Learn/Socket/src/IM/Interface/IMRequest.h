//
//  IMRequest.h
//  LearnTest
//
//  Created by syq on 15/5/18.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMResponse.h"

#if NS_BLOCKS_AVAILABLE

typedef void (^FinishBlock)(IMResponse *response);
typedef void (^FailBlock)(IMResponse * response);

#endif

@interface IMRequest : NSObject

- (void)cancelRequest;

- (void)getSynRequest:(NSString *)urlstring headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;
- (void)getAsynRequest:(NSString *)urlstring headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

- (void)postAsynRequest:(NSString *)urlstring body:(NSString *)body headerDic:(NSDictionary *)headerDic userInfo:(NSDictionary *)userInfo finishBlock:(FinishBlock)finish failBlock:(FailBlock)fail;

@end
