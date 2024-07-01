//
//  LibraryLogin.h
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "Tools.h"
#import "Config.h"
#import "AccountNumberInfo.h"
#import "LibraryHttpRequest.h"
@interface LibraryLogin : NSObject
{
    ASIFormDataRequest *_requestForm;
}

-(void)library_login:(AccountNumberInfo *)userinfo authcode:(NSString *)authcode;

@end
