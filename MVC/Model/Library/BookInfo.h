//
//  BookInfo.h
//  i西科
//
//  Created by weixvn_android on 15/4/25.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInfo : NSObject
@property(strong,nonatomic)NSString *bookName;
@property(strong,nonatomic)NSString *bookWriter;
@property(strong,nonatomic)NSString *bookHref;
@property(strong,nonatomic)NSString *bookIndex;
@property(strong,nonatomic)NSArray  *bookPlace;
@property(strong,nonatomic)NSString *bookMassege;
@end
