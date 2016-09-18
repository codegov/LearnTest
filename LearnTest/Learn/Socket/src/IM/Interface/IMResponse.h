//
//  IMResponse.h
//  LearnTest
//
//  Created by syq on 15/5/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMResponse : NSObject

@property (nonatomic, strong) NSString *statusCode;
@property (nonatomic, strong) NSString *statusCodeOfLocalizedString;
@property (nonatomic, strong) id        result;
@property (nonatomic, strong) NSDictionary *userInfo;

@end
