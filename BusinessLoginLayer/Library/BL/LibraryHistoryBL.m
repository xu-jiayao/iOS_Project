//
//  LibraryHistoryBL.m
//  i西科
//
//  Created by MAC on 14-8-1.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "LibraryHistoryBL.h"

#import "HistoryTable.h"
#import "HistoryDAO.h"

@interface LibraryHistoryBL()
{
    HistoryDAO *dao;
    NSMutableArray *array;
}
@end

@implementation LibraryHistoryBL

-(NSMutableArray *)findData{
    dao = [HistoryDAO new];
    
    array = [NSMutableArray arrayWithCapacity:2];
    
    array = [dao finfAll];
    
   
    return array;
}

-(void)deleteData{

    HistoryDAO *historyDao = [HistoryDAO new];
    [historyDao remove];

}
@end
