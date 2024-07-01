//
//  DeanLogin.h
//  i西科
//
//  Created by MAC on 15/1/9.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "TFHpple.h"
#import "Config.h"
#import "Tools.h"
#import "AccountNumberInfo.h"
#import "DeanHttpRequestQueue.h"

@interface DeanLogin : NSObject
{
    //当前为ARC模式，   __weak防止在异步请求时block 的 retain cycle
   __weak ASIHTTPRequest *_request;
   __weak ASIFormDataRequest *_formRequest;
   __weak ASIHTTPRequest *_requestForTicket;
   __weak ASIHTTPRequest *_requestForMianPage;
}

-(void)dean_login:(AccountNumberInfo *)userinfo;

-(void)cancelDeanLoginAllRequest;
@property (strong, nonatomic)NSString *requestFlag;
@property (strong, nonatomic)AccountNumberInfo *userinfoItem;

@end
