//
//  LibraryViewController.m
//  i西科
//
//  Created by MAC on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "LibraryViewController.h"
#import "LibraryCurrentBL.h"
#import "LibraryHistoryBL.h"
#import "LibraryRenew.h"
#import "KxMenu.h"
#import "LibTableViewCell.h"
#import "HistoryTable.h"
#import "CurrentTable.h"
#import "LibraryLogin.h"
#import "AccountNumberInfo.h"
#import "MBProgressHUD.h"
#import "TopLendVC.h"
#import "ISwustServerInterface.h"
#import "MJRefresh.h"
#import "BaiduMobStat.h"
@interface LibraryViewController ()<UIAlertViewDelegate>
{
    LibraryCurrentBL *libCurBL;
    NSMutableArray *arrForCurAll;
    
    LibraryHistoryBL *historyBL;
    NSMutableArray *arrForHistory;
    
    LibraryRenew * librenew;
    NSString * barcode,*barcheck;
    
    LibTableViewCell *cell_Lib;
    
    MBProgressHUD *hud;
    

 
}
@property int catalog;
@end

@implementation LibraryViewController
@synthesize catalog;

-(void)isLogin{
    AccountNumberInfo *user = [[Config Instance]getLibraryUser];
    if ([user.userPassword isEqualToString:@""]) {
        UIAlertView *labAlert = [[UIAlertView alloc]initWithTitle:@"请输入图书馆密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"导入",nil];
        labAlert.tag = 2;
        labAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [labAlert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //tag==1 :续借
    //tag==2 :输入密码并导入
    if (catalog == 0 && alertView.tag ==1 ) {
        if (buttonIndex == 1   ) {
            librenew = [LibraryRenew new];
            [librenew initWithRENEWURL:barcode barCheck:barcheck];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex == 1   ) {
            AccountNumberInfo *user = [[Config Instance]getLibraryUser];
            UITextField *txt_LibPsw=[alertView textFieldAtIndex:0];
            NSLog(@"txt_LibPsw.text == %@",txt_LibPsw.text);
            [[Config Instance]saveLibraryUserNameAndPwd:user.userNumber andPwd:txt_LibPsw.text];
            [self updateLibrary];
            [self syncServerAccount];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"图书馆"];
    
    [self isLogin];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_Update_Notice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_SearchBook_Notice" object:nil];
    self.title = @"图书馆";
    //  self.myTableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clearBG"]];
    
    catalog = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(viewChangeTo_TopLendView)];
    
    UIView *backgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, -60, self.view.frame.size.width, 103)];
    backgroungView.backgroundColor = [UIColor clearColor];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"当前借阅", @"借阅历史",nil];
    //初始化UISegmentedControl
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.cornerRadius = 5.0;
    segmentedControl.frame = CGRectMake((self.view.frame.size.width-280.0)/2,67, 280, 30.0);
    segmentedControl.backgroundColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [Tools getMainColor];
    //有基本四种样式
    [segmentedControl addTarget:self action:@selector(LibSegmentAction:) forControlEvents:UIControlEventValueChanged];  //添加委托方法
    [backgroungView addSubview:segmentedControl];
    [self.view addSubview:backgroungView];
    
    [self getLibraryData];
    
    //添加下拉刷新方式
    [self setupRefresh];
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


-(void)selfNotificationDO:(NSNotification *)aNotification
{
    if (hud) {
        [hud hide:YES];
    }
    
    //处理notification
    if ([aNotification.name isEqualToString:@"Library_Update_Notice"]) {
        if ([[aNotification.userInfo objectForKey:@"Message"]isEqualToString:SUCCESS]) {
            
            [Tools ToastNotification:@"刷新完成"  andView:self.view andLoading:NO andIsBottom:NO];
            [self getLibraryData];
            
        }else{
            [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myTableView headerEndRefreshing];
            [self.noBorrowPicScrollView headerEndRefreshing];
            
            [self isLogin];
        }
        
    }
    
    
}

-(void)syncServerAccount{
    ISwustServerInterface *iSwustServer = [ISwustServerInterface new];
    
    AccountNumberInfo *libUserinfo = [[Config Instance]getLibraryUser];
    
    NSDictionary  *dictLib = [NSDictionary dictionaryWithObjects:@[@System_Library,libUserinfo.userNumber,libUserinfo.userPassword,@"iOS"] forKeys:@[@"system_id",@"user_system_account",@"user_system_password",@"user_system_mark"]];
    
    NSArray *array = [NSArray arrayWithObjects:dictLib, nil];
    
    [iSwustServer ISwust_SyncSystemAccount:array];
    
}

-(void)getLibraryData{
    if (libCurBL == nil) {
        libCurBL = [LibraryCurrentBL new];
    }
    
    if (historyBL == nil) {
        historyBL = [LibraryHistoryBL new];
    }
    
    if (arrForCurAll == nil) {
        arrForCurAll = [NSMutableArray new];
    }
    
    if (arrForHistory == nil) {
        arrForHistory = [NSMutableArray new];
    }
    
    arrForCurAll = [libCurBL findData];
    arrForHistory = [historyBL findData];
    
    if (arrForCurAll.count == 0 && catalog == 0) {
        self.noBorrowPicScrollView.hidden = NO;
        self.myTableView.hidden = YES;
    }else{
        self.noBorrowPicScrollView.hidden = YES;
        self.myTableView.hidden = NO;
    }
    
    [self.myTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [self.myTableView headerEndRefreshing];
    [self.noBorrowPicScrollView headerEndRefreshing];

}

-(void)LibSegmentAction:(UISegmentedControl *)Seg{
    NSLog(@"Seg.selectedSegmentIndex === %d",(unsigned)Seg.selectedSegmentIndex);
    catalog = (unsigned)Seg.selectedSegmentIndex;
    if (arrForCurAll.count == 0 && catalog == 0) {
        self.noBorrowPicScrollView.hidden = NO;
        self.myTableView.hidden = YES;
    }else{
        self.noBorrowPicScrollView.hidden = YES;
        self.myTableView.hidden = NO;
    }

    [self.myTableView reloadData];
}

-(void)searchBookWait{
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
        
    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
}
-(void)updateLibrary{
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
        AccountNumberInfo *user = [[Config Instance]getLibraryUser];
        LibraryLogin *update = [LibraryLogin new];
        [update library_login:user authcode:@"123"];
        
    }else{
        [self.myTableView headerEndRefreshing];
        
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
    
}
-(void)viewChangeTo_TopLendView{

    TopLendVC *topLendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"topLendVC"];
    //topLendVC.books = books;
    [self.navigationController pushViewController:topLendVC animated:YES];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    // [myTableView headerBeginRefreshing];
  
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.myTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.myTableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.myTableView.headerRefreshingText = @"刷新中...";
    
    [self.noBorrowPicScrollView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#warning 自动刷新(一进入程序就下拉刷新)
    // [myTableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.noBorrowPicScrollView.headerPullToRefreshText = @"下拉可以刷新了";
    self.noBorrowPicScrollView.headerReleaseToRefreshText = @"松开马上刷新";
    self.noBorrowPicScrollView.headerRefreshingText = @"刷新中...";
    

    
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"图书馆"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"离开图书馆"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self updateLibrary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dataSource and delegate
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (catalog == 1){
//        NSString *header = [NSString stringWithFormat:@"历史借阅了: %d 本",(unsigned)[arrForHistory count]];
//        return header;
//    }else if (catalog == 2){
//        NSString *header = @"热门借阅:";
//        return header;
//    }
//    return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *header = nil;
    if (catalog == 1){
        header = [NSString stringWithFormat:@"  历史借阅: %d 本",(unsigned)[arrForHistory count]];
    }else if (catalog == 0){
        header = [NSString stringWithFormat:@"  当前借阅: %d 本",(unsigned)[arrForCurAll count]];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    [headerView setBackgroundColor:[UIColor colorWithRed:148/255.f green:190/255.f blue:206/255.f alpha:1]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.bounds.size.width - 10, 26)];
    label.text = header;
    label.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;

}

//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 65;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (catalog == 0) {
        return [arrForCurAll count];
    }else{
        return [arrForHistory count];
    }

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (cell_Lib == nil) {
        cell_Lib= [tableView dequeueReusableCellWithIdentifier:@"libCell"];
    }
    
    //cell.backgroundColor = [UIColor clearColor];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LibTableViewCell" owner:nil options:nil];
    cell_Lib = [nib objectAtIndex:0];
    
    if (catalog == 0) {
        CurrentTable *currentItem = [arrForCurAll objectAtIndex:indexPath.row];
        cell_Lib.bookFirstName.text = [currentItem.BOOKNAME substringToIndex:1];
        cell_Lib.bookName.text = currentItem.BOOKNAME;
        cell_Lib.detail.text = currentItem.WRITER;
        
    }else if(catalog == 1){
        HistoryTable *historyItem = [arrForHistory objectAtIndex:indexPath.row];
        cell_Lib.bookName.text = historyItem.BOOKNAME;
        cell_Lib.bookFirstName.text = [historyItem.BOOKNAME substringToIndex:1];
        cell_Lib.detail.text = historyItem.WRITER;
    }
    return cell_Lib;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (catalog == 0) {
        CurrentTable *item2 = [arrForCurAll objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",item2.BOOKNAME] message:[NSString stringWithFormat:@"作者:  %@\n借书时间:  %@\n应还时间:  %@",item2.WRITER,item2.RENTDATA,item2.BACKDATA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"续借", nil];
        alertView.tag = 1;
        [alertView show];
        
        barcode = item2.barcode;
        barcheck = item2.barcheck;
    }else if(catalog == 1){
        HistoryTable *item2 = [arrForHistory objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",item2.BOOKNAME] message:[NSString stringWithFormat:@"作者:  %@\n借阅日期:  %@\n归还日期:  %@",item2.WRITER,item2.RENTDATA,item2.BACKDATA] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        
    }
}

@end
