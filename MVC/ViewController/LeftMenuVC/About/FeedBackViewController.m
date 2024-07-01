//
//  FeedBackViewController.m
//  i西科
//
//  Created by weixvn_ios on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "FeedBackViewController.h"
#import <MBProgressHUD.h>
#import "Tools.h"

@interface FeedBackViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_FeedBack_Notice" object:nil];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(sentBack)];
    //设置状态不可用
    //self.navigationItem.rightBarButtonItem.enabled=NO;
    
    
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

-(void)selfNotificationDO:(NSNotification *)aNotification{
    if (hud) {
        hud.hidden = YES;
    }
    if ([[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"])
    {
         [Tools ToastNotification:@"感谢你的评价"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    else{
         [Tools ToastNotification:@"评价失败"  andView:self.view andLoading:NO andIsBottom:NO];
    }
}

- (void)sentBack{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
    
    if ([self.textView.text isEqualToString:@""]) {
        if (hud) {
            hud.hidden = YES;
        }
        [Tools ToastNotification:@"请输入你的评价哦"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    else if([Tools spaceString:self.textView.text])
    {
        if (hud) {
            hud.hidden = YES;
        }
        [Tools ToastNotification:@"输入内容不能为空格"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    else
    {
        _iSwustServer = [ISwustServerInterface new];
        //获得时间戳
         NSString *timeStamp;
         timeStamp = [Tools getTimeStamp];
        [_iSwustServer Iswust_FeedBack:self.textView.text feedTime:timeStamp pluginID:@"0"];
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
