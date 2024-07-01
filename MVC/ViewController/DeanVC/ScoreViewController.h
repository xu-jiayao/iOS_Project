//
//  ScoreViewController.h
//  i西科
//
//  Created by weixvn_android on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIRefreshControl *refreshControl;
@end
