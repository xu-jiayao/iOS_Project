//
//  ScoreBL.h
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreBL : NSObject
@property(nonatomic,strong) NSArray *scoreForSchoolYear;

-(NSMutableDictionary *) readWithSchoolYear:(NSString *)schoolYearStr;

//get所有学年
-(NSMutableArray *)getArrForSchoolYear;

-(void)uploadScore;

-(void)deleteData;

@property (nonatomic,strong)NSMutableArray *arrForPoint;

-(NSMutableArray *)arrForPoint;
@end
