//
//  QuestionnaireTableViewCell.m
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "QuestionnaireTableViewCell.h"

@implementation QuestionnaireTableViewCell

- (void)awakeFromNib {
    [[self.BGView layer] setBorderColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor]];
    [[self.BGView layer] setBorderWidth:1];
    
 //   self.preView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
    
}

- (void) setSurvey_status:(NSString *)survey_status{
    _survey_status = [survey_status copy];
    int judge = survey_status.intValue;
    
    if ( judge == 2) {
        self.picView.hidden = YES;
        self.completeLabel.hidden = NO;
    }else{
        self.picView.hidden = NO;
        self.completeLabel.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
