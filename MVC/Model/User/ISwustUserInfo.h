//
//  ISwustUserInfo.h
//  i西科
//
//  Created by Mac_240 on 15/1/21.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ISwustUserInfo : NSObject

@property(nonatomic,strong) NSString *user_name;
@property(nonatomic,strong) NSString *user_signature;//个性签名
@property(nonatomic,strong) NSString *nick_name;
@property(nonatomic,strong) NSString *user_photo_link;
@property(nonatomic,strong) NSString *user_sex;
@property(nonatomic,strong) NSString *user_id_card;//身份证号
@property(nonatomic,strong) NSString *user_qq;
@property(nonatomic,strong) NSString *user_email;
@property(nonatomic,strong) NSString *user_tel;
@property(nonatomic,strong) NSString *user_bedroom;
@property(nonatomic,strong) NSString *user_hometown;
@property(nonatomic,strong) NSString *user_college;
@property(nonatomic,strong) NSString *user_class;
@property(nonatomic,strong) NSString *user_birthday;

@property(nonatomic,strong) NSString *user_capacity;//职称
@property(nonatomic,strong) NSString *user_number;
@property(nonatomic,strong) NSString *user_education;
@property(nonatomic,strong) NSString *user_professional;//专业

@end
