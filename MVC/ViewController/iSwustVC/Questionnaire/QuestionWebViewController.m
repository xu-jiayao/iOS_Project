//
//  QuestionWebViewController.m
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "QuestionWebViewController.h"
#import "MBProgressHUD.h"
#import "Tools.h"

@interface QuestionWebViewController ()
{
    MBProgressHUD *hud;

}
@end

@implementation QuestionWebViewController
@synthesize myWebView;
@synthesize questionItem;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[questionItem objectForKey:@"survey_url"]]]];
    myWebView.hidden = YES;
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSString *currentURL = [myWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"1--%@",currentURL);
    if ([currentURL isEqualToString:@"http://survey4iswust.duapp.com/"]) {
//            login = [ISwustLoginHttpRequest new];
//            [login justiSwustLoginHttpRequest];
            serverInterface = [ISwustServerInterface new];
            [serverInterface Iswust_ChangeQuestionState:[questionItem objectForKey:@"survey_id"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成问卷～" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Tools showHUD:@"正在加载问卷..." andView:self.view andHUD:hud];
    

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (hud) {
        [hud hide:YES];
    }
    myWebView.hidden = NO;
    NSString *currentURL = [myWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"2--%@",currentURL);
    if ([currentURL isEqualToString:@"http://survey4iswust.duapp.com/"]) {

        serverInterface = [ISwustServerInterface new];
        [serverInterface Iswust_ChangeQuestionState:[questionItem objectForKey:@"survey_id"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已完成问卷～" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载错误！稍后再试试吧～" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    NSString *currentURL = [myWebView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    if ([currentURL isEqualToString:@"http://survey4iswust.duapp.com/"]) {
//        login = [ISwustLoginHttpRequest new];
//        [login justiSwustLoginHttpRequest];
        serverInterface = [ISwustServerInterface new];
        [serverInterface Iswust_ChangeQuestionState:[questionItem objectForKey:@"survey_id"]];
    }
    NSLog(@"did--%@",currentURL);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
