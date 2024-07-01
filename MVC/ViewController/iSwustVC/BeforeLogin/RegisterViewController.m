//
//  RegisterViewController.m
//  i西科
//
//  Created by weixvn_android on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "ISwustUserInfo.h"
#import "NewsBL.h"
#import "DeanPersonalBL.h"
@interface RegisterViewController ()
{
    MBProgressHUD *hud;
    ISwustUserInfo *iswustUserInfo;
    
}
@property (weak, nonatomic) IBOutlet UIButton *registerBtn_BGV;
@property (weak, nonatomic) IBOutlet UIView *txt_nickName_BGV;
@end

@implementation RegisterViewController
@synthesize registername;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_Register_Notice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_Request_Notice" object:nil];
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"注册"];
    
    self.txt_nickName_BGV.layer.cornerRadius = 8.0;
    self.registerBtn_BGV.layer.cornerRadius = 6.0;
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view.
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
    if ([aNotification.name isEqualToString:@"ISwust_Register_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        
        [[Config Instance]saveIsNeedToLoginISwust:YES];
        [[Config Instance]clearHttpCookie:ISwust_Server_cookie_Domain];
        if (_iSwustServer == nil) {
            _iSwustServer = [ISwustServerInterface new];
        }
        [self operationAfterRequestSuccess];
        
    }else if([aNotification.name isEqualToString:@"ISwust_Register_Notice"] && ![[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]){
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }else if ([aNotification.name isEqualToString:@"ISwust_Request_Notice"]){
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }
}

- (IBAction)RegisterBT:(id)sender {
    
    if ([Tools spaceString:registername.text] || [registername.text isEqualToString:@""]) {
        [Tools ToastNotification:@"请输入用户名"  andView:self.view andLoading:NO andIsBottom:NO];
    }else{
        if ([Tools NetWorkIsOK]) {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [Tools showHUD:@"正在注册" andView:self.view andHUD:hud];
            
            //NO:不用先进行server登录
            [[Config Instance]saveIsNeedToLoginISwust:NO];
            [[Config Instance]saveIswustUserNikName:registername.text];
            
            //注册服务
            ISwustServerInterface *iswustinterface = [ISwustServerInterface new];
            [iswustinterface ISwust_Register:registername.text];
            
        }else{
            [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
        }
    }
}

-(void)operationAfterRequestSuccess{
   
   // [self performSelectorInBackground:@selector(syncUserInfomation) withObject:nil];
    [self syncUserInfomation];
    
    [[Config Instance]saveIsNeedToUpdateNewsSubscribeChannel:YES];
    //保存登录状态
    [[Config Instance]saveIswustLoginStatus:Iswust_Login];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)syncUserInfomation{
    
    
    //同步个人信息
    iswustUserInfo = [ISwustUserInfo new];
    iswustUserInfo.nick_name = [[Config Instance]getIswustUserNikName];
    iswustUserInfo.user_signature = @"";
    iswustUserInfo.user_qq = @"";
    iswustUserInfo.user_email = @"";
    iswustUserInfo.user_tel = @"";
    iswustUserInfo.user_bedroom = @"";
    iswustUserInfo.user_hometown = @"";
    
    [_iSwustServer ISwust_SynchUserInfo:iswustUserInfo];
    
    //同步校园云账户
    AccountNumberInfo *deanUserinfo = [[Config Instance]getDeanUser];
    AccountNumberInfo *ecardUserinfo = [[Config Instance]getECardUser];
    AccountNumberInfo *labUserinfo = [[Config Instance]getLabUser];
    AccountNumberInfo *libraryUserinfo = [[Config Instance]getLibraryUser];
    
    NSDictionary  *dictDean = [NSDictionary dictionaryWithObjects:@[@System_Dean,deanUserinfo.userNumber,deanUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSDictionary  *dictEcard = [NSDictionary dictionaryWithObjects:@[@System_ECard,ecardUserinfo.userNumber,ecardUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSDictionary  *dictLab = [NSDictionary dictionaryWithObjects:@[@System_Lab,labUserinfo.userNumber,labUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSDictionary  *dictLibrary = [NSDictionary dictionaryWithObjects:@[@System_Library,libraryUserinfo.userNumber,libraryUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSArray *array = [NSArray arrayWithObjects:dictDean,dictEcard,dictLibrary,dictLab, nil];
    
    [_iSwustServer ISwust_SyncSystemAccount:array];
    
    
    
    DeanPersonalBL *personalBL = [DeanPersonalBL new];
    DeanPersonal *item = [personalBL findPersoanlData];
    
    ////////////////订阅默认频道
    NewsBL *newsbl = [NewsBL new];
    int channelID = [newsbl findChannelID:item.department];
    if(channelID != -1)
    {
        [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:channelID];
        //        [newsbl manageChannel:@"1" channelID:channelID];
    }
    [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:1];
    [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:2];
    [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:18];
    [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:2];
    [_iSwustServer Iswust_ManagerNewsChannel:@"1" channelID:3];
    
    //    [newsbl manageChannel:@"1" channelID:1];//学校新闻
    //    [newsbl manageChannel:@"1" channelID:4];//教务处
    //    [newsbl manageChannel:@"1" channelID:18];//图书馆
    //    [newsbl manageChannel:@"1" channelID:2];//西科驾校
    //    [newsbl manageChannel:@"1" channelID:3];//招聘就业
    

}

- (IBAction)finshEdit:(id)sender {
    [sender resignFirstResponder];
}

//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.registername resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.registername resignFirstResponder];
    return YES;
}


@end
