//
//  IswustUserInfoBL.m
//  i西科
//
//  Created by Mac_240 on 15/1/22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "IswustUserInfoBL.h"

@implementation IswustUserInfoBL

- (instancetype)init
{
    self = [super init];
    if (self) {
        dao = [ISwustUserInfoDAO shareManager];
        iswustUserInfo = [ISwustUserInfo new];

    }
    return self;
}
-(ISwustUserInfo *)findData{
    
    iswustUserInfo = [dao findAll];
    return iswustUserInfo;
    
}
-(void)inSertData:(NSDictionary *)dic{
   
    [self removeData];
    //user_name ,user_signature ,nick_name ,user_photo_link ,user_sex ,user_idcard ,user_qq ,user_email,user_tel,user_bedroom,user_hometown,user_college,user_class,user_birthday,user_capacity,user_number,user_education,user_professional
    
    iswustUserInfo.user_name = [dic objectForKey:@"user_name"];
    iswustUserInfo.user_signature = [dic objectForKey:@"user_signature"];
    iswustUserInfo.nick_name = [dic objectForKey:@"nick_name"];
    iswustUserInfo.user_photo_link = [dic objectForKey:@"user_photo_link"];
    iswustUserInfo.user_sex = [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_sex"]];
    iswustUserInfo.user_id_card = [dic objectForKey:@"user_id_card"];
    iswustUserInfo.user_qq = [dic objectForKey:@"user_qq"];
    iswustUserInfo.user_email = [dic objectForKey:@"user_email"];
    iswustUserInfo.user_tel = [dic objectForKey:@"user_tel"];
    iswustUserInfo.user_bedroom = [dic objectForKey:@"user_bedroom"];
     iswustUserInfo.user_hometown = [dic objectForKey:@"user_hometown"];
    iswustUserInfo.user_college = [dic objectForKey:@"user_college"];
    iswustUserInfo.user_class = [dic objectForKey:@"user_class"];
    iswustUserInfo.user_birthday = [dic objectForKey:@"user_birthday"];
    iswustUserInfo.user_capacity = [dic objectForKey:@"user_capacity"];
    iswustUserInfo.user_number = [dic objectForKey:@"user_number"];
    iswustUserInfo.user_education = [dic objectForKey:@"user_education"];
    iswustUserInfo.user_professional = [dic objectForKey:@"user_professional"];
    
    
    
   [dao create:iswustUserInfo];
}
-(void)removeData{
    [dao remove];
}
@end
