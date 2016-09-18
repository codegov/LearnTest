//
//  AccountViewController.m
//  LearnTest
//
//  Created by syq on 15/8/11.
//  Copyright (c) 2015年 com.chanjet. All rights reserved.
//

#import "AccountViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "CDVJSON.h"
#import <AdSupport/AdSupport.h>
#import <iAd/iAd.h>

@interface AccountViewController ()<ADBannerViewDelegate>
{
    ACAccountStore *_weiboAccount;
}
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ADBannerView *adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    adView.frame = CGRectMake(0.0, self.view.bounds.size.height - adView.frame.size.height, adView.frame.size.width, adView.frame.size.height);
    adView.delegate = self;
    [self.view addSubview:adView];
    
    
    _weiboAccount = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [_weiboAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierSinaWeibo];
    [_weiboAccount requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSArray *arrayOfAccounts = [_weiboAccount accountsWithAccountType:accountType];
            if (arrayOfAccounts.count)
            {
                NSLog(@"%@", arrayOfAccounts);
                [self requestWithAccount:arrayOfAccounts.firstObject];
            } else
            {
                NSLog(@"没有添加账号");
            }
        } else
        {
            NSLog(@"不允许授权");
        }
    }];
}

- (void)requestWithAccount:(ACAccount *)account
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (account.credential.oauthToken.length) {
        [parameters setObject:account.credential.oauthToken forKey:@"access_token"];
    }
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.weibo.com/2/statuses/user_timeline.json"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeSinaWeibo requestMethod:SLRequestMethodGET URL:url parameters:parameters];
    request.account = account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSLog(@"request");
        if (urlResponse.statusCode == 200)
        {
            NSString *content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSDictionary *dic = [content JSONObject];
        
            NSArray *list = [dic objectForKey:@"statuses"];
            for (NSDictionary *dictionary in list)
            {
                NSString *text = [dictionary objectForKey:@"text"];
                if (text.length) {
                    [self.dataArray addObject:text];
                }
            }
            [self.tableView reloadData];
        } else
        {
            NSLog(@"请求失败");
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *codeId = @"account";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:codeId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:codeId];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
