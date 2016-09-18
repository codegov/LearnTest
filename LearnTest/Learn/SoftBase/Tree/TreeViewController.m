//
//  TreeViewController.m
//  LearnTest
//
//  Created by javalong on 16/8/17.
//  Copyright © 2016年 com.chanjet. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeView.h"
#import "BSTTree.h"

@interface TreeViewController ()

@end

@implementation TreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    TreeView *treeView = [[TreeView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    self.tableView.tableHeaderView = treeView;
    
    for (int i = 0; i < 1; i++)
    {
        [self createTree];
    }
    
//    treeView.tree = tree;
}

- (void)createTree
{
    BSTTree *tree = [[BSTTree alloc] init];
    for (int i = 0; i < 10; i++)
    {
        int x = arc4random() % 10;
        [tree putValue:@(x).stringValue value:@(x)];
    }
    [tree log];
    [tree delKey:@"1"];
    [tree log];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
