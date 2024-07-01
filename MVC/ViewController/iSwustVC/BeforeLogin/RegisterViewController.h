//
//  RegisterViewController.h
//  i西科
//
//  Created by weixvn_android on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Tools.h"
#import "ISwustServerInterface.h"

@interface RegisterViewController : UIViewController
{
  ISwustServerInterface *_iSwustServer;
}
- (IBAction)finshEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *registername;
- (IBAction)RegisterBT:(id)sender;

@end
