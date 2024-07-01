//
//  BDNoticeItem.h
//  i西科
//
//  Created by zw on 14-10-23.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDNoticeItem : NSObject
@property(nonatomic,strong) NSString *alert;
@property(nonatomic,strong) NSString *date;

//0:未读  1:已读
@property(nonatomic,strong) NSString *isRead;




@end
