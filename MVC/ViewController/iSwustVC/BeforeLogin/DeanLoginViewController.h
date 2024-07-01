//
//  DeanLoginViewController.h
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "Config.h"
#import "AccountNumberInfo.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface DeanLoginViewController : UIViewController<UIWebViewDelegate,UITextFieldDelegate>
{
//    ASIHTTPRequest *_request;
//    ASIFormDataRequest *_requestForm;
    Tools *asd;
}




@property (strong, nonatomic) IBOutlet UITextField *txt_Name;
@property (strong, nonatomic) IBOutlet UITextField *txt_Pwd;
//@property (strong, nonatomic) IBOutlet UISwitch *switch_Remember;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UIButton *chooseType;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIView *chooseView1;

- (IBAction)chooseTypeBtn:(id)sender;

- (IBAction)isStudent:(id)sender;
- (IBAction)isTeacher:(id)sender;


- (void)click_Login:(id)sender;


@end
