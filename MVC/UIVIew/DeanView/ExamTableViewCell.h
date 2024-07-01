//
//  ExamTableViewCell.h
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UIView *daysCountView;
@property (weak, nonatomic) IBOutlet UILabel *daysCountlabel;

@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *seatNumber;
@property (weak, nonatomic) IBOutlet UILabel *classroom;
@property (weak, nonatomic) IBOutlet UILabel *dateString;
@property (weak, nonatomic) IBOutlet UILabel *timeString;
@property (weak, nonatomic) IBOutlet UILabel *weekString;

@property (copy, nonatomic) NSString *countDown;

@end
