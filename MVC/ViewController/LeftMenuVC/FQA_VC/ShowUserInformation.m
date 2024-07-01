//
//  ShowUserInformation.m
//  i西科
//
//  Created by weixvn_android on 15/12/10.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ShowUserInformation.h"
#import "ISwustUserInfo.h"
#import "IswustUserInfoBL.h"
#import "ISwustEditUserInfoViewController.h"
@interface ShowUserInformation (){
    ISwustUserInfo *userInfo;
    IswustUserInfoBL *userBL;
    
}

@end

@implementation ShowUserInformation

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar
    self.title = @"修改个人信息";
//    self.navigationController
    if(_isLeftPush==YES){
        self.editBtn.hidden = YES;
    }else{
        self.editBtn.hidden = NO;
    }
    
    [self ShowINFormation];
}

//-(void)viewWillLayoutSubviews{
//    self.navigationController.navigationBarHidden = YES;
//}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
   [super viewWillDisappear:YES];
        self.navigationController.navigationBarHidden = NO;
}

-(void)ShowINFormation{
    userBL = [IswustUserInfoBL new];
    userInfo = [userBL findData];
    self.UserName.text =userInfo.user_name;
    self.XueYUan.text =userInfo.user_college;
    if ([userInfo.user_sex isEqualToString:@"0"]) {
        self.Sex.text=@"女";
    }else{
        self.Sex.text=@"男";
    }
   
    NSString *bithdayStr ;
    bithdayStr =[userInfo.user_birthday substringToIndex:10];
     self.Birthday.text =bithdayStr;
    self.Class.text =userInfo.user_class;
    self.QQ.text =userInfo.user_number;
    if ([userInfo.user_tel isEqualToString:@""]) {
       self.PHone.text =@"等待添加";
    }else{
        self.PHone.text =userInfo.user_tel;
    }
    if ([userInfo.user_email isEqualToString:@""]) {
        self.Email.text=@"等待添加";
    }else{
    self.Email.text =userInfo.user_email;
    }
    if([userInfo.user_signature isEqualToString:@""]){
        self.Sigure.text=@"等待添加";
    }else{
         self.Sigure.text =userInfo.user_signature;
    }

    if (self.Sigure.text.length>15) {
        self.Sigure.font =[UIFont fontWithName:self.Sigure.text size:14];
    }
    
    //设置头像位置
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",userInfo.user_number];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        self.TouXiangPicture.image = [UIImage imageWithData:imageData];
    }else{
        self.TouXiangPicture.image = [UIImage imageNamed:@"i西科"];
    }
    self.TouXiangPicture.layer.cornerRadius = self.TouXiangPicture.frame.size.width/2;
    self.TouXiangPicture.clipsToBounds = YES;

    
   
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

//- (IBAction)Canel:(id)sender {
//     [self dismissViewControllerAnimated:YES completion:nil];
//}

//- (IBAction)Sure:(id)sender {
//     [self dismissViewControllerAnimated:YES completion:nil];
//}

- (IBAction)ChangeInformation:(id)sender {
    //ISwustEditUserInfoViewController *edit = [ISwustEditUserInfoViewController alloc]init
    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EditISwustUserInfoVC"] sender:self];
}

- (IBAction)Sure:(id)sender {
    if(_isLeftPush==YES){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
@end