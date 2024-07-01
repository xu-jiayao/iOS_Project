//
//  ExamBL.h
//  i西科
//
//  Created by 陈识宇 on 15-1-15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamBL : NSObject

//查询所用数据方法
-(NSMutableArray*) readData;

-(void)updateExamRemindDate;

-(void)deleteData;

@end
