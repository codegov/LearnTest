//
//  LearnTableViewController.h
//  LearnTest
//
//  Created by syq on 14/10/24.
//  Copyright (c) 2014年 com.chanjet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray      *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

@property (nonatomic, strong) UITableView         *tableView;

@end
