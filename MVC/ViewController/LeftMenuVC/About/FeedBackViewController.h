//
//  FeedBackViewController.h
//  i西科
//
//  Created by weixvn_ios on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISwustServerInterface.h"

@interface FeedBackViewController : UIViewController
{
    ISwustServerInterface *_iSwustServer;
}
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
