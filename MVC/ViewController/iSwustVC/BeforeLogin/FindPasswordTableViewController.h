//
//  FindPasswordTableViewController.h
//  i西科
//
//  Created by 陈识宇 on 15-1-22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISwustServerInterface.h"
#import "Tools.h"
@interface FindPasswordTableViewController : UITableViewController
{
    ISwustServerInterface *_iSwustServer;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_Number;
@property (strong, nonatomic) IBOutlet UITextField *txt_Name;
@property (strong, nonatomic) IBOutlet UITextField *txt_IDCard;

@end

