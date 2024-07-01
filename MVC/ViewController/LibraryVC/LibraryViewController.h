//
//  LibraryViewController.h
//  i西科
//
//  Created by MAC on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *noBorrowPicScrollView;

@property (strong, nonatomic) IBOutlet UIImageView *noBorrowPic;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end
