//
//  ChangePasswordViewController.m
//  i西科
//
//  Created by weixvn_android on 15/1/21.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ISwustLoginHttpRequest.h"
@interface ChangePasswordViewController ()<UIAlertViewDelegate>
{
    MBProgressHUD *hud;
}

@end

@implementation ChangePasswordViewController
@synthesize oldpassword;
@synthesize txt_newpassword;
@synthesize txt_surepassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"oldpassword == %@",oldpassword);
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_changpassword_Notice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_Request_Notice" object:nil];
  
    
    
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

-(void)selfNotificationDO:(NSNotification *)aNotification{
    if (hud) {
        [hud hide:YES];
    }
     NSLog(@"oldpassword 2323232323");
    //处理notification
    if ([aNotification.name isEqualToString:@"ISwust_changpassword_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改密码成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];

       
        
    }else if ([aNotification.name isEqualToString:@"ISwust_changpassword_Notice"] && ![[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]){
        [Tools ToastNotification:@"系统繁忙"  andView:super.view andLoading:NO andIsBottom:NO];
        
    }else if ([aNotification.name isEqualToString:@"ISwust_Request_Notice"]){
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


- (IBAction)Surechangepassword:(id)sender {
    if (![Tools spaceString:txt_newpassword.text] || [Tools spaceString:txt_surepassword.text]) {
        [Tools ToastNotification:@"请输入密码"  andView:self.view andLoading:NO andIsBottom:NO];
        
    }else{
        
        if([txt_newpassword.text isEqualToString:txt_surepassword.text])
        {
            if ([Tools NetWorkIsOK]) {
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [Tools showHUD:@"施工中...." andView:self.view andHUD:hud];
                
                [[Config Instance]saveIswustLoginStatus:Iswust_Login];
                //修改密码服务
                _iSwustServer = [ISwustServerInterface new];
                [_iSwustServer ISwust_ChangePsd_oldPassword:oldpassword newPassword:txt_newpassword.text];
                
            }else{
                [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不一致，请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    
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
