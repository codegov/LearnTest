//
//  IMChatData.m
//  LearnTest
//
//  Created by syq on 15/5/25.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "IMChatMem.h"

@implementation IMChatMem
{
    NSMutableArray      *_dataArray;
    NSMutableDictionary *_dataDictionary;
    
    NSMutableDictionary *plistDictionary;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 显示数据
        _dataArray      = [[NSMutableArray alloc] init];
        _dataDictionary = [[NSMutableDictionary alloc] init];
        // 配置数据
//        plistDictionary = [[NSMutableDictionary alloc] init];
//        [self plistData];
    }
    return self;
}

//- (void)addData:(IMChat *)chat
//{
//    [self addData:chat plistfilter:YES];
//    _dataArray.array = [[self class] sortChat:_dataArray]; // 排序
//}
//
//- (void)addDatas:(NSArray *)array
//{
//    [self addDatas:array plistfilter:YES];
//}
//
//- (void)addDatas:(NSArray *)array plistfilter:(BOOL)filter
//{
//    for (IMChat *chat in array)
//    {
//        [self addData:chat plistfilter:filter];
//    }
//    _dataArray.array = [[self class] sortChat:_dataArray]; // 排序
//}
//
//- (void)addData:(IMChat *)chat plistfilter:(BOOL)filter
//{
//    if (filter)
//    {
//        [self plistFilterData:chat]; // 过滤成plist最新的配置数据
//    }
//    
//    IMChat *oChat = [_dataDictionary objectForKey:chat.chatId];
//    if (oChat)
//    {
//        [_dataArray removeObject:oChat];
//    }
//    [_dataArray addObject:chat];
//    [_dataDictionary setObject:chat forKey:chat.chatId];
//}
//
//- (void)deleteChat:(NSString *)chatId
//{
//    IMChat *chat = [_dataDictionary objectForKey:chatId];
//    if (chat)
//    {
//        [_dataArray removeObject:chat];
//        [_dataDictionary removeObjectForKey:chatId];
//    }
//}

- (void)addOrupdateChat:(IMChat *)chat
{
    if (!chat.chatId.length) return;
    
    IMChat *chat1 = [_dataDictionary objectForKey:chat.chatId];
    if (chat1)
    {
        if ([_dataArray containsObject:chat1])
        {
            [_dataArray removeObject:chat1];
        }
        [chat1 copy:chat];
        [_dataArray addObject:chat1];
        [_dataDictionary setObject:chat1 forKey:chat1.chatId];
        return ;
    }

    
    [_dataArray addObject:chat];
    [_dataDictionary setObject:chat forKey:chat.chatId];
}


- (NSArray *)queryChats;
{
    return [NSArray arrayWithArray:_dataArray];
}

//#pragma mark - 配置数据
//
//- (void)plistData
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Chat" ofType:@"plist"];
//    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//    NSArray *contentArray = [dictionary objectForKey:@"content"];
//    
//    NSMutableArray *deArray = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in contentArray)
//    {
//        NSString *chatId = [dic objectForKey:@"id"];
//        NSString *title  = [dic objectForKey:@"title"];
//        NSString *icon   = [dic objectForKey:@"icon"];
//        BOOL isDefault   = [[dic objectForKey:@"default"] integerValue];
//        BOOL isDelete    = [[dic objectForKey:@"delete"] integerValue];
//        NSInteger sort   = [[dic objectForKey:@"sort"] integerValue];
//        
//        IMChat *chat = [[IMChat alloc] init];
//        chat.chatId    = chatId;
//        chat.chatTime  = @"0";
//        chat.title     = title;
//        chat.chatIcon  = icon;
//        chat.flag = CHAT_FLAG_SUCCEED;
//        chat.type = CHAT_TYPE_PUSH;
//        
//        chat.canDelete   = isDelete;
//        chat.indexOfSort = sort;
//        
//        [plistDictionary setObject:chat forKey:chatId];
//        
//        if (isDefault)
//        {
//            [deArray addObject:chat];
//        }
//    }
//    [self addDatas:deArray plistfilter:NO];
//}
//
//- (void)plistFilterData:(IMChat *)chat
//{
//    IMChat *pChat = [plistDictionary objectForKey:chat.chatId];
//    if (pChat)
//    {
//        chat.title       = pChat.title;
//        chat.chatIcon    = pChat.chatIcon;
//        
//        chat.canDelete   = pChat.canDelete;
//        chat.indexOfSort = pChat.indexOfSort;
//    } else {
//        chat.canDelete   = YES;
//        chat.indexOfSort = 0;
//    }
//}
//
//#pragma mark - 排序数据
//
//+ (NSArray *)sortChat:(NSArray *)array
//{
//    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        IMChat *chat1 = (IMChat *)obj1;
//        IMChat *chat2 = (IMChat *)obj2;
//        NSInteger index1 = chat1.indexOfSort;
//        NSInteger index2 = chat2.indexOfSort;
//        NSComparisonResult result = NSOrderedSame;
//        if (chat1.chatTime.length && chat2.chatTime.length && chat1.chatTime.longLongValue > chat2.chatTime.longLongValue) {
//            result = NSOrderedAscending;
//        } else if (chat1.chatTime.length && chat2.chatTime.length && chat1.chatTime.longLongValue < chat2.chatTime.longLongValue) {
//            result = NSOrderedDescending;
//        } else if (index1 > index2) {
//            result = NSOrderedAscending;
//        } else if (index1 < index2) {
//            result = NSOrderedDescending;
//        }
//        return result;
//    }];
//}

@end

