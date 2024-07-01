//
//  ExamBL.m
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ExamBL.h"
#import "ExamDAO.h"
#import "Exam.h"
#import "Tools.h"
#import "Config.h"
@implementation ExamBL

//查询所用数据方法
-(NSMutableArray*) readData
{
    ExamDAO *examDao = [ExamDAO shareManager];
    
    NSMutableArray* list  = [examDao findAll];
    
    return list;
}

-(void)updateExamRemindDate{
    NSArray *arr_Exam = [self readData];
    int days_FLAG = 0;
    for ( Exam *examItem in arr_Exam) {
        NSArray *array_Date = [examItem.examDate componentsSeparatedByString:@"/"];
        NSString *backDateStr = [NSString stringWithFormat:@"%@%@%@",[array_Date objectAtIndex:0],[array_Date objectAtIndex:1],[array_Date objectAtIndex:2]];
        
        int currDate = [[Tools getCurrentDate] intValue];
        int latestDate = [backDateStr intValue];
        
        int remindDays = latestDate - currDate - 1;
        
        if(remindDays == 1 || remindDays == 3 || remindDays == 5 || remindDays == 7)
        {
            days_FLAG++;
            
        }
    }
    
    if (days_FLAG > 0) {
        if ( [[Tools getCurrentDate]intValue] - [[[Config Instance]getAppOpenDate]intValue] >= 1) {
            
            [[Config Instance]saveAppOpenDate:[Tools getCurrentDate]];
            
            NSString *message = [NSString stringWithFormat:@"本周内有%d门考试，记得复习哦！",days_FLAG];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        

    }

}

-(void)deleteData{
    ExamDAO *examDao = [ExamDAO shareManager];
    [examDao remove];
}

@end
