//
//  ShowUserInformation.h
//  i西科
//
//  Created by weixvn_android on 15/12/10.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowUserInformation : UIViewController



@property (weak, nonatomic) IBOutlet UIImageView *TouXiangPicture;
@property (weak, nonatomic) IBOutlet UILabel *XueYUan;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *Sex;
@property (weak, nonatomic) IBOutlet UILabel *Birthday;

@property (weak, nonatomic) IBOutlet UILabel *Class;
@property (weak, nonatomic) IBOutlet UILabel *QQ;
@property (weak, nonatomic) IBOutlet UILabel *PHone;
@property (weak, nonatomic) IBOutlet UILabel *Email;

@property (weak, nonatomic) IBOutlet UILabel *Sigure;
//- (IBAction)Canel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
//- (IBAction)Sure:(id)sender;
- (IBAction)ChangeInformation:(id)sender;
- (IBAction)Sure:(id)sender;
@property BOOL isLeftPush;


@end
