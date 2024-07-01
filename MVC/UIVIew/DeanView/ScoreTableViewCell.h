//
//  ScoreTableViewCell.h
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BGVIew;
@property (weak, nonatomic) IBOutlet UILabel *scoreString;

@property (strong, nonatomic) IBOutlet UIView *scoreBGView;
@property (weak, nonatomic) IBOutlet UILabel *detailString;
@property (weak, nonatomic) IBOutlet UILabel *tittleString;
//@property (strong, nonatomic) IBOutlet UIImageView *scoreImg;

@property (copy, nonatomic) NSString *score;

@end
