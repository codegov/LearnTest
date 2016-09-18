//
//  KeyChainRootViewController.m
//  LearnTest
//
//  Created by syq on 15/3/19.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "KeyChainRootViewController.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"

static const char kKeychainUDIDItemIdentifier[] = "Lianxi";
static const char kKeychainUDIDAccessGroup[]    = "39828W8EE7.com.chanjet.LearnTest123";

@interface KeyChainRootViewController ()
{
    KeychainItemWrapper *wrapper;
}
@end

@implementation KeyChainRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUDIDToKeychain:@"hah12121"];
    
//    NSString *value = [self getUDIDFromKeychain];

    
    [self test];
    
    wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"18612932222212312312312312" accessGroup:@"39828W8EE7.com.chanjet.LearnTest1"];
    
    [wrapper setObject:@"qqqqqqqq" forKey:(__bridge id)kSecAttrAccount];
    [wrapper setObject:@"11111111" forKey:(__bridge id)kSecValueData];
    
    NSString *password = [wrapper objectForKey:(__bridge id)kSecAttrGeneric];
    
    NSLog(@"password ==%@", password);

    [wrapper resetKeychainItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*将UDID存储keychain*/
- (BOOL)setUDIDToKeychain:(NSString*)UDID
{
    NSMutableDictionary *dictForAdd = [[NSMutableDictionary alloc] init];
    
    [dictForAdd setValue:(__bridge id)kSecClassGenericPassword                                  forKey:(__bridge id)kSecClass];
    [dictForAdd setValue:@""                                                                    forKey:(__bridge id)kSecAttrAccount];
    [dictForAdd setValue:@""                                                                    forKey:(__bridge id)kSecAttrLabel];
    [dictForAdd setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]            forKey:(__bridge id)kSecAttrDescription];
    [dictForAdd setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]            forKey:(__bridge id)kSecAttrGeneric];
    [dictForAdd setValue:[NSData dataWithBytes:UDID.UTF8String length:strlen(UDID.UTF8String)]  forKey:(__bridge id)kSecValueData];
    
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (accessGroup) {
        [dictForAdd setValue:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    OSStatus writeErr = SecItemAdd((__bridge CFDictionaryRef)dictForAdd, NULL);
    if (writeErr == errSecSuccess) {
        NSLog(@"存储UDID到Keychain成功！");
        return YES;
    }
    
    NSLog(@"存储UDID到Keychain失败: %d", (int)writeErr);
    return NO;
}

/*从keychain中获取UDID*/
- (NSString *)getUDIDFromKeychain
{
    NSMutableDictionary *dictForQuery = [[NSMutableDictionary alloc] init];
    [dictForQuery setValue:(__bridge id)kSecClassGenericPassword                                forKey:(__bridge id)kSecClass];
    [dictForQuery setValue:(__bridge id)kSecMatchLimitOne                                       forKey:(__bridge id)kSecMatchLimit];
    [dictForQuery setValue:(__bridge id)kCFBooleanTrue                                          forKey:(__bridge id)kSecMatchCaseInsensitive];
    [dictForQuery setValue:(__bridge id)kCFBooleanTrue                                          forKey:(__bridge id)kSecReturnData];
    [dictForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]          forKey:(__bridge id)kSecAttrDescription];
    [dictForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]          forKey:(__bridge id)kSecAttrGeneric];
    
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (accessGroup) {
//#if TARGET_IPHONE_SIMULATOR
//        
//#else
        [dictForQuery setValue:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
//#endif
    }
    
    NSData *udidValue = nil;
    OSStatus queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (void *)&udidValue);
    
    CFMutableDictionaryRef *dict = nil;
    [dictForQuery setValue:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    queryErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictForQuery, (CFTypeRef *)&dict);
    if (queryErr == errSecSuccess) {
        NSString *udid = nil;
        if (udidValue) {
            udid = [NSString stringWithUTF8String:udidValue.bytes];
        }
         NSLog(@"从Keychain中获取UDID成功: %@", udid);
        return udid;
    } else {
         NSLog(@"从Keychain中获取UDID失败:%d", (int)queryErr);
    }
    
    return nil;
}

- (void)test
{
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *subviews = [[[application valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetWorkItemView = nil;
    for (id subView in subviews) {
        if ([subView isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetWorkItemView = subView;
            break;
        }
    }
//    NetWorkType networkType = NetWorkType_None;
    switch ([[dataNetWorkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
//            networkType = NetWorkType_None;
            break;
            
        case 1:
            NSLog(@"2G");
//            networkType = NetWorkType_2G;
            break;
            
        case 2:
            NSLog(@"3G");
//            networkType = NetWorkType_3G;
            break;
            
        default:
            NSLog(@"Wifi");
//            networkType = NetWorkType_WIFI;
            break;
    }
//    return networkType;
}


@end
