//
//  DeanTeacherPersonal.h
//  i西科
//
//  Created by WayneLiu on 15/6/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeanTeacherPersonal : NSObject

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *teacherID;

@property(nonatomic,strong) NSString *department;
//职称
@property(nonatomic,strong) NSString *capacity;
//学历
@property(nonatomic,strong) NSString *educationBG;

@property(nonatomic,strong) NSString *sex;

@property(nonatomic,strong) NSString *birthday;

@property(nonatomic,strong) NSString *idCard;

@end
