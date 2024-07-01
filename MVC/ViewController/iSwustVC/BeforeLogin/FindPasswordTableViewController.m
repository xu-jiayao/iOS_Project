//
//  FindPasswordTableViewController.m
//  i西科
//
//  Created by 陈识宇 on 15-1-22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "FindPasswordTableViewController.h"
#import "Config.h"
#import "MBProgressHUD.h"
#import "ChangePasswordViewController.h"
#import "AccountNumberInfo.h"

@interface FindPasswordTableViewController ()<UITextFieldDelegate>
{
    MBProgressHUD *hud;
    
}
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UIButton *selectBirthdayBtn;

@end

@implementation FindPasswordTableViewController
@synthesize txt_Number;
@synthesize txt_Name;
@synthesize txt_IDCard;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    AccountNumberInfo *userinfo;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_FindPassword_Notice" object:userinfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_Request_Notice" object:nil];
    
    //self.selectBirthdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBirthdayBtn addTarget:self action:@selector(show_selectDatePicker)forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(FindBack)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelOperation)];
    
    
    self.datePickerView.datePickerMode=UIDatePickerModeDate;
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    [self.datePickerView setLocale:locale];
    
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
        hud.hidden = YES;
    }
    if ([aNotification.name isEqualToString:@"ISwust_FindPassword_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        AccountNumberInfo *user = aNotification.object;
        
        [[Config Instance]saveIswustUserNameAndPwd:user.userNumber andPwd:user.userPassword];
        
        [[Config Instance]saveIsNeedToLoginISwust:YES];
        [[Config Instance]clearHttpCookie:ISwust_Server_cookie_Domain];
        ChangePasswordViewController *changeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"changpasswordVC"];
        changeVC.oldpassword = user.userPassword;
        [self.navigationController pushViewController:changeVC animated:YES];
        
    }else if ([aNotification.name isEqualToString:@"ISwust_FindPassword_Notice"] && ![[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
        
    }else if ([aNotification.name isEqualToString:@"ISwust_Request_Notice"] ) {
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }
}

-(void)show_selectDatePicker{
    [self textFieldShouldReturn:nil];
    
    if (self.datePickerView.hidden) {
        [Tools ViewAnimation:self.datePickerView willHidden:NO];
    }
}

-(void)cancelOperation{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)FindBack{
    [[Config Instance]saveIsNeedToLoginISwust:NO];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
    
    //获取日期显示器选择的时间
    NSDate *theDate = self.datePickerView.date;
    //[theDate descriptionWithLocale:[NSLocale currentLocale]];
    
    //    //更改日期格式v
    //    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    //
    //    NSString *birthdayString = [NSString stringWithFormat:@"%@ 00:00:00",[dateFormatter stringFromDate:theDate]];
    //
    NSString *dateString = [NSString stringWithFormat:@"%@",theDate];
    
    NSString *birthdayString = [NSString stringWithFormat:@"%@ 00:00:00",[dateString substringToIndex:10]];
    //判断是否填写完
    NSLog(@"  ============ %@",txt_Number.text);
    if ([txt_Number.text isEqualToString:@""] || [txt_IDCard.text isEqualToString:@""] || [txt_Name.text isEqualToString:@""] || [birthdayString isEqualToString:@""]) {
        
        if (hud) {
            hud.hidden = YES;
        }
        [Tools ToastNotification:@"请完整填写所有个人信息"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    else if([Tools spaceString:txt_Number.text] || [Tools spaceString:txt_Name.text] || [Tools spaceString:txt_IDCard.text] || [Tools spaceString:birthdayString]){
        if (hud) {
            hud.hidden = YES;
        }
        [Tools ToastNotification:@"填写信息中不能用空格"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    //找回密码服务
    else{
        _iSwustServer = [ISwustServerInterface new];
        [_iSwustServer ISwust_FindPsw_userNumber:txt_Number.text userName:txt_Name.text IDCard:txt_IDCard.text birthday:birthdayString];
    }
}


//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.txt_Number resignFirstResponder];
    [self.txt_Name resignFirstResponder];
    [self.txt_IDCard resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.txt_Number resignFirstResponder];
    [self.txt_Name resignFirstResponder];
    [self.txt_IDCard resignFirstResponder];
    return YES;
}




@end
