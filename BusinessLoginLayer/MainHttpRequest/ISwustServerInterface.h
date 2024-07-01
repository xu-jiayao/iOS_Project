//
//  ISwustServerInterface.h
//  i西科
//
//  Created by MAC on 15/1/22.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Encrypt.h"
#import "ISwustServerHttpRequest.h"
#import "Sign.h"
#import "Tools.h"
#import "Config.h"
#import "DeanPersonal.h"
#import "DeanPersonalBL.h"
#import "AccountNumberInfo.h"
#import "ISwustUserInfo.h"
#import "Score.h"


@interface ISwustServerInterface : NSObject
{
    ISwustServerHttpRequest *_httpRequest;
  
}
//注册
-(void)ISwust_Register:(NSString *)registername;

//登录  （本接口移到ISwustLoginHttpRequest.h这个类中了）
//-(void)ISwust_Login:(AccountNumberInfo *)userinfo;

//修改密码
-(void)ISwust_ChangePsd_oldPassword:(NSString *)oldPsw newPassword:(NSString *)newPsw;

//找回密码
-(void)ISwust_FindPsw_userNumber:(NSString *)number userName:(NSString *)name IDCard:(NSString *)IDCardStr birthday:(NSString *)birthStr;

//同步校园云账户
-(void)ISwust_SyncSystemAccount:(NSArray *)array;
//同步个人信息
- (void)ISwust_SynchUserInfo:(ISwustUserInfo *)iswustUserInfo;
//同步代理信息
-(void)ISwust_SynchProxyInfo;
//意见反馈
- (void)Iswust_FeedBack:(NSString *)string feedTime:(NSString *)timeStamp pluginID:(NSString *)ID;
//上传头像
-(void)ISwust_UpdatePicture:(NSData *)user_photo file_Size:(NSString *)file_size;

//添加课程
-(void)ISwust_AddCourse:(NSDictionary *)dict;

///上传/下载课表
-(void)ISwust_uploadCourse:(NSDictionary *)dict;
//下载课表
-(void)ISwust_downloadCourse:(NSDictionary *)dict;


//添加用户成绩
-(void)ISwust_AddScore:(NSDictionary *)dict;


//获取所有频道列表
- (void)Iswust_GetNewsAllChannel:(NSString *)userNumber;

//获取用户订阅频道列表
- (void)Iswust_GetNewsSubChannel:(NSString *)userNumber;

//管理新闻频道
- (void)Iswust_ManagerNewsChannel:(NSString *)channelAction channelID:(int)ID;

//获取新闻列表
//userAction类型为byte，需要更改
- (void)Iswust_GetNewsList:(int)newsNumber channelID:(int)ID userAction:(int)action newsTimeStamp:(NSString *)time;

//获取详细信息
- (void)Iswust_GetNewsDetail_ID:(NSString *)newsID;


//获取用户信息
- (void)Iswust_GetUserInfo:(ISwustUserInfo *)iswustUserInfo;
//注销登录
-(void)Iswust_LoginOut;
//获取调查问卷
-(void)Iswust_GetQuestionnaire;
//更改调查问卷状态
-(void)Iswust_ChangeQuestionState:(NSString *)id;


@end
