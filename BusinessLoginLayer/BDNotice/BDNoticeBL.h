//
//  BDNoticeBL.h
//  i西科
//
//  Created by zw on 14-10-23.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDNoticeItem.h"
#include "BDNoticeDAO.h"
@interface BDNoticeBL : NSObject

-(void)insertNews:(NSString *)alert;

-(void)changeNews:(NSString *)alert andDate:(NSString *)date;

-(NSMutableArray *)findData;

-(int)findUnreadMessageCount;

///把所有消息设置为已读
-(void)setMessageAllisReaded;

- (void)remove;
@end
