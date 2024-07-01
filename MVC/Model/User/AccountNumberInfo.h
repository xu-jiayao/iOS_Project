//
//  AccountNumberInfo.h
//  i西科
//
//  Created by MAC on 15/1/9.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户信息 实体类
@interface AccountNumberInfo : NSObject

//用户帐号
@property(nonatomic, strong) NSString *userNumber;
//用户密码
@property(nonatomic, strong) NSString *userPassword;

@end
