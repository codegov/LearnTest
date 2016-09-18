//
//  SocketMessageViewController.h
//  LearnTest
//
//  Created by syq on 15/5/26.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "LearnTableViewController.h"
#import "IMHeaderParam.h"
#import "IMChat.h"

@interface SocketMessageViewController : LearnTableViewController

@property (nonatomic, strong) NSString *bid;
@property (nonatomic, strong) IMChat *chat;
@end
