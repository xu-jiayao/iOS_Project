//
//  CommunityLoginViewController.m
//  i西科
//
//  Created by 张为 on 15/5/13.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "CommunityLoginViewController.h"
#import "IswustUserInfoBL.h"
#import "ISwustUserInfo.h"
#import "UMComUserAccount.h"
#import "BaiduMobStat.h"



@interface CommunityLoginViewController ()
{
    IswustUserInfoBL *userBL;
    ISwustUserInfo *userInfo;
    NSString *userPhotoUrl;
}
- (IBAction)dismisss:(id)sender;
@end

@implementation CommunityLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userBL = [IswustUserInfoBL new];
    userInfo = [userBL findData];
    self.userNumber.text = userInfo.user_number;
    userInfo.nick_name = [userInfo.nick_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    userInfo.nick_name = [userInfo.nick_name stringByReplacingOccurrencesOfString:@"_" withString:@""];
    self.userNickName.text = userInfo.nick_name;
    userPhotoUrl = userInfo.user_photo_link;
    
    UMComUserAccount *account = [[UMComUserAccount alloc] init];
    account.usid = self.userNumber.text;
    account.name = self.userNickName.text;
    account.snsType = [account initWithSnsType:UMComSnsTypeSelfAccount];
    //account.snsType = UMComSnsTypeOther;
   // account.snsPlatformName = @"iSwust";
    NSNumber *sex = [NSNumber numberWithInt:userInfo.user_sex.intValue]  ;
    account.gender = sex;
    if (![userPhotoUrl isEqualToString:@"NULL_USER_PHOTO"]) {
        account.icon_url = userPhotoUrl;
    }
    [UMComLoginManager finishLoginWithAccount:account completion:^(NSArray *data, NSError *error) {
        [UMComLoginManager finishDismissViewController:self data:data error:error];
    }];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    userBL = [IswustUserInfoBL new];
    userInfo = [userBL findData];
    self.userNumber.text = userInfo.user_number;
    userInfo.nick_name = [userInfo.nick_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    userInfo.nick_name = [userInfo.nick_name stringByReplacingOccurrencesOfString:@"_" withString:@""];
    self.userNickName.text = userInfo.nick_name;
    userPhotoUrl = userInfo.user_photo_link;
    
    // 从沙盒获取图片
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",userInfo.user_number];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        self.userPhoto.image = [UIImage imageWithData:imageData];
    }
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width/2;
    self.userPhoto.clipsToBounds = YES;
}

-(void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoadDataCompletion)loginCompletion
{
    [viewController presentViewController:self animated:YES completion:nil];
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

- (IBAction)login:(id)sender {
    UMComUserAccount *account = [[UMComUserAccount alloc] init];
    account.usid = self.userNumber.text;
    account.name = self.userNickName.text;
    account.snsType = [account initWithSnsType:UMComSnsTypeSelfAccount];
    //account.snsType = UMComSnsTypeOther;
    
    //account.snsPlatformName = @"iSwust";
    NSNumber *sex = [NSNumber numberWithInt:userInfo.user_sex.intValue]  ;
    account.gender = sex;
    if (![userPhotoUrl isEqualToString:@"NULL_USER_PHOTO"]) {
        account.icon_url = userPhotoUrl;
    }
    
    //account.snsPlatformName = @"sina0.";
    //account.token = @"";
    
    
    [UMComLoginManager finishLoginWithAccount:account completion:^(NSArray *data, NSError *error) {
        [UMComLoginManager finishDismissViewController:self data:data error:error];
    }];
}
- (IBAction)dismisss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"西科聊"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"离开西科聊"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNickName resignFirstResponder];
    [self.userNumber resignFirstResponder];
}

@end
