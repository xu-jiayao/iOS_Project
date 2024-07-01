//
//  AccountDetailViewController.h
//  i西科
//
//  Created by MAC on 15/3/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountNumberInfo.h"
#import "Config.h"
#import "Tools.h"
@interface AccountDetailViewController : UIViewController


@property (nonatomic,strong) AccountNumberInfo *userinfo;

@property int systemFlag;

@end
