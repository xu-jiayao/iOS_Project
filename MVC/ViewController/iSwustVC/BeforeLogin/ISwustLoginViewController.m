//
//  ISwustLoginViewController.m
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ISwustLoginViewController.h"
#import "DeanLogin.h"
#import "XTSideMenu.h"
#import "LeftMenuViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "NewsBL.h"
@interface ISwustLoginViewController ()<UIAlertViewDelegate>
{
    MBProgressHUD *hud;
    AccountNumberInfo *userinfo;
}
- (IBAction)click_newUser:(id)sender;

- (IBAction)click_forgetPW:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *iSwustIcon;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn_BGV;
@property (weak, nonatomic) IBOutlet UIView *txt_login_BGV;
@end

@implementation ISwustLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[Config Instance]saveIswustLoginStatus:Iswust_logout];
    [[Config Instance]saveIsNeedToLoginISwust:YES];
    //清楚所有cookies
    [[Config Instance]clearHttpCookie:@"ALL"];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.txt_pwd setDelegate:self];
    [self.txt_username setDelegate:self];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_login_Notice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_Request_Notice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_SynchSystemAccount_Notice" object:nil];
    
    self.txt_login_BGV.layer.cornerRadius = 8.0;
   
//    self.iSwustIcon.layer.masksToBounds =YES;
//    self.iSwustIcon.layer.cornerRadius = self.iSwustIcon.bounds.size.width/2;
    [self.loginBtn_BGV.layer setCornerRadius:6.0];
    
//    //决定是否显示用户名以及密码
//    AccountNumberInfo *user = [[Config Instance]getISwustUser];
//    if (user.userNumber && ![user.userNumber isEqualToString:@""]) {
//        self.txt_username.text = user.userNumber;
//    }
//    if (user.userPassword && ![user.userPassword isEqualToString:@""]) {
//        self.txt_pwd.text = user.userPassword;
//    }
//    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selfNotificationDO:(NSNotification *)aNotification
{

    
    if ([aNotification.name isEqualToString:@"ISwust_login_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        
//         if ([[aNotification.userInfo objectForKey:@"Message"]isEqualToString:ISwust_USER_Type_Teacher])
//         {
//                ////教师账户成功登录后的操作
//                [self operationAfterRequestSuccess];
//             
//         }
//         else
//         {
//                ////学生账户成功登录后的操作
                [self operationAfterRequestSuccess];

        
    }else if ([aNotification.name isEqualToString:@"ISwust_login_Notice"] && ![[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        
        if (hud) {
            [hud hide:YES];
        }
        
        [[Config Instance]saveIswustLoginStatus:Iswust_logout];
        [[Config Instance]saveIsNeedToLoginISwust:YES];
        //清楚所有cookies
        [[Config Instance]clearHttpCookie:@"ALL"];
        
//        if ([[aNotification.userInfo objectForKey:@"Message"]isEqualToString:ISwust_USER_Type_Teacher]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"遗憾" message:@"当前版本暂不支持教师账户" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//            [alert show];
//        }else
       //{
            
            
            if ([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"用户不存在"]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"抱歉，您还没有注册。注册后可享受教务处、图书馆、一卡通等功能一键登录，是否立即注册？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
                alertView.tag = 1;
                [alertView show];
            }else{
                
                [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
            }
            
       // }
 
    }else if ([aNotification.name isEqualToString:@"ISwust_Request_Notice"] ) {
        if (hud) {
            [hud hide:YES];
        }
        
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
        
    }else if ([aNotification.name isEqualToString:@"ISwust_SynchSystemAccount_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {

        if (hud) {
            [hud hide:YES];
        }
        
        [[Config Instance]saveIsNeedToUpdateNewsSubscribeChannel:YES];
        //保存登录状态
        [[Config Instance]saveIswustLoginStatus:Iswust_Login];
        
        
       
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:^(void){}];
        
    }

    
}
-(void)operationAfterRequestSuccess{
    //同步代理
   // [_iSwustServer ISwust_SynchProxyInfo];
    
  //  [[Config Instance]saveIswustUserNameAndPwd:self.txt_username.text andPwd:self.txt_pwd.text];
    
       //同步校园云账户服务
    if (_iSwustServer == nil) {
        _iSwustServer = [ISwustServerInterface new];
    }
    NSArray *array = [NSArray array];
    [_iSwustServer ISwust_SyncSystemAccount:array];
    
    
    NewsBL *newsbl = [NewsBL new];
    ///获取全部频道
    [newsbl getNewsAllChannel:@""];
    /////获取用户订阅的频道
    [newsbl getNewsSubChannel:self.txt_username.text];
    NSLog(@"self.txt_username.text:%@",self.txt_username.text);
    
}

- (IBAction)click_Login:(id)sender {
//
//    userinfo = [AccountNumberInfo new];
//    userinfo.userNumber = self.txt_username.text;
//    userinfo.userPassword = self.txt_pwd.text;
    
    if([Tools NetWorkIsOK]){
         [[Config Instance]saveIswustUserNameAndPwd:self.txt_username.text andPwd:self.txt_pwd.text];
    
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"我在登录..." andView:self.view andHUD:hud];
    
        //登录服务
        _iSwustServer = [ISwustServerInterface new];
        
    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 1:
                [self click_newUser:nil];
                break;
                
            default:
                break;
        }
    }
}


//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_username resignFirstResponder];
    [self.txt_pwd resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txt_username resignFirstResponder];
    [self.txt_pwd resignFirstResponder];
    return YES;
}

- (IBAction)click_newUser:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"DeanLoginVC"] animated:YES];
    //[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerNavVC"] animated:YES completion:nil];
}

- (IBAction)click_forgetPW:(id)sender {
    
  //  findPWVC
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"findPWVC"] animated:YES completion:nil];
}
@end
