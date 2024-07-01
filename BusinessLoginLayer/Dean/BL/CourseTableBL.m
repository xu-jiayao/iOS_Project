//
//  CourseTableBL.m
//  i西科
//
//  Created by MAC on 15/1/20.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "CourseTableBL.h"
#import "Config.h"
#import "ISwustServerInterface.h"
@implementation CourseTableBL

-(NSString*) findCurrentTerm{
    CourseTableDAO *dao = [CourseTableDAO shareManager];
    return [dao findCourse_academic_semester];
}

#pragma 判断课程是否过了当前周
-(BOOL)hiddenDataByWeek:(NSString *)weekStr{
    
    //  NSString *weekNum = [curWeekStr substringWithRange:NSMakeRange(1, curWeekStr.length-4)];
    
    if ([weekStr rangeOfString:@"-"].location != NSNotFound) {
        NSString *startWeek = [weekStr substringWithRange:NSMakeRange(0, 2)];
        NSString *endWeek = [weekStr substringWithRange:NSMakeRange(3, 2)];
        if ([startWeek intValue] <= [curWeekStr intValue] && [endWeek intValue] >= [curWeekStr intValue]) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        
        //BUG
        if ([weekStr rangeOfString:@"1"].location != NSNotFound) {
            return YES;
        }else{
            return NO;
        }
    }
}


-(void)getCurrentWeek{
    
    curWeekStr = [[[Config Instance]getCurrentWeek]substringWithRange:NSMakeRange(1, 1)];
    
//    UserinfoBL *userBL = [UserinfoBL new];
//    //  NSString *weekStr = [userBL findCurWeekStr];
//    NSString *differentialWeek = [userBL findDifferentialWeekStr];
//    
//    
//    NSDate*date = [NSDate date];
//    NSCalendar*calendar = [NSCalendar currentCalendar];
//    NSDateComponents*comps;
//    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
//                       fromDate:date];
//    NSInteger week = [comps week]; // 今年的第几周
//    
//    
//    curWeekStr = [NSString stringWithFormat:@"%d",week - [differentialWeek intValue]];
}

-(NSMutableArray *)handleData{
    [self getCurrentWeek];

    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    NSArray *allData = [courseDao finfAll];
    
    NSMutableArray *reArray = [NSMutableArray new];
    for (CourseTable *courseitem in allData) {
        if ([self hiddenDataByWeek:courseitem.course_week]) {
            [reArray addObject:courseitem];
        }
    }
    return reArray;
}
-(NSMutableArray *)handleDataForWeek{
    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    NSMutableArray *allData = [courseDao finfAll];
    
//    NSMutableArray *reArray = [NSMutableArray new];
//    for (CourseTable *courseitem in allData) {
//        
//        [reArray addObject:courseitem];
//    }
    return allData;
}

-(NSMutableDictionary *)findData{
    
    NSArray *allData = [self handleData];
    
    NSMutableDictionary* Dict = [NSMutableDictionary new];
    for (CourseTable *item2 in allData)
    {
        NSArray * allkey = [Dict allKeys];
        if ([allkey containsObject:item2.course_weekday] && ![item2.course_name isEqualToString:@" "]) {
            NSMutableArray *value = [Dict objectForKey:item2.course_weekday];
            [value addObject:item2];
        }
        else if(![item2.course_name isEqualToString:@" "]){
            NSMutableArray *value = [[NSMutableArray alloc]init];
            [value addObject:item2];
            [Dict setObject:value forKey:item2.course_weekday];
        }
    }
    
    return Dict;
}


-(NSMutableArray *)findDataByKey:(NSString *)weekDay{
    
    

    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    
    NSMutableArray *all = [courseDao findByKey:weekDay];
    return all;
}

-(void)deleteData{
    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    [courseDao remove];
}

-(void)uploadCourse{
    //course_action = 0  添加
    
    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    NSArray *allData = [courseDao finfAll];
    NSMutableArray *array = [NSMutableArray new];
    
    for (CourseTable *courseItem in allData) {
        NSDictionary *finalDict = [NSDictionary dictionaryWithObjects:@[courseItem.course_academic_semester,courseItem.course_name,courseItem.course_section,courseItem.course_week,courseItem.course_place,courseItem.course_teacher,courseItem.course_weekday,[NSNumber numberWithInt:0]] forKeys:@[@"course_academic_semester",@"course_name",@"course_section",@"course_week",@"course_place",@"course_teacher",@"course_weekday",@"course_action"]];
        
        [array addObject:finalDict];
       // array = [NSArray arrayWithObject:finalDict];
    }
    
     NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"course_list"];
    ISwustServerInterface *iswustServer = [ISwustServerInterface new];
    [iswustServer ISwust_uploadCourse:dict];
    
}

-(void)deleteAllCourseInServer{
    
    //course_action = 1   删除

    CourseTableDAO *courseDao = [CourseTableDAO shareManager];
    NSArray *allData = [courseDao finfAll];
    NSMutableArray *array = [NSMutableArray new];
    
    for (CourseTable *courseItem in allData) {
        NSDictionary *finalDict = [NSDictionary dictionaryWithObjects:@[courseItem.course_academic_semester,courseItem.course_name,courseItem.course_section,courseItem.course_week,courseItem.course_place,courseItem.course_teacher,courseItem.course_weekday,[NSNumber numberWithInt:1]] forKeys:@[@"course_academic_semester",@"course_name",@"course_section",@"course_week",@"course_place",@"course_teacher",@"course_weekday",@"course_action"]];
        
        [array addObject:finalDict];
        // array = [NSArray arrayWithObject:finalDict];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"course_list"];
//    ISwustServerInterface *iswustServer = [ISwustServerInterface new];
//    [iswustServer ISwust_downloadCourse:dict];

}

@end
