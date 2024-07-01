//
//  LibraryCurrentBL.m
//  i西科
//
//  Created by MAC on 14-8-2.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "LibraryCurrentBL.h"
#import "CurrentDAO.h"
#import "CurrentTable.h"
#import "Tools.h"
#import "Config.h"
@implementation LibraryCurrentBL

-(NSMutableArray *)findData{
    CurrentDAO *dao = [CurrentDAO new];
    
    NSMutableArray *array = [dao finfAll];
    return array;
}


-(void)updateCurrentBorrowDate{
    NSArray *array_ALL = [self findData];
    int days_FLAG = 0;
    for (CurrentTable *item in array_ALL) {
        NSArray *array_Date = [item.BACKDATA componentsSeparatedByString:@"-"];
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
            
            NSString *message = [NSString stringWithFormat:@"您有%d本书在本周内要到期了，注意归还哦！没看够的话，那就去图书馆里点击一键续借哦！",days_FLAG];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
    }
   
    
}

-(void)deleteData{
    CurrentDAO *curDao = [CurrentDAO new];
    [curDao remove];
}

@end
