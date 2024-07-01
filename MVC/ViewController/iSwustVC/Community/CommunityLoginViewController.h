//
//  CommunityLoginViewController.h
//  i西科
//
//  Created by 张为 on 15/5/13.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMCommunity.h"

@interface CommunityLoginViewController : UIViewController<UMComLoginDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNumber;
@property (weak, nonatomic) IBOutlet UITextField *userNickName;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

- (IBAction)login:(id)sender;
@end
