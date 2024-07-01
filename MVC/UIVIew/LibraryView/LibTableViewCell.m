//
//  LibTableViewCell.m
//  i西科
//
//  Created by zw on 14-11-1.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "LibTableViewCell.h"

@implementation LibTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    //添加边框
//    CALayer *layer = [self.BGview layer];
//    layer.borderColor = [[UIColor clearColor] CGColor];
//    layer.borderWidth = 5.0f;
//    //self.BGVIew.layer.cornerRadius = 5.0;
//    //添加四个边阴影
//    self.BGview.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.BGview.layer.shadowOffset = CGSizeMake(0, 0);
//    self.BGview.layer.shadowOpacity = 0.1;
//    self.BGview.layer.shadowRadius = 10.0;
//    //添加两个边阴影
//    self.BGview.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.BGview.layer.shadowOffset = CGSizeMake(4, 4);
//    self.BGview.layer.shadowOpacity = 0.1;
//    self.BGview.layer.shadowRadius = 2.0;

    
    [[self.BGview layer] setBorderColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]CGColor]];
    [[self.BGview layer] setBorderWidth:1];
    
    int value = arc4random() % 6;
    switch (value) {
        case 0:
            self.bookView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
        //    _bookImg.image = [UIImage imageNamed:@"90+"];   //cell的背景图
            break;
        case 1:
            self.bookView.backgroundColor = [UIColor colorWithRed:240/255.f green:71/255.f blue:43/255.f alpha:0.9];
         //   _bookImg.image = [UIImage imageNamed:@"60-"];   //cell的背景图
            break;
        case 2:
            self.bookView.backgroundColor = [UIColor colorWithRed:117/255.f green:203/255.f blue:96/255.f alpha:0.9];
         //   _bookImg.image = [UIImage imageNamed:@"60+"];   //cell的背景图
            break;
        case 3:
            self.bookView.backgroundColor = [UIColor colorWithRed:64/255.f green:188/255.f blue:188/255.f alpha:0.9];
         //   _bookImg.image = [UIImage imageNamed:@"70+"];   //cell的背景图
            break;
        case 4:
             self.bookView.backgroundColor = [UIColor colorWithRed:70/255.f green:112/255.f blue:196/255.f alpha:0.9];
         //   _bookImg.image = [UIImage imageNamed:@"80+"];   //cell的背景图
            break;
        case 5:
            self.bookView.backgroundColor = [UIColor colorWithRed:229/255.f green:115/255.f blue:104/255.f alpha:0.9];
         //   _bookImg.image = [UIImage imageNamed:@"90+"];   //cell的背景图
            break;
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
