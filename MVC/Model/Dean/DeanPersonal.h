//
//  DeanPersonal.h
//  i西科
//
//  Created by Fox on 14-9-28.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeanPersonal : NSObject
//STUDENTID TEXT,NAME TXET,SEX TEXT,DEPARTMENT TEXT,PROFESSION TEXT,CLASSNAME TEXT,BIRTHDAY TEXT,IDCARD TEXT
@property(nonatomic,strong) NSString *name;
///如果是教师,则代表工号
@property(nonatomic,strong) NSString *studentID;
///学院
@property(nonatomic,strong) NSString *department;
///如果是教师,则代表职称
@property(nonatomic,strong) NSString *profession;
///如果是教师,则代表学历
@property(nonatomic,strong) NSString *className;

@property(nonatomic,strong) NSString *sex;

@property(nonatomic,strong) NSString *birthday;
///身份证号
@property(nonatomic,strong) NSString *idCard;

@end
