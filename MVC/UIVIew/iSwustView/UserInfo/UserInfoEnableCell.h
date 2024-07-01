//
//  UserInfoEnableCell.h
//  i西科
//
//  Created by MAC on 15/4/3.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoEnableCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *keyText;
@property (weak, nonatomic) IBOutlet UITextField *valueTF;
@property BOOL contentChanged;
@property BOOL formIllegal;


@end
