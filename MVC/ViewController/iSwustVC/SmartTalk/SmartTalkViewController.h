//
//  SmartTalkViewController.h
//  i西科
//
//  Created by 张为 on 15/5/9.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartTalkViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *resultArray;

@property (weak, nonatomic) IBOutlet UITextField *myTextView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)sendMessages:(id)sender;
@end
