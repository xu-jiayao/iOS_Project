//
//  LibPersonal.h
//  i西科
//
//  Created by Fox on 14-9-28.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibPersonal : NSObject
@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSString *IDNumber;

@property(nonatomic,strong) NSString *debt;

@property(nonatomic,strong) NSString *maxBorrow;

@property(nonatomic,strong) NSString *department;

@property(nonatomic,strong) NSString *IDCard;

//违章次数
@property(nonatomic,strong) NSString *violateTimes;

@property(nonatomic,strong) NSString *total;

@end
