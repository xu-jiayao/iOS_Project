//
//  DeanLogin.m
//  i西科
//
//  Created by MAC on 15/1/9.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "DeanLogin.h"
#import "ScoreParser.h"
#import "Config.h"

@implementation DeanLogin
@synthesize userinfoItem;
@synthesize requestFlag;

-(void)cancelDeanLoginAllRequest{
    [Tools CancelRequest:_request];
    [Tools CancelRequest:_formRequest];
    [Tools CancelRequest:_requestForMianPage];
    [Tools CancelRequest:_requestForTicket];
    
}

-(void)dean_login:(AccountNumberInfo *)userinfo{
    
    //清楚之前登录等cookie
    [[Config Instance] clearHttpCookie:Dean_login_cookie_Domain];

    userinfoItem = userinfo;
    if([[Config Instance]getIsTeacher] == YES){
            _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Teacher_Login]];
    }
    else{
           _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Login]];
    }
 
    // 默认为YES, 你可以设定它为NO来禁用gzip压缩
    [_request setAllowCompressedResponse:YES];
    
    [_request setValidatesSecureCertificate:NO];
    
    [_request setTimeOutSeconds:20];//设置超时

    [_request setCompletionBlock:^{
        [self requestLoginPostData:_request];
    }];
    [_request setFailedBlock:^{
        NSError *error = [_request error];
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"连接错误" forKey:@"Message"]];
            NSLog(@"%s:error == %@",__FUNCTION__,error);
        }
    }];
    [_request startAsynchronous];
    
    NSLog(@"%s",__FUNCTION__);
}


- (void)requestLoginPostData:(ASIHTTPRequest *)request
{
    @try {
        NSLog(@"%s:%@",__FUNCTION__,userinfoItem.userNumber);
        NSData *loginHTMLData = [request responseData];
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:loginHTMLData];
        
        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//@value"];
        TFHppleElement *lt_element = [elements objectAtIndex:0];//获取lt的值
        NSString *keyLT =[lt_element text];
        
        TFHppleElement *service_element = [elements objectAtIndex:3];//获取service的值
        NSString *keyService= [service_element text];

        if([[Config Instance]getIsTeacher] == YES){
            _formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_Dean_Teacher_Login]];
        }
        else{
            _formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_Dean_Login]];
        }
        [_formRequest setUseCookiePersistence:YES];
        [_formRequest setPostValue:keyLT forKey:@"lt"];
        [_formRequest setPostValue:userinfoItem.userNumber forKey:@"username"];
        [_formRequest setPostValue:userinfoItem.userPassword forKey:@"password"];
        [_formRequest setPostValue:keyService forKey:@"service"];
        
        [_formRequest setValidatesSecureCertificate:NO];
        
        [_formRequest setCompletionBlock:^{
            [self requestLoginRedirect:_formRequest];
        }];
        [_formRequest setFailedBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"教务处访问失败" forKey:@"Message"]];
            NSError *error = [_formRequest error];
            if (error) {
                NSLog(@"%s:error == %@-----%@",__FUNCTION__,error,userinfoItem.userPassword);
            }
        }];
        [_formRequest startAsynchronous];

    }
    @catch (NSException *exception) {
       // [NdUncaughtExceptionHandler TakeException:exception];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"登录失败，请重试！" forKey:@"Message"]];
        NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
    }
    @finally {
       ////这里面的代码一定会执行
    }
}

- (void)requestLoginRedirect:(ASIHTTPRequest *)formRequest
{
    //judge logined or not through string
    NSLog(@"%s:=======%@",__FUNCTION__,userinfoItem.userNumber);
    NSString *loginHtmlString = [formRequest responseString];
    
    if ([loginHtmlString rangeOfString:Dean_Login_authentic_error].location == NSNotFound){
        ///
        ///获得含有event=studentPortal:DEFAULT_EVENT&ticket=......的url1，本次获取时地址是https协议的
        ///而此网址不能重定向到用户信息页面 所以需要继续获取可以重定向的用户页面的地址
        ///
     
  
        @try {
  
            NSData *requestFormData = [formRequest responseData];
            
            TFHpple *requestFormDataParser = [[TFHpple alloc] initWithHTMLData:requestFormData];
            NSArray *requestFormDataelements1  = [requestFormDataParser searchWithXPathQuery:@"//a"];
            TFHppleElement *requestFormDataelement1 = [requestFormDataelements1 objectAtIndex:0];
            NSString *URLwithTicket = [requestFormDataelement1 objectForKey:@"href"];
            

            _requestForTicket = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URLwithTicket]];
            [_requestForTicket setAllowCompressedResponse:YES];
            
             [_requestForTicket setValidatesSecureCertificate:NO];
            
            [_requestForTicket setCompletionBlock:^{
                
                NSLog(@"=== responseData === %@",requestFormData);
                
                 [self requestedForMainPage];

            }];
            [_requestForTicket setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"教务处访问失败" forKey:@"Message"]];
                NSError *error = [_requestForTicket error];
                if (error) {
                    NSLog(@"%s:error == %@",__FUNCTION__,error);
                }
            }];
            [_requestForTicket startAsynchronous];
        }
        @catch (NSException *exception) {
            // [NdUncaughtExceptionHandler TakeException:exception];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"登录失败，请重试！" forKey:@"Message"]];
            NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
        }
        @finally {
            ////这里面的代码一定会执行
        }
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"学号或密码错误",requestFlag] forKeys:@[@"Message",@"requestFlag"]]];
    }
    
}

//-(void)reRequested:(ASIHTTPRequest *)request{
//    
//    @try {
//        NSData *jumpData = [request responseData];
//        TFHpple *jumpDataParser = [[TFHpple alloc] initWithHTMLData:jumpData];
//        NSArray *elements1  = [jumpDataParser searchWithXPathQuery:@"//a"];
//        TFHppleElement *element1 = [elements1 objectAtIndex:0];
//        NSString *myDeanURL = [element1 objectForKey:@"href"];
//        
//         NSLog(@"myDeanURL == %@",myDeanURL);
//        
//    //    myDeanURL = [myDeanURL stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"http"];
//        _requestForMianPage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:myDeanURL]];
//        [_requestForMianPage setAllowCompressedResponse:YES];
//        [_requestForMianPage setValidatesSecureCertificate:NO];
//        
//        [_requestForMianPage setCompletionBlock:^{
//            [self requestedForMainPage];
//        }];
//        [_requestForMianPage setFailedBlock:^{
//            NSError *error = [_requestForMianPage error];
//            if (error) {
//                NSLog(@"%s:error == %@",__FUNCTION__,error);
//            }
//        }];
//        [_requestForMianPage startAsynchronous];
//    }
//    @catch (NSException *exception) {
//        // [NdUncaughtExceptionHandler TakeException:exception];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"登录失败，请重试！" forKey:@"Message"]];
//        NSLog(@"%s:exception  =  %@",__FUNCTION__,exception);
//    }
//    @finally {
//        ////这里面的代码一定会执行
//    }
//}

-(void)requestedForMainPage{
    
    NSLog(@"requestFlag === %@",requestFlag);
    
    if ([requestFlag isEqualToString:Update_Score_backGround]) {
        //暂时的
        DeanHttpRequestQueue *httpRequest = [DeanHttpRequestQueue new];
        [httpRequest startDean_ScoreHttpRequest_BG];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Dean_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:requestFlag forKey:@"Message"]];
    }
    
    NSLog(@"%s:教务处登录成功",__FUNCTION__);
}

@end
