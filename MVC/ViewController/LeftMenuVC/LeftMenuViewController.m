//
//  LeftMenuViewController.m
//  i西科
//
//  Created by MAC on 15/1/11.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ISwustServerInterface.h"
#import "ISwustLoginHttpRequest.h"
#import "ISwustUserInfo.h"
#import "IswustUserInfoBL.h"
#import "XTSideMenu.h"

#import "ShowUserInformation.h"
#import "DeanPersonalBL.h"
#import "ScoreBL.h"
#import "CourseTableBL.h"
#import "ExamBL.h"
#import "LibraryCurrentBL.h"
#import "LibraryHistoryBL.h"
#import "UMFeedback.h"

#import "ManageChannelDAO.h"
#import "UMComLoginManager.h"
#import "NewsBL.h"

#import "LeftMenuTableViewCell.h"

#import "PluginCourseTableDAO.h"

#define IMAGEWIDTH kScreenW * 0.625

@interface LeftMenuViewController (){
    LeftMenuTableViewCell *leftBgCell;
    IswustUserInfoBL *userBL;
    ISwustUserInfo *userInfo;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@property (nonatomic, strong)UIView *userView;

@property (nonatomic, strong)UIImageView *userPhoto;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *userClassLabel;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UINavigationController *
    //float imageWidth = kScreenW * 0.625;
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, self.view.frame.size.height)];
    
    bgImageView.image = [UIImage imageNamed:@"Bkg"];
    
    [self.view addSubview:bgImageView];
    
    
    
    self.tableView = ({
        //         UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(40, ((self.view.frame.size.height - 60 * 5) / 2.0f)+20, self.view.frame.size.width-40, 60 * 5) style:UITableViewStylePlain];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ((self.view.frame.size.height - 60 * 5) / 2.0f)+20, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        //
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        [tableView setSeparatorInset:UIEdgeInsetsMake(4,0,0,2)];
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    //设置注销页面
    [self setLoginOutView];
    
    [self setupView];
    
    //把self.shareBGView设置在最前面
    //    [self.view bringSubviewToFront:self.shareBGView];
    
}

-(void)setupView{
    
    _userView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 200 , 80)];
    //设置头像位置
    _userPhoto = [[UIImageView alloc]initWithFrame:CGRectMake(20, 18, 60, 61)];
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 25, 80, 30)];
    _userClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, 90, 25)];
}


-(void)viewWillAppear:(BOOL)animated{//选取图片的时候这里会被调用？
    [super viewWillAppear:YES];
    //  [self setUserInfo];
    //设置个人信息
    [self setupPersonalInfo];
}

- (void)setLoginOutView{
    UIView *logoutView = [[UIView alloc]initWithFrame:CGRectMake(109, self.view.frame.size.height - 54, 100, 54)];
    
    UIImageView *logoutImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 16, 16, 20)];
    logoutImageView.image = [UIImage imageNamed:@"Logout"];
    [logoutView addSubview:logoutImageView];
    
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutBtn.backgroundColor = [UIColor clearColor];
    //    [loginoutBtn setImage:[UIImage imageNamed:@"guanji"] forState:UIControlStateNormal];
    [loginoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    //    [loginoutBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 12)];
    
    loginoutBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [loginoutBtn setTitleColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.73] forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:177/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    //    loginoutBtn.titleLabel.tintColor =[UIColor colorWithRed:248/255.0 green:248/255.0 blue:35/255.0 alpha:1.0];
    loginoutBtn.frame = CGRectMake(18, 3, 50, 50);
    //添加点击事件
    [loginoutBtn addTarget:self action:@selector(loginOutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [logoutView addSubview:loginoutBtn];
    [self.view addSubview:logoutView];
    
    //[self.view addSubview:loginoutBtn];
}




-(void)setupPersonalInfo{
    userBL = [IswustUserInfoBL new];
    userInfo = [userBL findData];
    
    
    //    userPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userInfo.user_photo_link]]];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",userInfo.user_number];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        _userPhoto.image = [UIImage imageWithData:imageData];
    }else{
        _userPhoto.image = [UIImage imageNamed:@"i西科"];
    }
    _userPhoto.layer.cornerRadius = _userPhoto.frame.size.width/2;
    _userPhoto.clipsToBounds = YES;
    
    
    
    
    _userNameLabel.text = userInfo.user_name;
    _userNameLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20];
    [_userNameLabel setTextColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.73]];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    //userNameLabel.backgroundColor = [UIColor redColor];
    
    
    
    _userClassLabel.text = userInfo.user_class;
    _userClassLabel.font = [UIFont fontWithName:@"Heiti TC" size:13];
    _userClassLabel.textAlignment = NSTextAlignmentCenter;
    //userClassLabel.backgroundColor = [UIColor redColor];
    [_userClassLabel setTextColor:[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.73]];
    
    [_userView addSubview:_userPhoto];
    [_userView addSubview:_userNameLabel];
    [_userView addSubview:_userClassLabel];
    [self.view addSubview:_userView];
    
    UILabel *margin = [[UILabel alloc]initWithFrame:CGRectMake(4, 140, 200 - 8, 0.2)];
    margin.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.73];
    [self.view addSubview:margin];
}


- (void)loginOutButtonClicked{
    NSLog(@"点击注销");
    //注销
    [UMComLoginManager userLogout];
    
    ISwustServerInterface *_iSwustServer = [ISwustServerInterface new];
    [_iSwustServer Iswust_LoginOut];
    
    [self performSelectorInBackground:@selector(clearALLUserData) withObject:nil];
    
    [[Config Instance]saveIswustLoginStatus:Iswust_logout];
    [[Config Instance]saveRequestNeeded:NO];
    
    UIStoryboard *iswustSB = [UIStoryboard storyboardWithName:@"ISwustSB" bundle:nil];
    UINavigationController *navRootVC = [[UINavigationController alloc]initWithRootViewController:[iswustSB instantiateInitialViewController]];
    
    
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:navRootVC animated:YES completion:^(void){}
     ];
    
}


-(void)clearALLUserData{
    IswustUserInfoBL *userBL = [IswustUserInfoBL new];
    ISwustUserInfo *iswustUserInfo = [ISwustUserInfo new];
    
    iswustUserInfo = [userBL findData];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",iswustUserInfo.user_number];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        [fileManager removeItemAtPath:fullPath error:nil];
    }
    [userBL removeData];
    
    DeanPersonalBL *deanPersonal = [DeanPersonalBL new];
    [deanPersonal deleteData];
    
    ScoreBL *scoreBL = [ScoreBL new];
    [scoreBL deleteData];
    
    CourseTableBL *courseBL = [CourseTableBL new];
    [courseBL deleteData];
    
    ExamBL *examBL = [ExamBL new];
    [examBL deleteData];
    
    LibraryCurrentBL *libCurBL = [LibraryCurrentBL new];
    [libCurBL deleteData];
    
    LibraryHistoryBL *libHisBL = [LibraryHistoryBL new];
    [libHisBL deleteData];
    
    ManageChannelDAO *manageChannel = [ManageChannelDAO sharedManager];
    [manageChannel removeManangeChannel];
    
    PluginCourseTableDAO *pluginDao = [PluginCourseTableDAO shareManager];
    [pluginDao remove];
    
}

//- (IBAction)click_share:(id)sender {
//
// //   self.shareBGView.hidden = NO;
//
//
//}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowUserInformation *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"];
    switch (indexPath.row) {
        case 0:
            
            userInfoVC.isLeftPush = YES;
           [self presentViewController:userInfoVC animated:YES completion:nil];
          //[self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"] sender:self];
            //[self]
            //[self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"] animated:YES];
            //[self presentedViewController];
            break;
        case 1:
            //校园账户
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ManageAccountVC"] animated:YES completion:nil];
            break;
        case 2:
            //修改密码
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePwdVC"] animated:YES completion:nil];
            break;
        case 3:
            [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            //   [self.navigationController pushViewController:[UMFeedback feedbackViewController] animated:YES];
            break;
        case 4:
            [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"aboutVC"] animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}



#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 54;
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"leftCell";
    
    if (leftBgCell == nil) {
        leftBgCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuTableViewCell" owner:nil options:nil];
    leftBgCell = [nibArr objectAtIndex:0];
    //leftBgCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    leftBgCell.backgroundColor = [UIColor clearColor];
    //leftBgCell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:15];
    leftBgCell.selectedBackgroundView = [[UIView alloc] init];
    
    
    
    
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //        cell.backgroundColor = [UIColor clearColor];
    //        cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:18];
    //        cell.textLabel.textColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:214/255.0 alpha:1.0];
    //        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    //        cell.selectedBackgroundView = [[UIView alloc] init];
    //    }
    
    NSArray *titles = @[@"个人信息", @"校园账户", @"修改密码", @"用户反馈",@"关于我们"];
    //    NSArray *titles = @[@"个人信息", @"校园账户", @"修改密码", @"用户反馈",@"关于我们"];
    //  NSArray *images = @[@"icon_person", @"icon_schoolAccount", @"icon_changePW", @"icon_feedback",@"icon_aboutus", @"IconEmpty"];
    NSArray *images = @[@"group", @"sch", @"pw", @"fb",@"au"];
    leftBgCell.leftTitleLabel.text = titles[indexPath.row];
    leftBgCell.leftTitleLabel.textColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.73];
    leftBgCell.leftTitleLabel.highlightedTextColor = [UIColor lightGrayColor];
    leftBgCell.leftTitleLabel.font = [UIFont fontWithName:@"Heiti TC" size:17];
    leftBgCell.leftImage.image = [UIImage imageNamed:images[indexPath.row]];
    
    return leftBgCell;
}




@end
