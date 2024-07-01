//
//  AccountDetailViewController.m
//  i西科
//
//  Created by MAC on 15/3/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "ISwustServerInterface.h"
#import "ISwustLoginHttpRequest.h"
@interface AccountDetailViewController ()<UITextFieldDelegate>
{
    NSDictionary  *dict;
}
@property (strong, nonatomic) IBOutlet UITextField *txt_psw;

@property (strong, nonatomic) IBOutlet UILabel *label_SystemName;
@property (weak, nonatomic) IBOutlet UITextField *txt_userNum;

@end

@implementation AccountDetailViewController
@synthesize userinfo;
@synthesize systemFlag;
-(void)showSystemName{
    switch (systemFlag) {
        case 0:
            self.label_SystemName.text = @"教务处";
            break;
        case 1:
            self.label_SystemName.text = @"一卡通";
            break;
        case 2:
            self.label_SystemName.text = @"图书馆";
            break;
        case 3:
            self.label_SystemName.text = @"实验中心";
            break;
        default:
            break;
    }
}

-(void)selfNotificationDO:(NSNotification *)aNotification{
//    if (hud) {
//        [hud hide:YES];
//    }
    //处理notification
    if ([aNotification.name isEqualToString:@"ISwust_SynchSystemAccount_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        [Tools ToastNotification:@"修改成功"  andView:super.view andLoading:NO andIsBottom:NO];
        [NSThread sleepForTimeInterval:0.6];
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [Tools ToastNotification:@"系统繁忙"  andView:super.view andLoading:NO andIsBottom:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_SynchSystemAccount_Notice" object:nil];
    
    self.txt_userNum.text = userinfo.userNumber;
    self.txt_psw.text = userinfo.userPassword;
    
    [self showSystemName];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveSystemPsw)];
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)saveSystemPsw{

    switch (systemFlag) {
        case 0:
            [[Config Instance]saveDeanUserNameAndPwd:self.txt_userNum.text andPwd:self.txt_psw.text];
            //同步到服务器
            dict = [NSDictionary dictionaryWithObjects:@[@System_Dean,self.txt_userNum.text,self.txt_psw.text,@""] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
            break;
        case 1:
            [[Config Instance]saveECardUserNameAndPwd:self.txt_userNum.text andPwd:self.txt_psw.text];
            //同步到服务器
            dict = [NSDictionary dictionaryWithObjects:@[@System_ECard,self.txt_userNum.text,self.txt_psw.text,@""] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
            break;
        case 2:
            [[Config Instance]saveLibraryUserNameAndPwd:self.txt_userNum.text andPwd:self.txt_psw.text];
            //同步到服务器
            dict = [NSDictionary dictionaryWithObjects:@[@System_Library,self.txt_userNum.text,self.txt_psw.text,@""] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
            break;
        case 3:
            [[Config Instance]saveLabUserNameAndPwd:self.txt_userNum.text andPwd:self.txt_psw.text];
            //同步到服务器
            dict = [NSDictionary dictionaryWithObjects:@[@System_Lab,self.txt_userNum.text,self.txt_psw.text,@""] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
            break;
        default:
            break;
    }
//    ISwustLoginHttpRequest *login = [ISwustLoginHttpRequest new];
//    [login justiSwustLoginHttpRequest];
    
    ISwustServerInterface *_iSwustServer = [ISwustServerInterface new];
    
    NSArray *array = [NSArray arrayWithObjects:dict,nil];
    [_iSwustServer ISwust_SyncSystemAccount:array];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请确保修改后的密码与相应校务系统的密码一致。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [alert show];
}


//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_psw resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txt_psw resignFirstResponder];
    return YES;
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
