//
//  LibraryLogin.m
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "LibraryLogin.h"

@implementation LibraryLogin

-(void)library_login:(AccountNumberInfo *)userinfo authcode:(NSString *)authcode{
    @try {
        NSURL *url = [NSURL URLWithString:URL_Library_Login];
        //提交表单
        __weak ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:url];
        [requestForm setPostValue:authcode forKey:@"captcha"];
        [requestForm setPostValue:userinfo.userNumber forKey:@"number"];
        [requestForm setPostValue:userinfo.userPassword forKey:@"passwd"];
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
                [[Config Instance]saveLibraryUserNameAndPwd:userinfo.userNumber andPwd:@""];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_Update_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"密码错误" forKey:@"Message"]];
              
                NSLog(@"登录图书馆时密码错误：%s",__FUNCTION__);
            }else{
                LibraryHttpRequest *libraryRequest =[LibraryHttpRequest new];
                [libraryRequest startHttpRequest];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_Update_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:SUCCESS forKey:@"Message"]];
                
                NSLog(@"登录图书馆成功：%s",__FUNCTION__);
            }

            
        }];
        [requestForm setFailedBlock:^{
            NSError *error = [requestForm error];
            if (error) {
                //清除本地存储的图书馆账户信息中的密码  下次可通过判断有无图书馆的密码确定 是否成功登录图书馆系统
                AccountNumberInfo *user = [[Config Instance]getLibraryUser];
                [[Config Instance]saveLibraryUserNameAndPwd:user.userNumber andPwd:@""];
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

@end
