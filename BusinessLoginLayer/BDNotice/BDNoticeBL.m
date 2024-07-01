//
//  BDNoticeBL.m
//  i西科
//
//  Created by zw on 14-10-23.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "BDNoticeBL.h"

@interface BDNoticeBL()
{
    BDNoticeItem *newsItem;
    BDNoticeDAO  *dao;
}
@end
@implementation BDNoticeBL

-(void)insertNews:(NSString *)alert
{
    BDNoticeDAO *newsDao = [BDNoticeDAO sharedManager];
    
    newsItem = [BDNoticeItem new];
    
    newsItem.alert = alert;
    
    newsItem.isRead = @"0";
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    newsItem.date = locationString;
    
    [newsDao insert:newsItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_PushMessage_Notice" object:nil userInfo:nil];
    
}

-(void)changeNews:(NSString *)alert andDate:(NSString *)date
{
    BDNoticeDAO *newsDao = [BDNoticeDAO sharedManager];
    
    newsItem = [BDNoticeItem new];
    
    newsItem.alert = alert;
    
    newsItem.isRead = @"1";
    
    newsItem.date = date;
    
    [newsDao insert:newsItem];
}

-(void)setMessageAllisReaded{
    [dao setHasReadedMessage];
}

-(NSMutableArray *)findData{
    dao = [BDNoticeDAO sharedManager];
    NSMutableArray *reArray = [dao findData];
    
    return  reArray;
}

-(int)findUnreadMessageCount{
    dao = [BDNoticeDAO sharedManager];
    
    NSMutableArray *reArray = [dao findData];
    
    int returnNum = 0;
    for (NSDictionary *item in reArray) {
        
        if ([[item objectForKey:@"isRead"] isEqualToString:@"0"]) {
            returnNum++;
        }
    }
    return returnNum;
}

- (void)remove{
    dao = [BDNoticeDAO sharedManager];
    
    [dao remove];
    
}

@end
