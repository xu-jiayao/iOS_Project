//
//  SearchBook.h
//  i西科
//
//  Created by weixvn_android on 15/4/25.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
#import "BookInfo.h"
@interface SearchBook : NSObject
//-(void)login;
-(void)Toplend;
-(void)seacrhBy_bookName:(NSString *)Str;
-(void)searchBy_Writer:(NSString *)Str;
-(void)searchPlace:(BookInfo *)bookinfo;
@end
