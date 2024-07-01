//
//  ISwustLoginHttpRequest.m
//  i西科
//
//  Created by MAC on 15/1/21.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ISwustLoginHttpRequest.h"
#import "Encrypt.h"
#import "AppDelegate.h"
#import "IswustUserInfoBL.h"
@implementation ISwustLoginHttpRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
         _array = [NSArray arrayWithObjects:@"SUCCESS",@"FAIL",@"NOT_LOGIN",@"USER_NAME_EXIST",@"USER_PASSWD_WRONG",@"SIGNATURE_WRONG",@"LACK_NECESSARY_PARAMETER",@"ACCESS_DENIED",@"REQUEST_TIMEOUT",@"REQUEST_FREQUENT",@"FILE_SIZE_LIMITED",@"FILE_FORMAT_WRONG",@"ENCODING_WRONG",@"SERVER_UNAVAILABLE",@"PARAMETER_ERROR",@"NULL_COMMENT",@"COURSE_EXITS",@"NULL_USER_PHOTO",@"COURSE_NOT_EXITS",@"USER_NAME_NOT_EXIST",@"NO_DATA_ON_SERVER", nil];
    }
    return self;
}


-(NSString *)errorStatusNotification:(int)status{
    // // 发出请求失败的消息
    switch (status) {
        case 0:
            return @"成功";
            break;
        case 1:
            return @"操作失败，请重试";
            break;
        case 2:
            return @"用户未登录";
            break;
        case 3:
            return @"用户已存在,请登录";
            break;
        case 4:
            return @"用户密码错误";
            break;
        case 5:
            return @"签名认证失败";
            break;
        case 6:
            return @"缺少必选参数";
            break;
        case 7:
            return @"用户无权限访问";
            break;
        case 8:
            return @"请求超时";
            break;
        case 9:
            return @"用户提交过于频繁，请稍后访问";
            break;
        case 10:
            return @"文件大小受限";
            break;
        case 11:
            return @"文件格式不正确";
            break;
        case 12:
            return @"编码错误";
            break;
        case 13:
            return @"服务不可用";
            break;
        case 14:
            return @"参数错误";
            break;
        case 15:
            return @"无评论";
            break;
        case 16:
            return @"课程已存在";
            break;
        case 17:
            return @"头像為空";
            break;
        case 18:
            return @"課程號不存在";
            break;
        case 19:
            return @"用户不存在";
            break;
        case 20:
            return @"服务器无用户数据";
            break;
        default:
            break;
    }
    return nil;
}

-(void)justiSwustLoginHttpRequest{
    Sign *signItem = [self setSignItem];
    Encrypt *encrypt = [[Encrypt alloc] init];
    signItem.url = [NSString stringWithFormat:@"%@%@",URL_ISwust_MainDomain,URL_ISwustLogin];
    signItem.signString = [encrypt Sign:signItem];
    
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_ISwust_MainDomain,URL_ISwustLogin]]];
    [request setTimeOutSeconds:20];//设置超时
    
    [request setPostValue:signItem.timestamp forKey:@"timestamp"];//时间戳
    [request setPostValue:signItem.params forKey:@"params"];//json数据
    [request setPostValue:signItem.expires forKey:@"expires"];//超时时间
    [request setPostValue:signItem.api_version forKey:@"api_version"];//版本号
    [request setPostValue:signItem.aes_secret_key forKey:@"aes_secret_key"];//AES密钥
    [request setPostValue:signItem.signString forKey:@"sign"];
    
    [request setCompletionBlock:^{
        [self firstLoginOperation:[request responseData]];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (error) {
            NSInteger code = [error code];
            if (code == 2) {
                // 请求超时
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"请求超时" forKey:@"Message"]];
            }else{
                //请求错误
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"连接异常，请检查网络" forKey:@"Message"]];
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_Request_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:@"请求异常" forKey:@"Message"]];
        }

        
        NSLog(@"用户登录server--请求错误：%s:error == %@",__FUNCTION__,request.error);
    }];
    [request startSynchronous];
    
}

-(void)firstLoginOperation:(NSData *)jsonData{

    NSLog(@"sdsdsdsdsd");
    Encrypt *dencrypt = [Encrypt new];
    NSData *dencryptedData = [dencrypt decryptJson:jsonData KeyString:[[Config Instance] getInterimAESCipher]];
    
    NSError *error;
    NSDictionary *allInfo = [NSJSONSerialization JSONObjectWithData:dencryptedData options:NSJSONReadingMutableLeaves error:&error];
    NSString *statusKey =  [allInfo objectForKey:@"status"];

    int statusIndex = [_array indexOfObject:statusKey];
    
    if (statusIndex == 0) {
        
        //判断是否为教师账户
        int user_type = [[allInfo objectForKey:@"user_type"] integerValue];
        if(user_type == 1){
            [[Config Instance]saveIsTeacher:YES];
        }
        else{
            [[Config Instance]saveIsTeacher:NO];
        }
        
        
        //if (user_type == 0) {
            if ([[Config Instance]getIswustLoginStatus] == nil || [[[Config Instance]getIswustLoginStatus]isEqualToString:Iswust_logout]) {
                NSLog(@"登录server--成功");
                
                //登录成功，将返回数据插入个人信息数据库
                IswustUserInfoBL *iswustUserInfoBL = [[IswustUserInfoBL alloc] init];
                [iswustUserInfoBL inSertData:allInfo];
                //下载头像
                NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[allInfo objectForKey:@"user_number"]];
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if (![fileManager fileExistsAtPath:fullPath]) {
                    NSString *user_photo_link = [allInfo objectForKey:@"user_photo_link"];
                    if(user_photo_link.length != 0){
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user_photo_link]];
                        [imageData writeToFile:fullPath atomically:NO];
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:[self errorStatusNotification:statusIndex] forKey:@"Message"]];
                
            }else if([[[Config Instance]getIswustLoginStatus]isEqualToString:Iswust_Login]){
                
                NSLog(@"just登录--成功");
            }
       // }else{
            
            ///////添加对教师账户的支持
            
            
            
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:ISwust_USER_Type_Teacher forKey:@"Message"]];
       // }
        
        
        

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_login_Notice" object:nil userInfo:[NSDictionary dictionaryWithObject:[self errorStatusNotification:statusIndex] forKey:@"Message"]];
    }

}

-(Sign *)setSignItem{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *push_user_id = delegate.userId;
    if (push_user_id == nil) {
        push_user_id = @"";
    }

    AccountNumberInfo *userinfo = [[Config Instance]getISwustUser];
   
    UIDevice *device_=[[UIDevice alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[userinfo.userNumber,userinfo.userPassword,@"ios",device_.model,device_.systemName,[Tools checkCurrNetWorkType],push_user_id]
                                                     forKeys:@[@"user_number",@"user_password",@"device_type",@"device_model",@"device_system",@"device_network",@"push_user_id"]];
    
    Sign *_signItem = [Sign new];
    
    if ([Tools jsonSerialization:dict] != nil) {
        NSString *jsonstring = [Tools jsonSerialization:dict];
        
        NSLog(@"%s : -- signItem.params == %@", __FUNCTION__,jsonstring);
        
        Encrypt * encrypt = [Encrypt new];
        
        _signItem.Aeskey = [encrypt Random_characters];
        _signItem.params = [encrypt encryptJson:jsonstring Kstring:_signItem.Aeskey];
        _signItem.aes_secret_key = [encrypt encryptAesKey:_signItem.Aeskey];
        _signItem.signString = [encrypt Sign:_signItem];
    }
    return _signItem;
}

@end
