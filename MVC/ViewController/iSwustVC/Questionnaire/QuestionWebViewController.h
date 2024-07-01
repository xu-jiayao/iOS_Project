//
//  QuestionWebViewController.h
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISwustLoginHttpRequest.h"
#import "ISwustServerInterface.h"

@interface QuestionWebViewController : UIViewController<UIWebViewDelegate>
{
    ISwustLoginHttpRequest *login;
    ISwustServerInterface *serverInterface;
}

@property(nonatomic,strong) NSDictionary *questionItem;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end
