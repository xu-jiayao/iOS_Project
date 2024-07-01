//
//  EvalauteTableViewController.h
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EvaluateOnlineBL.h"
#import "EvaluateOnline.h"
#import "ScoreTableViewCell.h"
#import "EvaluateWebViewController.h"

@interface EvalauteTableViewController : UITableViewController
{
    EvaluateOnlineBL *evaluateBL;
}

@property (nonatomic,strong)NSArray *evaluateArray;

@end
