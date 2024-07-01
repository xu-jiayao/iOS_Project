//
//  CourseTableViewCell.h
//  i西科
//
//  Created by FK on 14-10-31.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *classroom;
@property (weak, nonatomic) IBOutlet UILabel *timeString;
@property (weak, nonatomic) IBOutlet UILabel *teacherString;
@property (weak, nonatomic) IBOutlet UILabel *weekCountString;
@property (weak, nonatomic) IBOutlet UILabel *sectionString;
@property (weak, nonatomic) IBOutlet UIView *sectionBGView;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end
