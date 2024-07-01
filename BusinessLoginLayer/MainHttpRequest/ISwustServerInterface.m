//
//  ISwustServerInterface.m
//  i西科
//
//  Created by MAC on 15/1/22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ISwustServerInterface.h"
#import "AppDelegate.h"
#import "ISwustLoginHttpRequest.h"
@implementation ISwustServerInterface

- (instancetype)init
{
    self = [super init];
    if (self) {
         NSLog(@"123");
        if (_httpRequest == nil) {
            
            NSLog(@"123546");
            _httpRequest = [ISwustServerHttpRequest new];
            if ([[Config Instance]getIsNeedToLoginISwust]) {
                 NSLog(@"123546789");
                if (![[Config Instance]checkHttpCookie:ISwust_Server_cookie_Domain]) {
                     NSLog(@"123546789000000");
                    ISwustLoginHttpRequest *login = [ISwustLoginHttpRequest new];
                    [login justiSwustLoginHttpRequest];
                }
            }
        }
    }
    return self;
}

-(Sign *)handleData:(NSDictionary *)dict{
    Sign *_signItem = [Sign new];

    if ([Tools jsonSerialization:dict] != nil) {
        NSString *jsonstring = [Tools jsonSerialization:dict];
        Encrypt * encrypt = [Encrypt new];
        
        _signItem.Aeskey = [encrypt Random_characters];
        _signItem.params = [encrypt encryptJson:jsonstring Kstring:_signItem.Aeskey];
        _signItem.aes_secret_key = [encrypt encryptAesKey:_signItem.Aeskey];
        //_signItem.signString = [encrypt Sign:_signItem];
    }
    return _signItem;
}

-(void)ISwust_Register:(NSString *)registername{
    DeanPersonalBL *personalBL = [DeanPersonalBL new];
    DeanPersonal *item = [personalBL findPersoanlData];
    
    AccountNumberInfo *userinfo = [[Config Instance]getDeanUser];
    
    if ([item.sex isEqualToString:@"女"]) {
        item.sex = @"0";
    }else{
        item.sex = @"1";
    }
    
    NSString *birthdayString = [NSString stringWithFormat:@"%@ 00:00:00",item.birthday];
    NSDictionary *dict;
    if([[Config Instance]getIsTeacher] == NO){
            dict = [NSDictionary dictionaryWithObjects:@[userinfo.userNumber,@"0",userinfo.userPassword,registername,item.name,item.sex,item.department,item.profession,item.className,birthdayString,item.idCard] forKeys:@[@"user_number",@"user_type",@"user_password",@"nick_name",@"user_name",@"user_sex",@"user_college",@"user_capacity",@"user_education",@"user_birthday",@"user_id_card"]];
    }
    else{
            dict = [NSDictionary dictionaryWithObjects:@[userinfo.userNumber,@"0",userinfo.userPassword,registername,item.name,item.sex,item.department,item.profession,item.className,birthdayString,item.idCard] forKeys:@[@"user_number",@"user_type",@"user_password",@"nick_name",@"user_name",@"user_sex",@"user_college",@"user_professional",@"user_class",@"user_birthday",@"user_id_card"]];
    }
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustRegister];

}


//（本接口移到ISwustLoginHttpRequest.h这个类中了）
//-(void)ISwust_Login:(AccountNumberInfo *)userinfo{
//    
//    UIDevice *device_=[[UIDevice alloc] init];
//    
//    // push_user_id 百度推动的id
//    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//  
//    NSString *push_user_id = delegate.userId;
//    if (push_user_id == nil) {
//        push_user_id = @"";
//    }
//    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[userinfo.userNumber,userinfo.userPassword,@"ios",device_.model,device_.systemName,push_user_id,[Tools checkCurrNetWorkType]]
//                                                     forKeys:@[@"user_number",@"user_password",@"device_type",@"device_model",@"device_system",@"push_user_id",@"device_network"]];
//    
//    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustLogin];
//}


-(void)ISwust_ChangePsd_oldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[oldPsw,newPsw]
                                                     forKeys:@[@"user_password",@"user_new_password"]];
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustChangePassword];
}


-(void)ISwust_FindPsw_userNumber:(NSString *)number userName:(NSString *)name IDCard:(NSString *)IDCardStr birthday:(NSString *)birthStr{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[number,name,IDCardStr,birthStr] forKeys:@[@"user_number",@"user_name",@"user_id_card",@"user_birthday"]];
    
     [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustFindPassword];
}

-(void)ISwust_SyncSystemAccount:(NSArray *)array{

    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"user_system_list"];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustSynchSystemAccount];

}
- (void)ISwust_SynchUserInfo:(ISwustUserInfo *)iswustUserInfo{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[iswustUserInfo.user_signature,iswustUserInfo.nick_name,iswustUserInfo.user_qq,iswustUserInfo.user_email,iswustUserInfo.user_tel,iswustUserInfo.user_bedroom,iswustUserInfo.user_hometown] forKeys:@[@"user_signature",@"nick_name",@"user_qq",@"user_email",@"user_tel",@"user_bedroom",@"user_hometown"]];
    
        
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustSynchUserInfo];
    
}
-(void)ISwust_SynchProxyInfo{
   
    NSDictionary *pdict = [[Config Instance] getIswustProxyInfo];
    NSDictionary *dict;
    
    if (pdict.allKeys.count == 0) {
        NSArray *array = [NSArray array];
        dict = [NSDictionary dictionaryWithObject:array forKey:@"proxy_list"];
    }
    else{
        
        NSDictionary *dict1 = [NSDictionary dictionaryWithObject:[pdict objectForKey:@"proxy_version"] forKey:@"proxy_version"];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[pdict objectForKey:@"proxy_id"] forKey:@"proxy_id"];
        NSArray *arr = [NSArray arrayWithObjects:dict1,dict2, nil];
        
         dict = [NSDictionary dictionaryWithObject:arr forKey:@"proxy_list"];
        
    }
   
   
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustSynchProxy];
}
- (void)Iswust_FeedBack:(NSString *)suggest feedTime:(NSString *)timeStamp pluginID:(NSString *)ID{

    NSLog(@"---------------建议：%@",suggest);
    NSLog(@"---------------时间戳: %@",timeStamp);
    NSLog(@"----------------ID:  %@",ID);
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[suggest,timeStamp,ID] forKeys:@[@"feedback_content",@"feedback_time",@"plugin_id"]];
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustFeedack];
}


-(void)ISwust_UpdatePicture:(NSData *)user_photo file_Size:(NSString *)file_size{
   // NSData *data = [[NSData alloc] initWithBytes:user_photo length:sizeof(user_photo)];
    NSString *str = [user_photo base64EncodedStringWithOptions:0];
    NSLog(@"图片大小\n%@",file_size);
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[str,file_size,@"jpg"] forKeys:@[@"user_photo",@"file_size",@"file_type"]];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustUploadPicture];
}

-(void)ISwust_AddCourse:(NSDictionary *)dict{

    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustAddCourse];

}


-(void)ISwust_uploadCourse:(NSDictionary *)dict{
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustUploadCourse];

}

-(void)ISwust_downloadCourse:(NSDictionary *)dict{
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustDownloadCourse];
    
}

-(void)ISwust_AddScore:(NSDictionary *)dict{
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustAddScore];
}
- (void)Iswust_GetNewsAllChannel:(NSString *)userNumber{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:userNumber forKey:@"user_number"];
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetAllNewsChannel];
}

- (void)Iswust_GetNewsSubChannel:(NSString *)userNumber{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:userNumber forKey:@"user_number"];
    
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetSubNewsChannel];
}

- (void)Iswust_ManagerNewsChannel:(NSString *)channelAction channelID:(int)ID
{
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjects:@[channelAction,[NSNumber numberWithInt:ID]] forKeys:@[@"channel_action",@"channel_id"]];
    
    NSArray *array = [NSArray arrayWithObject:dict1];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"channel_list"];
    
     [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustManagerNewsChannel];
}


- (void)Iswust_GetNewsList:(int)newsNumber channelID:(int)ID userAction:(int)action newsTimeStamp:(NSString *)time{
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:newsNumber],[NSNumber numberWithInt:ID],[NSNumber numberWithInt:action],time] forKeys:@[@"news_number",@"channel_id",@"user_action",@"news_timestamp"]];
     [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetNews];
}

- (void)Iswust_GetNewsDetail_ID:(NSString *)newsID{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",newsID] forKey:@"news_id"];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetNewsDetail];
}

- (void)Iswust_GetUserInfo:(ISwustUserInfo *)iswustUserInfo{
  NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[iswustUserInfo.user_number,iswustUserInfo.user_name,iswustUserInfo.nick_name,iswustUserInfo.user_college,iswustUserInfo.user_professional,iswustUserInfo.user_class,iswustUserInfo.user_sex,@"1"] forKeys:@[@"news_number",@"user_name",@"nick_name",@"user_college",@"user_professional",@"user_class",@"user_sex",@"curr_page"]];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetUserinfo];
}
-(void)Iswust_LoginOut{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *push_user_id = delegate.userId;
    if (push_user_id == nil) {
        push_user_id = @"";
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:push_user_id forKey:@"push_user_id"];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustlogout];
}


-(void)Iswust_GetQuestionnaire
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"is_all"];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustGetQuestionnaire];
}

-(void)Iswust_ChangeQuestionState:(NSString *)id
{
    int idInt = id.intValue;
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:idInt]] forKeys:@[@"survey_id"]];
    [_httpRequest startiSwustServerHttpRequest:[self handleData:dict] ActionURL:ISwustChangeQuestionnaireState];
}

@end
