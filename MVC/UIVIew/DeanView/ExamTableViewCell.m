//
//  ExamTableViewCell.m
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ExamTableViewCell.h"

@implementation ExamTableViewCell

- (void)awakeFromNib {
    
    [[self.BGView layer] setBorderColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor]];
    [[self.BGView layer] setBorderWidth:1];
    
    int value = arc4random() % 6;
    switch (value) {
        case 0:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
            break;
        case 1:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:240/255.f green:71/255.f blue:43/255.f alpha:0.9];
            break;
        case 2:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:117/255.f green:203/255.f blue:96/255.f alpha:0.9];
            break;
        case 3:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
            break;
        case 4:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:70/255.f green:112/255.f blue:196/255.f alpha:0.9];
            break;
        case 5:
            self.daysCountView.backgroundColor = [UIColor colorWithRed:229/255.f green:115/255.f blue:104/255.f alpha:0.9];
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

- (void) setCountDown:(NSString *)countDown
{
    int timeleft = [countDown intValue];
    int days = timeleft/(3600*24);
    int hours = timeleft%(3600*24)/3600;
    int minutes = timeleft%(3600*24)%3600/60;
    
 //   _countDown = [countDown copy];
    
    NSMutableAttributedString *attributedTextHolder = nil;
    if (timeleft < 0 ) {
        attributedTextHolder =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"过 "]];
        
    }else if(days > 0){
        attributedTextHolder =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dD",days]];
    }
    else if(hours > 0){
        attributedTextHolder =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dH",hours]];
    }
    else{
        attributedTextHolder =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dM",minutes]];
    }
    
    [attributedTextHolder addAttribute:NSFontAttributeName
                                 value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
                                 range:NSMakeRange(attributedTextHolder.length - 1, 1)];
    

    self.daysCountlabel.attributedText = attributedTextHolder;
}

@end
