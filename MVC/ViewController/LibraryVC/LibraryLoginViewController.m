//
//  LibraryLoginViewController.m
//  i西科
//
//  Created by weixvn_ios on 15/11/27.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "LibraryLoginViewController.h"
#import "Tools.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "AccountNumberInfo.h"
#import "LibraryLogin.h"
#import "AccountNumberInfo.h"
#import "MBProgressHUD.h"

@interface LibraryLoginViewController ()<UITextFieldDelegate>
{
    ASIFormDataRequest *_requestForm;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UITextField *txt_userName;
@property (strong, nonatomic) IBOutlet UITextField *txt_Pwd;
@property (strong, nonatomic) IBOutlet UITextField *txt_authcode;
@property (strong, nonatomic) IBOutlet UIButton *auth_Image;

@end

@implementation LibraryLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"图书馆登录"];
    [self performSelectorInBackground:@selector(changeAuthImage:) withObject:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_Update_Notice" object:nil];
    
    //决定是否显示用户名以及密码
    AccountNumberInfo *userinfo = [[Config Instance]getLibraryUser];
    if (userinfo.userNumber && ![userinfo.userNumber isEqualToString:@""]) {
        self.txt_userName.text = userinfo.userNumber;
    }
    if (userinfo.userPassword && ![userinfo.userPassword isEqualToString:@""]) {
        self.txt_Pwd.text = userinfo.userPassword;
    }
    
    [self.txt_userName setDelegate:self];
    [self.txt_authcode setDelegate:self];
    [self.txt_Pwd setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)selfNotificationDO:(NSNotification *)aNotification
{
    if (hud) {
        [hud hide:YES];
    }
    
    //处理notification
    if ([aNotification.name isEqualToString:@"Library_Update_Notice"]) {
        if ([[aNotification.userInfo objectForKey:@"Message"]isEqualToString:SUCCESS]) {
            ///登陆成功,保存账号密码
            [[Config Instance]saveLibraryUserNameAndPwd:self.txt_userName.text andPwd:self.txt_Pwd.text];
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"libraryVC"] animated:YES];
            
        }else{
            [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
        }
        
    }
}



- (IBAction)changeAuthImage:(id)sender {
    NSLog(@"执行图片下载函数");
    
    if ([Tools checkNetWorking]) {
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://202.115.162.45:8080/reader/captcha.php"]];
        UIImage * result = [UIImage imageWithData:data];
        [_auth_Image setBackgroundImage:result forState:UIControlStateNormal];
        
    }else{
        
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
}
- (IBAction)onClickLoginLibrary:(id)sender {
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
    
    LibraryLogin * login = [LibraryLogin new];
    AccountNumberInfo *user = [AccountNumberInfo new];
    user.userNumber = self.txt_userName.text;
    user.userPassword = self.txt_Pwd.text;
    [login library_login:user authcode:self.txt_authcode.text];
}


//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_userName resignFirstResponder];
    [self.txt_Pwd resignFirstResponder];
    [self.txt_authcode resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txt_userName resignFirstResponder];
    [self.txt_Pwd resignFirstResponder];
    [self.txt_authcode resignFirstResponder];
    return YES;
}

@end
