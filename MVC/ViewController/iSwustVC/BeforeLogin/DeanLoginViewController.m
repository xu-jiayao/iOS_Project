//
//  DeanLoginViewController.m
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "DeanLoginViewController.h"
#import "DeanHttpRequestQueue.h"
#import "DeanLogin.h"

@interface DeanLoginViewController ()
{
    MBProgressHUD *hud;
    
}
@property (weak, nonatomic) IBOutlet UIView *txt_FiledBGV;


@end

@implementation DeanLoginViewController
@synthesize webView;
@synthesize txt_Name;
@synthesize txt_Pwd;

//@synthesize switch_Remember;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBarHidden = NO;
    self.chooseView.hidden = YES;
    self.chooseView1.hidden = YES;
    [[Config Instance]saveIsTeacher:NO];
    
    //清除之前登录等cookie
    [[Config Instance] clearHttpCookie:Dean_login_cookie_Domain];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Dean_login_Notice" object:nil];
    
    UIBarButtonItem *btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(click_Login:)];
    self.navigationItem.rightBarButtonItem = btnLogin;
    
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelOperation)];

    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"用户验证"];
    
    self.txt_FiledBGV.layer.cornerRadius = 8.0;
    
    [webView.layer setCornerRadius:8.0];
    [webView setClipsToBounds:YES];
    [[webView layer] setBorderColor:[[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3]CGColor]];
    [[webView layer] setBorderWidth:2.75];
    
    webView.scrollView.bounces = NO;
//    webBGV.layer.cornerRadius = 8.0;

    [self.txt_Pwd setDelegate:self];
    [self.txt_Name setDelegate:self];
    [self.webView setDelegate:self];
    
    self.txt_Name.keyboardType = UIKeyboardTypeNumberPad;
    
//    //决定是否显示用户名以及密码
//    AccountNumberInfo *userinfo = [[Config Instance]getDeanUser];
//    if (userinfo.userNumber && ![userinfo.userNumber isEqualToString:@""]) {
//        self.txt_Name.text = userinfo.userNumber;
//    }
//    if (userinfo.userPassword && ![userinfo.userPassword isEqualToString:@""]) {
//        self.txt_Pwd.text = userinfo.userPassword;
//    }
    

    
    NSString *html = @"<body style='background-color:#dcdcdc'>  您的初始密码为身份证后7位去掉最后一位。<p />  若验证异常,您可以点击 <a href='https://ids-swust.fayea.com/cas/login?service=https%3A%2F%2Fmatrix.dean.swust.edu.cn%2FacadmicManager%2Findex.cfm%3Fevent%3DstudentPortal%3ADEFAULT_EVENT'>这里</a> 查看教务管理系统。</body>";
    [self.webView loadHTMLString:html baseURL:nil];
    self.webView.hidden = NO;
    
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
//    
//    [Tools CancelRequest:_request];
//    [Tools CancelRequest:_requestForm];
   
}

-(void)selfNotificationDO:(NSNotification *)aNotification
{
//    //处理notification
//    [Tools ToastNotification:[aNotification objectForKey:@"Message"] andView:self.view andLoading:NO andIsBottom:NO];
    if (hud) {
        [hud hide:YES];
    }
    
    if ([aNotification.name isEqualToString:@"Dean_login_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:Dean_Identify]){
      
        [Tools ToastNotification:@"验证成功" andView:self.view andLoading:NO andIsBottom:NO];
        
        //存入i西科登录信息 默认为教务处学号密码
        [[Config Instance]saveIswustUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
        
        //存入用户教务处登录信息
        [[Config Instance] saveDeanUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
        //存入用户实验课登录信息
        [[Config Instance] saveLabUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Name.text];
        //存入用户图书馆登录信息
        [[Config Instance]saveLibraryUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Name.text];
        //存入用户一卡通登录信息
        [[Config Instance]saveECardUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
        
        
        DeanHttpRequestQueue *deanHttp = [DeanHttpRequestQueue new];
        [deanHttp startDean_PersonalHttpRequest];
        
        
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"] animated:YES];
        
    }else{
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"] andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}

-(void)cancelOperation{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)chooseTypeBtn:(id)sender {
    if(self.chooseView1.hidden){
        self.chooseView1.hidden = NO;
        self.chooseView.hidden = NO;
    }
    else{
        self.chooseView1.hidden = YES;
        self.chooseView.hidden = YES;
    }

}

- (IBAction)isStudent:(id)sender {
    self.chooseType.titleLabel.text = @"我是学生";
    [[Config Instance]saveIsTeacher:NO];
    self.chooseView.hidden = YES;
    self.chooseView1.hidden = YES;
}

- (IBAction)isTeacher:(id)sender {
    self.chooseType.titleLabel.text = @"我是老师";
    [[Config Instance]saveIsTeacher:YES];
    self.chooseView.hidden = YES;
    self.chooseView1.hidden = YES;
}
/**
 *  @author FK
 *
 *  点击登录教务处
 *
 *
 */
-(void)click_Login:(id)sender{
    if ([Tools NetWorkIsOK]) {
        [Tools showHUD:@"验证中..." andView:self.view andHUD:hud];
        
        AccountNumberInfo *userinfo = [AccountNumberInfo new];
        userinfo.userNumber = self.txt_Name.text;
        userinfo.userPassword = self.txt_Pwd.text;
        
        DeanLogin *deanLogin = [DeanLogin new];
        deanLogin.requestFlag = Dean_Identify;
        [deanLogin dean_login:userinfo];
        

    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
    
//    
//    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Login]];
//    // 默认为YES, 你可以设定它为NO来禁用gzip压缩
//    [_request setAllowCompressedResponse:YES];
//    [_request setDelegate:self];
//    [_request setDidFailSelector:@selector(requestFailed:)];
//    [_request setDidFinishSelector:@selector(requestLoginPostData:)];
//    [_request startAsynchronous];
}

//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    if (_requestForm.hud) {
//        [_requestForm.hud hide:YES];
//    }
//    NSError *error = [request error];
//    if (error) {
//        NSLog(@"%s:error == %@",__FUNCTION__,error);
//        [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"连接错误" forKey:@"Message"]];
//    }
//    
//}
//
//- (void)requestLoginPostData:(ASIFormDataRequest *)request
//{
//    @try {
//        NSLog(@"%s:%@",__FUNCTION__,self.txt_Name.text);
//      
//        NSData *loginHTMLData = [request responseData];
//        
//        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:loginHTMLData];
//        
//        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//@value"];
//        TFHppleElement *lt_element = [elements objectAtIndex:0];//获取lt的值
//        NSString *keyLT =[lt_element text];
//        
//        TFHppleElement *service_element = [elements objectAtIndex:3];//获取service的值
//        NSString *keyService= [service_element text];
//        
//        NSLog(@"lt:%@----service:%@",keyLT,keyService);
//        NSLog(@"%@---%@",self.txt_Name.text,self.txt_Pwd.text);
//        _requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_Dean_Login]];
//        [_requestForm setUseCookiePersistence:YES];
//        [_requestForm setPostValue:keyLT forKey:@"lt"];
//        [_requestForm setPostValue:self.txt_Name.text forKey:@"username"];
//        [_requestForm setPostValue:self.txt_Pwd.text forKey:@"password"];
//        [_requestForm setPostValue:keyService forKey:@"service"];
//        
//        [_requestForm setDelegate:self];
//        [_requestForm setDidFailSelector:@selector(requestFailed:)];
//        [_requestForm setDidFinishSelector:@selector(requestLoginRedirect:)];
//        [_requestForm startAsynchronous];
//        
//        _requestForm.hud = [[MBProgressHUD alloc] initWithView:self.view];
//        [Tools showHUD:@"验证中..." andView:self.view andHUD:_requestForm.hud];
//        
//        
//    }
//    @catch (NSException *exception) {
//        // [NdUncaughtExceptionHandler TakeException:exception];
//        [self requestFailed:nil];
//        [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"登录异常，请检查教务系统可访问性" forKey:@"Message"]];
//        NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
//    }
//    @finally {
//        ////这里面的代码一定会执行
//    }
//}
//
//- (void)requestLoginRedirect:(ASIFormDataRequest *)request
//{
//    //judge logined or not through string
//    NSString *loginHtmlString = [request responseString];
//    
//    if ([loginHtmlString rangeOfString:Dean_Login_authentic_error].location == NSNotFound){
//        ///教务处登录成功后转到用户信息页面分为了2步:
//        ///setp1:获得含有event=studentPortal:DEFAULT_EVENT&ticket=......的url1，本次获取时地址是http协议的
//        ///而此网址不能重定向到用户信息页面 所以需要继续获取可以重定向的用户页面的地址
//        ///
//        ///setp2:根据setp1获得url1再次获取含有event=studentPortal:DEFAULT_EVENT&ticket=.....的url2，本次获取的地址是https协议的
//        ///此网址即可重定向到用户页面
//        ///
//        ///
//        
//        @try {
//            ///setp1
//            NSData *requestFormData = [request responseData];
//            TFHpple *requestFormDataParser = [[TFHpple alloc] initWithHTMLData:requestFormData];
//            NSArray *requestFormDataelements1  = [requestFormDataParser searchWithXPathQuery:@"//a"];
//            TFHppleElement *requestFormDataelement1 = [requestFormDataelements1 objectAtIndex:0];
//            NSString *URLwithTicket = [requestFormDataelement1 objectForKey:@"href"];
//            
//            ///setp2
//            _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URLwithTicket]];
//            [_request setAllowCompressedResponse:YES];
//            [_request setDelegate:self];
//            [_request setDidFailSelector:@selector(requestFailed:)];
//            [_request setDidFinishSelector:@selector(reRequested:)];
//            [_request startAsynchronous];
//        }
//        @catch (NSException *exception) {
//            // [NdUncaughtExceptionHandler TakeException:exception];
//            [self requestFailed:request];
//            [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"登录异常，请检查教务系统可访问性" forKey:@"Message"]];
//            NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
//        }
//        @finally {
//            ////这里面的代码一定会执行
//        }
//    }
//    else{
//        [self requestFailed:nil];
//        [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"学号或密码错误" forKey:@"Message"]];
//    }
//    
//}
//
//-(void)reRequested:(ASIHTTPRequest *)request{
//    
//    @try {
//        NSData *jumpData = [request responseData];
//        
//        TFHpple *jumpDataParser = [[TFHpple alloc] initWithHTMLData:jumpData];
//        NSArray *elements1  = [jumpDataParser searchWithXPathQuery:@"//a"];
//        TFHppleElement *element1 = [elements1 objectAtIndex:0];
//        NSString *myDeanURL = [element1 objectForKey:@"href"];
//        myDeanURL = [myDeanURL stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"http"];
//        
//        
//        _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:myDeanURL]];
//        [_request setAllowCompressedResponse:YES];
//        [_request setDelegate:self];
//        [_request setDidFailSelector:@selector(requestFailed:)];
//        [_request setDidFinishSelector:@selector(requestedForMainPage:)];
//        [_request startAsynchronous];
//    }
//    @catch (NSException *exception) {
//        // [NdUncaughtExceptionHandler TakeException:exception];
//        [self requestFailed:nil];
//        [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"登录异常，请检查教务系统可访问性" forKey:@"Message"]];
//        NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
//    }
//    @finally {
//        ////这里面的代码一定会执行
//    }
//}
//
///**
// *  @author FK
// *
// *  重定向到用户信息页面 此时才登陆成功 可以进行下一步解析
// *
// */
//-(void)requestedForMainPage:(ASIHTTPRequest *)request{
//
//    [self requestFailed:nil];
//    [self selfNotificationDO:[NSDictionary dictionaryWithObject:@"验证成功" forKey:@"Message"]];
//    
//    //存入i西科登录信息 默认为教务处学号密码
//    [[Config Instance]saveIswustUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
//    
//    //存入用户教务处登录信息
//    [[Config Instance] saveDeanUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
//    //存入用户实验课登录信息
//    [[Config Instance] saveLabUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Name.text];
//    //存入用户图书馆登录信息
//    [[Config Instance]saveLibraryUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Name.text];
//    //存入用户一卡通登录信息
//    [[Config Instance]saveECardUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
//    
//    
//    DeanHttpRequestQueue *deanHttp = [DeanHttpRequestQueue new];
//    [deanHttp startDean_PersonalHttpRequest];
//    
//    
//    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"] animated:YES];
//    
//    NSLog(@"%s:教务处登录成功",__FUNCTION__);
//}


//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_Name resignFirstResponder];
    [self.txt_Pwd resignFirstResponder];
    
    self.chooseView.hidden = YES;
    self.chooseView1.hidden = YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txt_Name resignFirstResponder];
    [self.txt_Pwd resignFirstResponder];
    self.chooseView.hidden = YES;
    self.chooseView1.hidden = YES;
    return YES;
}

#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s",__FUNCTION__);
    [[UIApplication sharedApplication] openURL:request.URL];
    if ([request.URL.absoluteString isEqualToString:@"about:blank"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
