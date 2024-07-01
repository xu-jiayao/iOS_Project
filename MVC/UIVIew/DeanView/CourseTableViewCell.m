//
//  CourseTableViewCell.m
//  i西科
//
//  Created by FK on 14-10-31.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell

- (void)awakeFromNib {
    //添加边框
    CALayer *layer = [self.BGView layer];
    layer.borderColor = [[UIColor clearColor] CGColor];
    layer.borderWidth = 5.0f;
    // self.BGView.layer.cornerRadius = 5.0;
    //添加四个边阴影
    self.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView.layer.shadowOffset = CGSizeMake(0, 0);
    self.BGView.layer.shadowOpacity = 0.1;
    self.BGView.layer.shadowRadius = 10.0;
    //添加两个边阴影
    self.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView.layer.shadowOffset = CGSizeMake(4, 4);
    self.BGView.layer.shadowOpacity = 0.1;
    self.BGView.layer.shadowRadius = 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
