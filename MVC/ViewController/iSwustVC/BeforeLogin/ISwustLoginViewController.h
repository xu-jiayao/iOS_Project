//
//  ISwustLoginViewController.h
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Tools.h"
#import "MBProgressHUD.h"
#import "ISwustServerInterface.h"
@interface ISwustLoginViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
{
    ISwustServerInterface *_iSwustServer;
    
}
- (IBAction)click_Login:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_username;
@property (strong, nonatomic) IBOutlet UITextField *txt_pwd;

@end
