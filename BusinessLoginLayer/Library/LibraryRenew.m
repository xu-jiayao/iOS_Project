//
//  LibraryRenew.m
//  i西科
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "LibraryRenew.h"
#import "AccountNumberInfo.h"
#import "Config.h"
#define LogInURL @"http://202.115.162.45:8080/reader/redr_verify.php"

@interface LibraryRenew ()
{
    NSArray *userInfoArr;
}
@end

@implementation LibraryRenew

-(void) initWithRENEWURL:(NSString *)barCode barCheck:(NSString *)barCheck
{
    //获取用户名、密码
    AccountNumberInfo *user = [[Config Instance]getLibraryUser];
    
    
    if ([[Config Instance]checkHttpCookie:Library_login_cookie_Domain]) {
        [self startRenew:barCode barCheck:barCheck];
    }else{
        @try {
            
            NSURL *url = [NSURL URLWithString:URL_Library_Login];
            //提交表单
            __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
            [requestForm setPostValue:user.userNumber forKey:@"number"];
            [requestForm setPostValue:user.userPassword forKey:@"passwd"];
            [requestForm setPostValue:@"cert_no" forKey:@"select"];
            [requestForm setPostValue:nil  forKey:@"returnUrl"];
            [requestForm setTimeOutSeconds:20];//设置超时

            [requestForm setCompletionBlock:^{
                NSData *resData=[requestForm responseData];
                NSString *dataString = [[NSString alloc]initWithData:resData encoding:NSUTF8StringEncoding];
                NSString *judgeString = @"提示";
                
                if ([dataString rangeOfString:judgeString].location != NSNotFound) {
                    //后台等图书馆时密码错误
                    
                    //清除本地存储的图书馆账户信息中的密码  下次可通过判断有无图书馆的密码确定 是否成功登录图书馆系统
                    AccountNumberInfo *user = [[Config Instance]getLibraryUser];
                    [[Config Instance]saveLibraryUserNameAndPwd:user.userNumber andPwd:@""];
                    
                    NSLog(@"登录图书馆时密码错误：%s",__FUNCTION__);
                }else{
                    [self startRenew:barCode barCheck:barCheck];
                    NSLog(@"登录图书馆成功：%s",__FUNCTION__);
                }
                
                
            }];
            [requestForm setFailedBlock:^{
                NSError *error = [requestForm error];
                if (error) {
                    NSLog(@"%s:error == %@",__FUNCTION__,error);
                }
            }];
            [requestForm startAsynchronous];
        }
        @catch (NSException *exception) {
            NSLog(@"%s:%@",__FUNCTION__,exception);
            
        }
        @finally {
            
        }
        
        

    }
    
}

-(void)startRenew:(NSString *)barCode barCheck:(NSString *)barCheck{
    NSString * url1 =  @"http://202.115.162.45:8080/reader/ajax_renew.php?bar_code=";//1533893&check=38BC024D&time=
    
    NSString *url2 =[NSString stringWithFormat:@"%@%@%@%@%@%@",url1,barCheck,@"&check=",barCode,@"&time=",[NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970]*1000.0)]];
    
    NSString * renewurl = url2;
    NSURL * url3 = [NSURL URLWithString:renewurl];
    
    //发送请求
    /*******************************post data******************************/
    __weak ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:url3];
    
    [request1 setCompletionBlock:^{
        @try {
            //获取页面信息
            NSData *htmlData = [request1 responseData];
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            
            //解析
            NSArray *elements1  = [xpathParser searchWithXPathQuery:@"//font"];
            TFHppleElement *element0 = [elements1 objectAtIndex:0 ];
            NSString *current = [element0 text];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:current message:nil delegate:self cancelButtonTitle:nil  otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        @catch (NSException *exception) {
            NSLog(@"%s:  %@",__FUNCTION__,[request1 error]);
        }
        @finally {
        }

    }];
    [request1 setFailedBlock:^{
        NSLog(@"%s,图书续借失败",__FUNCTION__);
    }];
    [request1 startAsynchronous];
    
    
}

@end
