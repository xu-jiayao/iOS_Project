//
//  CourseTableBL.h
//  i西科
//
//  Created by MAC on 15/1/20.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseTableDAO.h"
@interface CourseTableBL : NSObject
{
     NSString *curWeekStr;
}

//查询所用数据方法
-(NSString*) findCurrentTerm;


//上传课表
-(void)uploadCourse;
-(void)deleteAllCourseInServer;

-(NSMutableDictionary *)findData;

-(NSMutableArray *)findDataByKey:(NSString *)weekDay;
-(NSMutableArray *)handleDataForWeek;

-(void)deleteData;

@end
