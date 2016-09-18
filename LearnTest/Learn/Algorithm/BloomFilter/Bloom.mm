//
//  Bloom.m
//  LearnTest
//
//  Created by syq on 15/1/6.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "Bloom.h"
#import "HashFun.h"

const static int CHARBITSIZE = 8;

@interface Bloom ()
{
    int      _size;
    char    *_arr;
    NSArray *_hashfunclist;
}
@end

@implementation Bloom


- (id)initWithSize:(int)s hashfunclist:(NSArray *)h
{
    self = [super init];
    if (self)
    {
        _size         = s;
        _hashfunclist = h;
        //_arr = new char[s];
        _arr = (char *)malloc(sizeof(char) * s);
//        memset(_arr, 'a', sizeof(char) * s);
//        *(_arr + s - 1) = '\0';
//        
//        NSLog(@"%ld", strlen(_arr));
//        
//        printf("--%s--", _arr);
//        
//        NSLog(@"_arr ===%@", [NSString stringWithCString:_arr encoding:NSUTF8StringEncoding]);
    }
    return self;
}

- (void)add:(const char *)text
{
    long code = 0;
    for (int i = 0; i < _hashfunclist.count; i++)
    {
        HashFun *hash = [_hashfunclist objectAtIndex:i];
        code = [hash gethashval:text];
        if (code/CHARBITSIZE > _size) {
            return;
        } else {
            [self setbit:code];
        }
    }
}

- (BOOL)check:(const char *)text
{
    long code = 0;
    for (int i = 0; i < _hashfunclist.count; i++)
    {
        HashFun *hash = [_hashfunclist objectAtIndex:i];
        code = [hash gethashval:text];
        
        if (code/CHARBITSIZE > _size)
        {
            return NO;
        } else {
            if ([self getbit:code]) {
                continue;
            } else {
                return NO;
            }
        }
    }
    return YES;
}

- (void)setbit:(long)code
{
//    NSLog(@"%d", 1<<(code%CHARBITSIZE));
    _arr[code/CHARBITSIZE] = _arr[code/CHARBITSIZE] | (1<<(code%CHARBITSIZE));
    
    NSLog(@"_arr =--%d", _arr[code/CHARBITSIZE]);
//    NSLog(@"num = %ld", code/CHARBITSIZE);
    
     printf("--%s--", _arr);
    
    NSLog(@"_arr ===%@", [NSString stringWithCString:_arr encoding:NSUTF8StringEncoding]);
    
//    NSString *string_content = [[NSString alloc] initWithCString:(const char*)_arr
//                                                        encoding:NSASCIIStringEncoding];
//    NSLog(@"_arr ===%s %d", _arr, string_content.length);
}

- (BOOL)getbit:(long)code
{
    if (!(_arr[code/CHARBITSIZE] & (1<<(code % CHARBITSIZE))))
    {
        return NO;
    }
    return YES;
}

@end
