//
//  QuestionnaireTableViewCell.h
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UIView *preView;

@property (weak, nonatomic) IBOutlet UILabel *startTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@property (copy, nonatomic) NSString *survey_status;
@end
