//
//  ScoreViewController.m
//  i西科
//
//  Created by weixvn_android on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ScoreViewController.h"
#import "ScoreBL.h"
#import "Score.h"
#import "ScoreTableViewCell.h"
#import "MBProgressHUD.h"
#import "DOPDropDownMenu.h"
#import "Tools.h"
#import "Config.h"
#import "DeanHttpRequestQueue.h"
#import "DeanLogin.h"
#import "ISwustLoginHttpRequest.h"
#import "ISwustServerInterface.h"
#import "BaiduMobStat.h"
@interface ScoreViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate,UIAlertViewDelegate>
{
    NSDictionary *dictByTerm;
    NSArray *arrForCurrentYear;
    NSString *termStr;
    NSArray *arrForCurTerm;
    NSArray *arrForYearStr;
    ScoreBL *bl ;
    NSUInteger COL_COUNT;
    MBProgressHUD *hud;
    NSArray *arrForPoint;
    ScoreTableViewCell *cell_Score;
}

@property (strong, nonatomic) IBOutlet UIView *noInformation;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ScoreViewController

static int yearTag = 0;

-(void)scoreInitData{
    if (dictByTerm == nil) {
        dictByTerm = [NSDictionary new];
    }
    
    if (arrForPoint == nil) {
        arrForPoint = [NSArray new];
    }
    if (bl == nil) {
        bl = [ScoreBL new];
    }
    
    arrForYearStr = [bl getArrForSchoolYear];
   
    if (arrForYearStr.count != 0) {
        NSString *schoolYearStr = [arrForYearStr objectAtIndex:yearTag];
        dictByTerm = [bl readWithSchoolYear:schoolYearStr];
        arrForPoint = [bl arrForPoint];
        arrForCurrentYear = [dictByTerm allKeys];
        self.noInformation.hidden = YES;
    }else{
        arrForYearStr = [NSArray arrayWithObject:@"当前没有更多信息"];
    }

    [self.myTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"成绩"];
    
    [self scoreInitData];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateScore)];
    
    _refreshControl =[[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_myTableView addSubview:_refreshControl];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDo:) name:@"Dean_login_Notice" object:nil];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                0, -5) andHeight:45];
    menu.backgroundColor = [Tools getMainColor];
    menu.indicatorColor = [Tools getMainColor];
    menu.textColor = [Tools getMainColor];

    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];

    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void) refreshTable
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        
        [self updateScore];
        [self.refreshControl endRefreshing];
        
        
        [self.myTableView reloadData];
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"成绩"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"离开成绩"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

-(void)updateScore{
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
//        //登录iswust服务
//        ISwustLoginHttpRequest *login = [ISwustLoginHttpRequest new];
//        [login justiSwustLoginHttpRequest];

        
        if ([[Config Instance]checkHttpCookie:Dean_login_cookie_Domain]) {
            NSLog(@"有教务处cookie");
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_ScoreHttpRequest];
            
            if (hud) {
                hud.hidden = YES;
            }
            
            [Tools ToastNotification:@"刷新完成"  andView:self.view andLoading:NO andIsBottom:NO];
            [self scoreInitData];
            //向服务器上传成绩
            ScoreBL *scorebl = [ScoreBL new];
            [scorebl uploadScore];
        }else{
            NSLog(@"没有教务处cookie");
            //重新登录教务处
            DeanLogin *deanLogin = [DeanLogin new];
            AccountNumberInfo *userinfo = [[Config Instance]getDeanUser];
            deanLogin.requestFlag = Dean_Score;
            [deanLogin dean_login:userinfo];
        }

    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
   
}


- (void) selfNotificationDo:(NSNotification *)aNotifacation
{
    //处理Notification
    if ([aNotifacation.name isEqualToString:@"Dean_login_Notice"]){
        if([[aNotifacation.userInfo objectForKey:@"Message"]isEqualToString:Dean_Score]){
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_ScoreHttpRequest];
            
            [Tools ToastNotification:@"刷新完成"  andView:self.view andLoading:NO andIsBottom:NO];
            [self scoreInitData];
            //向服务器上传成绩
            ScoreBL *scorebl = [ScoreBL new];
            [scorebl uploadScore];
            
            
            
        }else if([[aNotifacation.userInfo objectForKey:@"Message"]isEqualToString:Dean_Evaluate]){
            
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_EvaluateOnlineRequest];
            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"evaluateVC"] animated:YES];
        }else if ([[aNotifacation.userInfo objectForKey:@"Message"] isEqualToString:@"学号或密码错误"] && [[aNotifacation.userInfo objectForKey:@"requestFlag"] isEqualToString:Dean_Score]) {
            
            UIAlertView *deanAlert = [[UIAlertView alloc]initWithTitle:@"请重新输入教务处密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"导入",nil];
            deanAlert.tag = 1;
            deanAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [deanAlert show];
        }else{
            [Tools ToastNotification:@"连接超时"  andView:self.view andLoading:NO andIsBottom:NO];
      
        }
    }
    if (hud) {
        hud.hidden = YES;
    }
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (alertView.tag) {
        case 1://输入密码，导入成绩
            
            if (buttonIndex == 1) {
                [[Config Instance]clearHttpCookie:Dean_login_cookie_Domain];
                
                UITextField *txt_Psw=[alertView textFieldAtIndex:0];
                AccountNumberInfo *user = [[Config Instance]getDeanUser];
                user.userPassword = txt_Psw.text;
                [[Config Instance]saveDeanUserNameAndPwd:user.userNumber andPwd:user.userPassword];
                
                [self updateScore];
              
                [self syncServerAccount];
            }
            break;
               default:
            break;
    }
}


-(void)syncServerAccount{
    ISwustServerInterface *iSwustServer = [ISwustServerInterface new];
    
    AccountNumberInfo *deanUserinfo = [[Config Instance]getDeanUser];
  
    NSDictionary  *dictDean = [NSDictionary dictionaryWithObjects:@[@System_Dean,deanUserinfo.userNumber,deanUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSArray *array = [NSArray arrayWithObjects:dictDean, nil];
    
    [iSwustServer ISwust_SyncSystemAccount:array];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Drop down Menu data source
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    return arrForYearStr.count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    if (arrForYearStr.count > 0) {
        switch (indexPath.column) {
        case 0: return arrForYearStr[indexPath.row];
            break;
        default:
            return nil;
            break;
        }

    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath { 
    yearTag = indexPath.row;
    [self scoreInitData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[dictByTerm allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section//决定指定分区内包括多少个表格行
{
    termStr = [arrForCurrentYear objectAtIndex:section];
    
    arrForCurTerm = [dictByTerm objectForKey:termStr];
    
    COL_COUNT = [arrForCurTerm count];
    return COL_COUNT;
}

//-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    termStr = [arrForCurrentYear objectAtIndex:section];//该方法决定页眉控件
//    return  termStr;
////
//    
//   }

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //headerViewde height在StoryBoard中进行的设置  现在设置的为 30
    termStr = [arrForCurrentYear objectAtIndex:section];
    Score *item_Average;
    Score *item_Require;
    if (section == 1) {
        item_Average = [arrForPoint objectAtIndex:2];
        item_Require = [arrForPoint objectAtIndex:3];
    }else{
        item_Average = [arrForPoint objectAtIndex:0];
        item_Require = [arrForPoint objectAtIndex:1];
    }
        
    
    NSString *footer=[NSString stringWithFormat:@"  %@:%@      %@:%@",item_Average.course_name,item_Average.course_point,item_Require.course_name,item_Require.course_point];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    [headerView setBackgroundColor:[UIColor colorWithRed:148/255.f green:190/255.f blue:206/255.f alpha:1]];
    
    UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 2, 26, 26)];
    termLabel.text = termStr;
    termLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    termLabel.textAlignment = NSTextAlignmentCenter;
    termLabel.font = [UIFont systemFontOfSize:18];
    termLabel.backgroundColor = [Tools getMainColor];
 //   termLabel.viewForBaselineLayout.layer.cornerRadius = 5.0;
    
    [termLabel.layer setCornerRadius:CGRectGetHeight([termLabel bounds]) / 2];
    [termLabel setClipsToBounds:YES];
    [[termLabel layer] setBorderColor:[[Tools getMainColor]CGColor]];
    [[termLabel layer] setBorderWidth:2.75];
    
    [headerView addSubview:termLabel];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.bounds.size.width - 10, 26)];
    label.text = footer;
    label.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{//该方法指定页脚控件
//
//    Score *item_Average = [arrForPoint objectAtIndex:0];
//    Score *item_Require = [arrForPoint objectAtIndex:1];
//
//
//    NSString *footer=[NSString stringWithFormat:@"%@:%@      %@:%@",item_Average.course_name,item_Average.course_point,item_Require.course_name,item_Require.course_point];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
//    
//    [headerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
//    label.text = footer;
//    label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
//    label.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label];
//    
//    return headerView;
//    
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  //通过 [indexPath row] 遍历数组
{
    termStr = [arrForCurrentYear objectAtIndex:indexPath.section];
    arrForCurTerm = [dictByTerm objectForKey:termStr];

    if (cell_Score == nil ) {
        cell_Score = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    }
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil];
    
    cell_Score = [nib objectAtIndex:0];
    Score *scoreItem = (Score *)[arrForCurTerm objectAtIndex:[indexPath row]];
    
    
    cell_Score.tittleString.text = scoreItem.course_name;
    
    NSString * subtitle;
    if (![scoreItem.makeup_score isEqualToString:@" "]) {
        cell_Score.selectionStyle = UITableViewCellSelectionStyleNone;
        subtitle = [[NSString alloc] initWithFormat:@"补考成绩: %@ | 绩点: %@ | 学分: %@",scoreItem.makeup_score,scoreItem.course_point,scoreItem.course_credit];
    }else if(scoreItem.course_score.length > 6){
        cell_Score.selectionStyle = UITableViewCellSelectionStyleDefault;
        subtitle = [[NSString alloc] initWithFormat:@"-请先完成课程教学质量评价-"];
        cell_Score.detailString.textColor = [UIColor redColor];
    }else{
        cell_Score.selectionStyle = UITableViewCellSelectionStyleNone;
        subtitle = [[NSString alloc] initWithFormat:@"绩点: %@ | 学分: %@",scoreItem.course_point,scoreItem.course_credit];
    }
    cell_Score.detailString.text = subtitle;
    cell_Score.score = scoreItem.course_score;
    
    return cell_Score;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    termStr = [arrForCurrentYear objectAtIndex:indexPath.section];
    NSArray *arrForCurTerm1 = [dictByTerm objectForKey:termStr];
    
    Score *scoreItem = (Score *)[arrForCurTerm1 objectAtIndex:[indexPath row]];

    
    if (scoreItem.course_score.length > 6) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        //评教
        if ([[Config Instance]checkHttpCookie:Dean_login_cookie_Domain]) {
            NSLog(@"有教务处cookie");
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_EvaluateOnlineRequest];
            if (hud) {
                hud.hidden = YES;
            }
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"evaluateVC"] animated:YES];
            
            
            
        }else{
            NSLog(@"没有教务处cookie");
            //重新登录教务处
            DeanLogin *deanLogin = [DeanLogin new];
            AccountNumberInfo *userinfo = [[Config Instance]getDeanUser];
            deanLogin.requestFlag = Dean_Evaluate;
            [deanLogin dean_login:userinfo];
        }

    }
}



@end
