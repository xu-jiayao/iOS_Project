//
//  ISwustEditUserInfoViewController.h
//  i西科
//
//  Created by Mac_240 on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISwustEditUserInfoViewController : UITableViewController<UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *user_NikName;
@property (strong, nonatomic) IBOutlet UITextView *user_Signature;

@property (strong, nonatomic) IBOutlet UIImageView *user_Image;
- (IBAction)choseUserImage:(id)sender;

@end
