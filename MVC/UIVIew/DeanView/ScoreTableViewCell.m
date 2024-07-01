//
//  ScoreTableViewCell.m
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (void)awakeFromNib {
    //添加边框
//    CALayer *layer = [self.BGVIew layer];
//    layer.borderColor = [[UIColor clearColor] CGColor];
//    layer.borderWidth = 5.0f;
    //self.BGVIew.layer.cornerRadius = 5.0;
    //添加四个边阴影
//    self.BGVIew.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.BGVIew.layer.shadowOffset = CGSizeMake(0, 0);
//    self.BGVIew.layer.shadowOpacity = 0.1;
//    self.BGVIew.layer.shadowRadius = 10.0;
    
    [[self.BGVIew layer] setBorderColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor]];
    [[self.BGVIew layer] setBorderWidth:1];
    //添加两个边阴影
//    self.BGVIew.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.BGVIew.layer.shadowOffset = CGSizeMake(4, 4);
//    self.BGVIew.layer.shadowOpacity = 0.1;
//    self.BGVIew.layer.shadowRadius = 2.0;

    // Initialization code
}
-(void)setScore:(NSString *)score{
    _score = [score copy];
    
    if (![_score isEqualToString:@"通过"] && _score.length <= 5) {
        if ([_score intValue] < 60) {
            self.scoreString.textColor = [UIColor redColor];
        }
        self.scoreString.text = [NSString stringWithFormat:@"%d",[_score intValue]];
    }else if([_score isEqualToString:@"通过"]){
        self.scoreString.text = _score;
    }else{
        self.scoreString.text = @"评";
    }
    
    if ([_score isEqualToString:@"通过"]) {
        
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
        
    ///    _scoreImg.image = [UIImage imageNamed:@"通过"];
    }
    
    if ([_score intValue] < 60) {
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:240/255.f green:71/255.f blue:43/255.f alpha:0.9];
        //       _scoreImg.image = [UIImage imageNamed:@"60-"];
    }else if ([_score intValue] >= 60 && [_score intValue] < 70){
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:117/255.f green:203/255.f blue:96/255.f alpha:0.9];
        //    _scoreImg.image = [UIImage imageNamed:@"60+"];
    }else if ([_score intValue] >= 70 && [_score intValue] < 80){
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
        //    _scoreImg.image = [UIImage imageNamed:@"70+"];
    }else if ([_score intValue] >= 80 && [_score intValue] < 90){
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:70/255.f green:112/255.f blue:196/255.f alpha:0.9];
        //      _scoreImg.image = [UIImage imageNamed:@"80+"];
    }else if ([_score intValue] >= 90){
        self.scoreBGView.backgroundColor = [UIColor colorWithRed:229/255.f green:115/255.f blue:104/255.f alpha:0.9];
        //   _scoreImg.image = [UIImage imageNamed:@"90+"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
