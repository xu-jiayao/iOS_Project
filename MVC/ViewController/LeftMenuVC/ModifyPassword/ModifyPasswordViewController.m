//
//  ModifyPasswordViewController.m
//  i西科
//
//  Created by MAC on 15/3/23.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MBProgressHUD.h"
#import "AccountNumberInfo.h"
@interface ModifyPasswordViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    MBProgressHUD *hud;
}

//@property(nonatomic ,strong)UITextField *activeField;
@end



@implementation ModifyPasswordViewController
@synthesize txt_FirstPwd,txt_oldPwd,txt_SecondPwd;


- (void)viewDidLoad {
    [super viewDidLoad];
    txt_FirstPwd.delegate = self;
    txt_oldPwd.delegate = self;
    txt_SecondPwd.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_changpassword_Notice" object:nil];
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"修改密码"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnLeft)];
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    [txt_oldPwd resignFirstResponder];
//    [txt_FirstPwd resignFirstResponder];
//    [txt_SecondPwd resignFirstResponder];
//}


-(void)selfNotificationDO:(NSNotification *)aNotification{
    if (hud) {
        [hud hide:YES];
    }
    NSLog(@"09090090%@",[aNotification.userInfo objectForKey:@"Message"]);
    
    //处理notification
    if ([aNotification.name isEqualToString:@"ISwust_changpassword_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        
        AccountNumberInfo *user = [[Config Instance]getISwustUser];
        [[Config Instance]saveIswustUserNameAndPwd:user.userNumber andPwd:txt_FirstPwd.text];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"修改密码成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        
    }else if ([aNotification.name isEqualToString:@"ISwust_changpassword_Notice"] && [[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"用户密码错误"]){
        
        
        [Tools ToastNotification:@"原密码输入错误"  andView:super.view andLoading:NO andIsBottom:NO];
        
    }else{
        [Tools ToastNotification:@"系统繁忙"  andView:super.view andLoading:NO andIsBottom:NO];
        //  [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)returnLeft {
    [self dismissViewControllerAnimated:YES completion:nil];
   
}



- (IBAction)click_modify:(id)sender {
    [txt_oldPwd resignFirstResponder];
    [txt_FirstPwd resignFirstResponder];
    [txt_SecondPwd resignFirstResponder];
    self.view.frame =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
    
    
    if ([txt_oldPwd.text isEqualToString:@""] || [Tools spaceString:txt_oldPwd.text]) {
        [Tools ToastNotification:@"请输入原密码"  andView:super.view andLoading:NO andIsBottom:NO];
    }else if ([Tools spaceString:txt_FirstPwd.text] || [Tools spaceString:txt_SecondPwd.text]){
        [Tools ToastNotification:@"密码不能为空格"  andView:self.view andLoading:NO andIsBottom:NO];
        
    }else{
        if([txt_FirstPwd.text isEqualToString:txt_SecondPwd.text])
        {
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
            
            
            //            //此处能否登录成功尚未判断
            //            // /// //
            //            ISwustLoginHttpRequest *login = [ISwustLoginHttpRequest new];
            //            [login justiSwustLoginHttpRequest];
            
            //修改密码服务
            ISwustServerInterface *_iSwustServer = [ISwustServerInterface new];
            [_iSwustServer ISwust_ChangePsd_oldPassword:txt_oldPwd.text newPassword:txt_FirstPwd.text];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不一致，请重试" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    
    
}


//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y +350 - (self.view.frame.size.height - 216);//键盘高度216
    NSLog(@"offset is %d",offset);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect rect = CGRectMake(0.0f, 60, self.view.frame.size.width, self.view.frame.size.height);
         self.view.frame = rect;
         [UIView commitAnimations];
        [textField resignFirstResponder];
       return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
}





/*

//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_oldPwd resignFirstResponder];
    [txt_FirstPwd resignFirstResponder];
     [txt_SecondPwd resignFirstResponder];
    [self resumeView];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txt_oldPwd resignFirstResponder];
    [txt_FirstPwd resignFirstResponder];
    [txt_SecondPwd resignFirstResponder];
    return YES;
}


- (IBAction)hidKeyboard:(id)sender {
    
    [self.txt_FirstPwd resignFirstResponder];
    [self.txt_oldPwd resignFirstResponder];
    [self.txt_SecondPwd resignFirstResponder];
   [sender resignFirstResponder];
    //[self resumeView];
    //[self increaseHalfView];
    [self increaseView];

}

- (IBAction)hideKeyboard1:(id)sender {
//    [self.txt_FirstPwd resignFirstResponder];
//    [self.txt_oldPwd resignFirstResponder];
//    [self.txt_SecondPwd resignFirstResponder];
//    
//    [sender resignFirstResponder];
    //[self resumeView];
    [self increaseView];
    

}

- (IBAction)hideKeyboard2:(id)sender {
//    [self.txt_FirstPwd resignFirstResponder];
//    [self.txt_oldPwd resignFirstResponder];
//    [self.txt_SecondPwd resignFirstResponder];
//    
//    [sender resignFirstResponder];
    //[self resumeView];
    [self increaseView];

}


-(void)increaseHalfView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = -50.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)increaseView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = -100.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 100.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

*/



@end
