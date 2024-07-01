//
//  SchoolViewController.h
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SchoolViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *bluredImg;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

- (IBAction)click_Score:(id)sender;
- (IBAction)click_Exam:(id)sender;
- (IBAction)click_Library:(id)sender;
- (IBAction)click_ECard:(id)sender;
- (IBAction)click_Questionnaire:(id)sender;
- (IBAction)click_SmartTalk:(id)sender;

- (IBAction)click_News:(id)sender;



@end
