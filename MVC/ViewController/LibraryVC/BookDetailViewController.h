//
//  BookDetailViewController.h
//  i西科
//
//  Created by weixvn_android on 15/4/26.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfo.h"
@interface BookDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *bookName;
@property (strong, nonatomic) IBOutlet UITextField *bookWriter;
@property (strong, nonatomic) IBOutlet UITextField *bookIndex;
@property (strong, nonatomic) IBOutlet UITextView *bookMassege;

@property (strong, nonatomic) BookInfo *bookInfo;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;




@end
