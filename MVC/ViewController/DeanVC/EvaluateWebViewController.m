//
//  EvaluateWebViewController.m
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//
#import "EvaluateWebViewController.h"
#import "ASIHTTPRequest.h"
#define preURL @"https://matrix.dean.swust.edu.cn/acadmicManager/"

#define searchStartString @"<!-- pageMain-->"
#define searchEndString @"<!-- /pageMain-->"
@interface EvaluateWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *evaluateWebView;

@end

@implementation EvaluateWebViewController
@synthesize indexURL;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *evalluateURL = [NSString stringWithFormat:@"%@%@",preURL,indexURL];
    
    NSURL *URL = [NSURL URLWithString:evalluateURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setDelegate:self];
    [request setValidatesSecureCertificate:NO];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    
    [request startAsynchronous];
    

}

-(void)requestFinished:(ASIHTTPRequest *)request{
    // NSData *htmlData = [request responseData];
    NSString *dataString = [request responseString];
    
    NSString* htmlHeader=@"<html><head><meta charset='utf-8'><title>互联课堂 - 教学质量评价</title><link rel='shortcut icon' href=\"/acadmicRes/assets/favicon.ico\" /><link href=\"/acadmicRes/assets/css/system.css\" rel='stylesheet' type='text/css' /><script language='javascript' type='text/javascript' src=\"/acadmicRes/assets/script/jquery-1.7.2.min.js\"></script><script language='javascript' type='text/javascript' src=\"/acadmicRes/assets/widget/validator/jquery.formlet.js\"></script><script language='javascript' type='text/javascript' src=\"/acadmicRes/assets/widget/blockUI/jquery.blockUI.min.js\"></script><script language='javascript' type='text/javascript'></script><script language='javascript' type='text/javascript' src=\"/acadmicRes/assets/widget/timer/jquery.timers.js\"></script></head><body>";
    
    NSString* htmlBody=[self filterHTML:dataString];
    
    NSString* htmlFooter=@"</body></html>";
    
    NSString* strHtml=[[NSString alloc] initWithFormat:@"%@%@%@",htmlHeader,htmlBody,htmlFooter];
    
    [self.evaluateWebView loadHTMLString:strHtml baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",preURL,indexURL]]];
    
    //[self.evaluateWebView
    
    //    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('span')[2].style.webkitTextSizeAdjust= = '%f%%'",24.8];
    //    [self.evaluateWebView stringByEvaluatingJavaScriptFromString:str1];
}


-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"%s:__%@",__FUNCTION__,[request error]);

}
-(NSString *)filterHTML:(NSString *)html
{
    NSInteger Start = [html rangeOfString:searchStartString].location;
    NSInteger end = [html rangeOfString:searchEndString].location + searchEndString.length ;
    
    NSString *pageMain = [html substringWithRange:NSMakeRange(Start, end-Start)];
    
    // NSLog(@"pageMian == %@",pageMain);
    
    return pageMain;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    self.hidesBottomBarWhenPushed = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    self.hidesBottomBarWhenPushed = NO;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
