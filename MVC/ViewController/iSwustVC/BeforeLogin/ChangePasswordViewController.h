//
//  ChangePasswordViewController.h
//  i西科
//
//  Created by weixvn_android on 15/1/21.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Tools.h"
#import "ISwustServerInterface.h"

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>{
     ISwustServerInterface *_iSwustServer;
    
}
@property (weak, nonatomic) IBOutlet UITextField *txt_newpassword;
@property (weak, nonatomic) IBOutlet UITextField *txt_surepassword;

@property(nonatomic,strong)NSString *oldpassword;

- (IBAction)Surechangepassword:(id)sender;



@end
