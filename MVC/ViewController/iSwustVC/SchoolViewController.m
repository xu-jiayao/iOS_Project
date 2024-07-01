//
//  SchoolViewController.m
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "SchoolViewController.h"
#import "NewsBL.h"
#import "MBProgressHUD.h"
#import "Tools.h"
#import "ISwustLoginHttpRequest.h"
#import "ISwustServerInterface.h"
#import "QuestionnaireViewController.h"
#import "KYCuteView.h"
#import "BDNoticeBL.h"
#import "IswustUserInfoBL.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
//#import "UMCommunity.h"
#import "SmartTalkViewController.h"
#import "QuestionnaireBL.h"
#import "ISwustNewsViewController.h"

@interface SchoolViewController ()<UIAlertViewDelegate>

{
    MBProgressHUD *hud;
    ISwustLoginHttpRequest *login;
    QuestionnaireBL *questionBL;
    dispatch_queue_t queue ;
    IswustUserInfoBL *userBL;
    KYCuteView *cuteView;
    ISwustUserInfo *userInfo;
}
@property (weak, nonatomic) IBOutlet UIButton *pushButtonView;


- (IBAction)click_showLeft:(id)sender;

@end

@implementation SchoolViewController



// 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 //   NSLog(@"Scrolling...");
    //  1
    CGFloat height = scrollView.bounds.size.height;
 //   NSLog(@"height...Scrolling...%f",height);
    
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
 //   NSLog(@"contentOffset.y....%f,position...%f",scrollView.contentOffset.y,position);
    // 2
    CGFloat percent = MIN(position / (height - 400 ), 1.0);
  //  NSLog(@"percent...%f",percent);
    // 3
    self.bluredImg.alpha = percent  ;
    self.userView.alpha = 1 - percent;
    
}
-(void)viewWillAppear:(BOOL)animated{
    userBL = [IswustUserInfoBL new];
    userInfo = [userBL findData];
    self.userName.text = userInfo.nick_name;
    if(userInfo.user_signature.length != 0){
        self.userInfo.text = userInfo.user_signature;
    }else{
        self.userInfo.text = @"厚德 博学 笃行 创新";
    }
    // 从沙盒获取图片
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",userInfo.user_number];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:fullPath];
        self.userPhoto.image = [UIImage imageWithData:imageData];
    }else{
        self.userPhoto.image = [UIImage imageNamed:@"i西科"];
    }
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.width/2;
    self.userPhoto.clipsToBounds = YES;
    //为图片添加响应事件
    self.userPhoto.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toEditUserInfo)];
    [self.userPhoto addGestureRecognizer:gesture];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"Icon_tabbar_Finding_Selected"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.selectedItem.selectedImage = img;
    
    //确定scrollView能滚动多大范围
    self.myScrollView.contentSize=CGSizeMake(0,0);
    //在scrollView周边增加滚动区域
    self.myScrollView.contentInset=UIEdgeInsetsMake(0, 0, 180, 0);
    //self.myScrollView.contentInset = CGPointMake(0, 0);
    //设置scrollView里的控件的移动位置
    self.myScrollView.contentOffset=CGPointMake(0, 1);
    self.backImg.image = [UIImage imageNamed:@"schoolViewBG1"];
    
    self.bluredImg.contentMode = UIViewContentModeScaleAspectFill;
    self.bluredImg.alpha = 0;
    [self.bluredImg setImageToBlur:[UIImage imageNamed:@"schoolViewBG1"] blurRadius:kLBBlurredImageDefaultBlurRadius
                   completionBlock:nil];
    
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"发现"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"ISwust_Questionnaire_Notice" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePushbadge:) name:@"ISwust_PushMessage_Notice" object:nil];
    
    if (cuteView == nil) {
        cuteView = [[KYCuteView alloc]initWithPoint:CGPointMake(65, 0) superView:self.pushButtonView];
        cuteView.viscosity  = 20;
        cuteView.bubbleWidth = 25;
        cuteView.bubbleColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
        [cuteView setUp];
        [cuteView addGesture];
        cuteView.alpha = 0;
        
    }

    [self showPushBadge];
}


//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:YES];
//    self.navigationController.navigationBarHidden = YES;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)toEditUserInfo{
    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"] sender:self];
    //[self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"] animated:YES completion:nil];
}
-(void)showPushBadge{
    
    BDNoticeBL *BDnewsbl = [BDNoticeBL new];
    int messageCount = [BDnewsbl findUnreadMessageCount];
    
    
    //注意：设置 'bubbleLabel.text' 一定要放在 '-setUp' 方法之后
    //Tips:When you set the 'bubbleLabel.text',you must set it after '-setUp'
    cuteView.bubbleLabel.text = [NSString stringWithFormat:@"%d",messageCount];
    
    if (messageCount != 0) {
        
        [UIView transitionWithView:cuteView duration:0.3 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            cuteView.alpha = 1.0;
            
        }completion:^(BOOL finished){
        }];
        
        
    }else{
        cuteView.frontView.hidden = YES;
    }
}

-(void)updatePushbadge:(NSNotification *)aNotification{
    
    [self showPushBadge];
    
}

-(void)updateUI:(NSNotification *)aNotification
{
    if (hud) {
        [hud hide:YES];
    }
    
    if ([aNotification.name isEqualToString:@"ISwust_Questionnaire_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        questionBL = [QuestionnaireBL new];
        NSArray *array = [questionBL findData];
       
        if (array.count != 0) {
            
            QuestionnaireViewController *questionnaireVC = [self.storyboard instantiateViewControllerWithIdentifier:@"questionnaireVC"];
            
            
            questionnaireVC.questionList = array;
            [self.navigationController pushViewController:questionnaireVC animated:YES];
        }
        else
        {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您暂时没有可填写的问卷！\n稍后再试试吧！" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            alert.tag = 1;
            [alert show];
        }

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[aNotification.userInfo objectForKey:@"Message"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alert show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        switch (buttonIndex) {
            case 1:
                [self click_Questionnaire:nil];
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)click_Score:(id)sender {
    NSLog(@"%s:点击成绩",__FUNCTION__);
}

- (IBAction)click_Exam:(id)sender {
    NSLog(@"%s:点击考试",__FUNCTION__);
}

- (IBAction)click_Library:(id)sender {
    NSLog(@"%s:点击图书馆",__FUNCTION__);
}

- (IBAction)click_ECard:(id)sender {
    NSLog(@"%s:点击一卡通",__FUNCTION__);
}

- (IBAction)click_Questionnaire:(id)sender {
    NSLog(@"%s:点击问卷调查",__FUNCTION__);
    
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
    //    queue = dispatch_queue_create("com.weixvn.questionGet", NULL);
      //  dispatch_async(queue, ^{
            //            login = [ISwustLoginHttpRequest new];
            //            [login justiSwustLoginHttpRequest];
            ISwustServerInterface *serverInterface = [ISwustServerInterface new];
            [serverInterface Iswust_GetQuestionnaire];
      //  });
    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
    
}

- (IBAction)click_SmartTalk:(id)sender {
    SmartTalkViewController *smartTalkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"smartTalkVC"];
    smartTalkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:smartTalkVC animated:YES];
   
}

- (IBAction)click_News:(id)sender {
    
//    UIViewController *communityViewController = [UMCommunity getFeedsViewController];
//    communityViewController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:communityViewController animated:YES];
    
    ISwustNewsViewController *newsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"newsVC"];
//    smartTalkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}




- (IBAction)click_showLeft:(id)sender {
    [self.sideMenuViewController presentLeftViewController];
}
@end
