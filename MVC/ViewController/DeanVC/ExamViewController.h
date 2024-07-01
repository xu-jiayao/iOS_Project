//
//  ExamViewController.h
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "DeanHttpRequestQueue.h"
#import "MBProgressHUD.h"
#import "DeanLogin.h"
@interface ExamViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIRefreshControl *refresh;

@end
