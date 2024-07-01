//
//  ModifyPasswordViewController.h
//  i西科
//
//  Created by MAC on 15/3/23.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Tools.h"
#import "ISwustServerInterface.h"
#import "ISwustLoginHttpRequest.h"
@interface ModifyPasswordViewController : UIViewController

- (IBAction)click_modify:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txt_oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_FirstPwd;
@property (weak, nonatomic) IBOutlet UITextField *txt_SecondPwd;
//- (IBAction)hidKeyboard:(id)sender;
//
//- (IBAction)hideKeyboard1:(id)sender;
//- (IBAction)hideKeyboard2:(id)sender;


@end
