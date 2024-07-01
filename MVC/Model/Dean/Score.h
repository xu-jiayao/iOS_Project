//
//  Score.h
//  i西科
//
//  Created by Fox on 14-7-5.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject
//学年
@property(nonatomic,strong) NSString *school_year;
//学期
@property(nonatomic,strong) NSString *course_term;
//课程名
@property(nonatomic,strong) NSString *course_name;
//课程编号
@property(nonatomic,strong) NSString *course_number;
//课程性质
@property(nonatomic,strong) NSString *course_nature;
//课程学分
@property(nonatomic,strong) NSString *course_credit;
//课程绩点
@property(nonatomic,strong) NSString *course_point;
//课程分数
@property(nonatomic,strong) NSString *course_score;
//是否补考
@property(nonatomic,strong) NSString *makeup_score;
//用户操作
@property(nonatomic,strong) NSString *course_action;
 @end
