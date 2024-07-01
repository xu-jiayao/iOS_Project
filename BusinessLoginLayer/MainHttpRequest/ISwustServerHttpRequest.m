//
//  ISwustServerHttpRequest.m
//  i西科
//
//  Created by MAC on 15/1/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ISwustServerHttpRequest.h"
#import "Encrypt.h"
@implementation ISwustServerHttpRequest
-(void)startiSwustServerHttpRequest:(Sign *)signItem ActionURL:(ISwustServerIndex )actionIndex{
    
    @try {
        
        Encrypt *encrypt = [[Encrypt alloc] init];
        signItem.url = [NSString stringWithFormat:@"%@%@",URL_ISwust_MainDomain,[self findActionURL:actionIndex]];
        signItem.signString = [encrypt Sign:signItem];
        
        __weak ASIFormDataRequest *requestRegister = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_ISwust_MainDomain,[self findActionURL:actionIndex]]]];
        [requestRegister setTimeOutSeconds:20];//设置超时
        
        
        [requestRegister setPostValue:signItem.timestamp forKey:@"timestamp"];//时间戳
        [requestRegister setPostValue:signItem.params forKey:@"params"];//json数据
        [requestRegister setPostValue:signItem.expires forKey:@"expires"];//超时时间
        [requestRegister setPostValue:signItem.api_version forKey:@"api_version"];//版本号
        [requestRegister setPostValue:signItem.aes_secret_key forKey:@"aes_secret_key"];//AES密钥
        [requestRegister setPostValue:signItem.signString forKey:@"sign"];
        
        [requestRegister setCompletionBlock:^{
            NSLog(@"jsonstring----%@",[requestRegister responseString]);
            [self responseServer:[requestRegister responseData] andActionIndex:actionIndex];
            
        }];
        [requestRegister setFailedBlock:^{
            NSError *error = [requestRegister error];
            if (error) {
                NSInteger code = [error code];
                if (code == 2) {
                    // 请求超时
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"请求超时" forKey:@"Message"]];
                }
                //请求错误
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"连接异常，请检查网络" forKey:@"Message"]];
            }
            else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"请求异常" forKey:@"Message"]];
            }
            NSLog(@"用户请求错误：%s:error == %@",__FUNCTION__,requestRegister.error);
        }];
        [requestRegister startAsynchronous];
    }
    @catch (NSException *exception) {
        NSLog(@"%s:%@",__FUNCTION__,exception);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"请求异常" forKey:@"Message"]];
    }
    @finally {
        
    }
    
}

-(void)responseServer:(NSData *)jsonData andActionIndex:(ISwustServerIndex)actionINdex{
    if (parser == nil) {
           parser  = [[ISwustServerParser alloc]init];
    }
    switch (actionINdex) {
        case ISwustRegister:
            [parser iswustRegister:jsonData];
            break;
        case ISwustLogin:
            [parser iswustLogin:jsonData];
            break;
        case ISwustSynchUserInfo:
            [parser iswustSynchUserInfo:jsonData];
            break;
        case ISwustChangePassword:
            [parser iswustChangePassword:jsonData];
            break;
        case ISwustFindPassword:
            [parser iswustFindPassword:jsonData];
            break;
        case ISwustUploadPicture:
            [parser iswustUpdateUserPicture:jsonData];
            break;
        case ISwustFeedack:
            [parser iswustFeedBack:jsonData];
            break;
        case ISwustlogout:
            [parser iswustLoginOut:jsonData];
            break;
        case ISwustGetUserinfo:
            [parser iswustGetUserInfo:jsonData];
            break;
        case ISwustSynchProxy:
            [parser iswustSynchProxyInfo:jsonData];
            break;
        case ISwustSynchSystemAccount:
            [parser iswustSynchSystemAccount:jsonData];
            break;
        case ISwustAddCourse:
            [parser iswustAddCourse:jsonData];
            break;
        case ISwustUploadCourse:
            [parser iswustUploadCourse:jsonData];
            break;
        case ISwustDownloadCourse:
            [parser iswustDownloadCourse:jsonData];
            break;
        case ISwustAddScore:
            [parser IswustAddScore:jsonData];
            break;
        case ISwustGetAllNewsChannel:
            [parser ISwustGetAllNewsChannel:jsonData];
            break;
        case ISwustGetSubNewsChannel:
            [parser ISwustGetSubNewsChannel:jsonData];
            break;
        case ISwustManagerNewsChannel:
            [parser ISwustManagerNewsChannel:jsonData];
            break;
        case ISwustGetNews:
            [parser ISwustGetNews:jsonData];
            break;
        case ISwustGetNewsDetail:
            [parser iswustGetNewsDeatail:jsonData];
            break;
        case ISwustGetQuestionnaire:
            [parser IswustGetQusetionnaireList:jsonData];
            break;
        case ISwustChangeQuestionnaireState:
            [parser IswustChangeQusetionnaireState:jsonData];
            break;
        default:
            break;
    }

}
-(NSString *)findActionURL:(ISwustServerIndex)actionINdex{
    NSString *actionURL;
    
    switch (actionINdex) {
        case ISwustRegister:
            return URL_ISwustRegister;
            break;
        case ISwustLogin:
            return URL_ISwustLogin;
            break;
        case ISwustSynchUserInfo:
            return URL_ISwustSynchUserInfo;
            break;
        case ISwustChangePassword:
            return URL_ISwustChangePassword;
            break;
        case ISwustFindPassword:
            return URL_ISwustFindPassword;
            break;
        case ISwustUploadPicture:
            return URL_ISwustUploadPicture;
            break;
        case ISwustFeedack:
            return URL_ISwustFeedack;
            break;
        case ISwustlogout:
            return URL_ISwustlogout;
            break;
        case ISwustGetUserinfo:
            return URL_ISwustGetUserinfo;
            break;
        case ISwustSynchProxy:
            return URL_ISwustSynchProxy;
            break;
        case ISwustSynchSystemAccount:
            return URL_ISwustSynchSystemAccount;
            break;
        case ISwustAddCourse:
            return URL_ISwustAddCourse;
            break;
        case ISwustUploadCourse:
            return URL_ISwustAddCourse;
            break;
        case ISwustDownloadCourse:
            return URL_ISwustAddCourse;
            break;
        case ISwustAddScore:
            return URL_ISwustAddScore;
            break;
        case ISwustGetAllNewsChannel:
            return URL_ISwustGetNewsChannel;
            break;
        case ISwustGetSubNewsChannel:
            return URL_ISwustGetNewsChannel;
            break;
        case ISwustManagerNewsChannel:
            return URL_ISwustManagerNewsChannel;
            break;
        case ISwustGetNews:
            return URL_ISwustGetNews;
            break;
        case ISwustGetNewsDetail:
            return URL_ISwustGetNewsDetail;
            break;
        case ISwustGetQuestionnaire:
            return URL_ISwustGetQuestionnaire;
            break;
        case ISwustChangeQuestionnaireState:
            return URL_ISwustChangeQuestionnaireState;
            break;
        default:
            break;
    }
    return actionURL;
}


@end
