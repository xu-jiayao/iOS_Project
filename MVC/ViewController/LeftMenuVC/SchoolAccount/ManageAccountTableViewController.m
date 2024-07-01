//
//  ManageAccountTableViewController.m
//  i西科
//
//  Created by MAC on 15/3/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ManageAccountTableViewController.h"
#import "Config.h"
#import "AccountNumberInfo.h"
#import "AccountDetailViewController.h"
@interface ManageAccountTableViewController ()<UIAlertViewDelegate>

@end

@implementation ManageAccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"校园账户";
    
    [self showAlertView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnLeft)];
    
    
}

-(void)showAlertView{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入i西科系统密码" message:@"校园帐号是i西科为您保存的帐号，方面一键登录，修改后并不能修改相关校务系统的密码。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = 1;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AccountNumberInfo *user = [[Config Instance]getISwustUser];
    switch (alertView.tag) {
        case 1:{
            if (buttonIndex == 1) {
                UITextField *txt_accountPsw=[alertView textFieldAtIndex:0];
                NSLog(@"txt_accountPsw == %@",txt_accountPsw.text);
                
                if (![user.userPassword isEqualToString:txt_accountPsw.text]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"密码错误" message:@"i西科密码为注册i西科时所填写的密码，默认为教务处系统密码。" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"重试", nil];
                    alert.tag = 2;
                    [alert show];
                }
            }else{
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        case 2:
        {
            if (buttonIndex == 1) {
                [self showAlertView];
            }else{
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)pushToDetailVC:(AccountNumberInfo *)userInfo systemFlag:(int)index{
    
    AccountDetailViewController *accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountDetailVC"];
    accountVC.userinfo = userInfo;
    accountVC.systemFlag = index;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnLeft {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountNumberInfo *userinfo = [AccountNumberInfo new];
    
    switch (indexPath.section) {
        case 0://教务处
            userinfo = [[Config Instance]getDeanUser];
            break;
        case 1://一卡通
            userinfo = [[Config Instance]getECardUser];
            break;
        case 2://图书馆
            userinfo = [[Config Instance]getLibraryUser];
            break;
        case 3://实验中心
            userinfo = [[Config Instance]getLabUser];
            break;
        default:
            break;
    }
    [self pushToDetailVC:userinfo systemFlag:indexPath.section];
}





@end
