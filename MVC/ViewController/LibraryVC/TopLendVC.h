//
//  TopLendVC.h
//  i西科
//
//  Created by weixvn_android on 15/4/30.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopLendVC : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *topLendTableView;
@end
