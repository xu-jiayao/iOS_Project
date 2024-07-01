//
//  ExamViewController.m
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamBL.h"
#import "Exam.h"
#import "ExamTableViewCell.h"
#import "ExamParser.h"
//#import "DeanHttpRequestQueue.h"
#import "ISwustServerInterface.h"
#import "BaiduMobStat.h"
@interface ExamViewController ()
{
    MBProgressHUD *hud;
    NSArray *examDataArray;
    ExamTableViewCell *cell_Exam;
}

@property (weak, nonatomic) IBOutlet UIImageView *NOExamPic;
@property (weak,nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation ExamViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDo:) name:@"Dean_login_Notice" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"考试"];

    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateExam)];
    _refresh =[[UIRefreshControl alloc]init];
    [_refresh addTarget:self action:@selector(RefreshTableView) forControlEvents:UIControlEventValueChanged];
    [_refresh setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
    [_myTableView addSubview:_refresh];
    
    [self initData];
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)RefreshTableView{
    if (self.refresh.refreshing) {
        self.refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        
        [self updateExam];
        [self.refresh endRefreshing];
        
        
        [self.myTableView reloadData];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) selfNotificationDo:(NSNotification *)aNotifacation
{
    //处理Notification
    if ([aNotifacation.name isEqualToString:@"Dean_login_Notice"]){
        if([[aNotifacation.userInfo objectForKey:@"Message"]isEqualToString:Dean_Exam]){
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_ExamHttpRequest];
           
            [Tools ToastNotification:@"刷新完成"  andView:self.view andLoading:NO andIsBottom:NO];
            [self initData];

        }else if ([[aNotifacation.userInfo objectForKey:@"Message"] isEqualToString:@"学号或密码错误"] && [[aNotifacation.userInfo objectForKey:@"requestFlag"] isEqualToString:Dean_Exam]) {
            
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
        case 1://输入密码，导入考试
            
            if (buttonIndex == 1) {
                [[Config Instance]clearHttpCookie:Dean_login_cookie_Domain];
                
                UITextField *txt_Psw=[alertView textFieldAtIndex:0];
                AccountNumberInfo *user = [[Config Instance]getDeanUser];
                user.userPassword = txt_Psw.text;
                [[Config Instance]saveDeanUserNameAndPwd:user.userNumber andPwd:user.userPassword];
                
                [self updateExam];
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

-(void) initData{
    
    ExamBL *exambl = [ExamBL new];
    examDataArray = [NSArray new];
    examDataArray = [exambl readData];
    if (examDataArray.count != 0) {
        self.NOExamPic.hidden = YES;
        self.myTableView.hidden = NO;
        [self.myTableView reloadData];
    }else{
        self.NOExamPic.hidden = NO;
        self.myTableView.hidden = YES;
    }

    
    [self.myTableView reloadData];
    
    NSLog(@"examDataArray == %@",examDataArray);
}

-(void) updateExam{
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
        if ([[Config Instance]checkHttpCookie:Dean_login_cookie_Domain]) {
            NSLog(@"有教务处cookie");
            DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
            [httpRequest startDean_ExamHttpRequest];
            
            if (hud) {
                hud.hidden = YES;
            }
            
            [Tools ToastNotification:@"刷新完成"  andView:self.view andLoading:NO andIsBottom:NO];
            [self initData];
        }else{
            NSLog(@"没有教务处cookie");
            //重新登录教务处
            DeanLogin *deanLogin = [DeanLogin new];
            AccountNumberInfo *userinfo = [[Config Instance]getDeanUser];
            deanLogin.requestFlag = Dean_Exam;
            [deanLogin dean_login:userinfo];
        }

    }else{
         [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
   
}

- (int)examTime:(NSString *)examTime
{
//    NSString *day = [dateStr substringWithRange:NSMakeRange(8, 2)];
//    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
//    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
//    
//    //创建NSDateComponents对象
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    //设置NSDateComponents日期
//    [comps setDay:[day intValue]];
//    //设置NSDateComponents月
//    [comps setMonth:[month intValue]];
//    //设置NSDateComponents年
//    [comps setYear:[year intValue]];
//    //创建日历对象
//    NSCalendar *calender = [[NSCalendar alloc]
//                            initWithCalendarIdentifier:NSGregorianCalendar];
//    //获得考试日期的NSDate日期对象
//    NSDate *destinationDate = [calender dateFromComponents:comps];
//    
//    //获取北京时间
//    NSDate * seldate = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: seldate];
//    NSDate *now = [seldate dateByAddingTimeInterval: interval];
//    
//    //获得当前日期到考试日期时间的NSDateComponents对象
//    NSDateComponents *components = [calender components:NSDayCalendarUnit
//                                               fromDate:now toDate:destinationDate options:0];
//    
//    //获得当前日期到考试日期相差的天数
//    int days = [components day]+1;
    
/////////////////////////////////
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  senddate=[NSDate date];
    //结束时间
    NSDate *endTime = [dateFormatter dateFromString:examTime];
    //当前时间
    NSDate *nowTime= [dateFormatter dateFromString:[dateFormatter stringFromDate:senddate]];
    
    //得到相差秒数
    NSTimeInterval time=[endTime timeIntervalSinceDate:nowTime];
    
    return (int)time;
    
}



-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"考试"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"离开考试"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [examDataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (cell_Exam == nil) {
        cell_Exam = [tableView dequeueReusableCellWithIdentifier:@"examCell"];
    }
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExamTableViewCell" owner:nil options:nil];
        
    cell_Exam = [nib objectAtIndex:0];
    Exam *examItem = (Exam *)[examDataArray objectAtIndex:[indexPath row]];
    cell_Exam.selectionStyle = UITableViewCellSelectionStyleNone;
    cell_Exam.courseName.text = examItem.courseName;
    cell_Exam.classroom.text = examItem.examPlace;
    cell_Exam.dateString.text = examItem.examDate;
    cell_Exam.timeString.text = examItem.examTime;
    cell_Exam.weekString.text = examItem.examWeek;
    cell_Exam.seatNumber.text = examItem.seatNumber;
    
//    NSLog(@"day = %@",examItem.examDate);
//    NSLog(@"time = %@",examItem.examTime);
    
    NSString *examTime;
    NSString *examStartTime;
    
    examStartTime = [examItem.examTime substringWithRange:NSMakeRange(0,5)];
    
    examTime = [NSString stringWithFormat:@"%@ %@:00",examItem.examDate,examStartTime];
    
    int leftTime = [self examTime:examTime];
    
    NSLog(@"leftTime = %d",leftTime);
    
    NSString *countDown = [[NSString alloc]initWithFormat:@"%d",leftTime];
    
 //   NSLog(@"!!!!!! %@",countDown);
    
    cell_Exam.countDown = countDown;
    
    return cell_Exam;
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
