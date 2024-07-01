//
//  IswustUserInfoBL.h
//  i西科
//
//  Created by Mac_240 on 15/1/22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISwustUserInfoDAO.h"
#import "ISwustUserInfo.h"
@interface IswustUserInfoBL : NSObject
{
    ISwustUserInfoDAO *dao;
    ISwustUserInfo *iswustUserInfo;
}
-(ISwustUserInfo *)findData;
-(void)inSertData:(NSDictionary *)dic;
-(void)removeData;
@end
