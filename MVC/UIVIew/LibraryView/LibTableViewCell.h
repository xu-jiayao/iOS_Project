//
//  LibTableViewCell.h
//  i西科
//
//  Created by zw on 14-11-1.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bookName;
@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic) IBOutlet UILabel *bookFirstName;
@property (strong, nonatomic) IBOutlet UIView *bookView;
//@property (strong, nonatomic) IBOutlet UIImageView *bookImg;

@property (weak, nonatomic) IBOutlet UIView *BGview;
@end
