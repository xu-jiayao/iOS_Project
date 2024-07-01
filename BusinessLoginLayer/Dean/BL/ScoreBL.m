//
//  ScoreBL.m
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ScoreBL.h"
#import "Score.h"
#import "ScoreDAO.h"
#import "ISwustServerInterface.h"
@interface ScoreBL()
{
    Score *scoreItem;
    ScoreDAO *scoreDao;
}

@end


@implementation ScoreBL
@synthesize arrForPoint;
-(void)uploadScore{
    scoreDao = [ScoreDAO shareManager];
    NSArray *allData = [scoreDao finfAll];
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *score_action = [NSNumber numberWithInt:0];
    
    for (Score *item in allData) {
        NSDictionary *finalDict = [NSDictionary dictionaryWithObjects:@[item.school_year,item.course_term,item.course_name,item.course_number,item.course_nature,item.course_credit,item.course_point,item.course_score,item.makeup_score,score_action] forKeys:@[@"school_year",@"course_term",@"course_name",@"course_number",@"course_nature",@"course_credit",@"course_point",@"course_score",@"makeup_score",@"score_action",]];
        
        [array addObject:finalDict];
        // array = [NSArray arrayWithObject:finalDict];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"score_list"];
    ISwustServerInterface *iswustServer = [ISwustServerInterface new];
    [iswustServer ISwust_AddScore:dict];

}

-(NSMutableDictionary *) readWithSchoolYear:(NSString *)schoolYearStr{

    scoreDao = [ScoreDAO shareManager];

    NSArray *allData  = [scoreDao finfAll];
    NSMutableArray *arrayScore = [NSMutableArray new];
    
    for (Score *item in allData) {
        if ([item.school_year isEqualToString:schoolYearStr]) {
            [arrayScore addObject:item];
        }
    }
    
    
    arrForPoint = [NSMutableArray new];
    
    
    NSMutableDictionary* Dict = [NSMutableDictionary new];
    for (Score *item2 in arrayScore)
    {
        NSArray * allkey = [Dict allKeys];
        if ([allkey containsObject:item2.course_term]) {
            NSMutableArray *value = [Dict objectForKey:item2.course_term];
            if (![item2.course_name isEqualToString:@"平均绩点"] && ![item2.course_name isEqualToString:@"必修课绩点"]) {
                [value addObject:item2];
                
            }else{
                [arrForPoint addObject:item2];
            }
        }
        else{
            NSMutableArray *value = [[NSMutableArray alloc]init];
            if (![item2.course_name isEqualToString:@"平均绩点"] && ![item2.course_name isEqualToString:@"必修课绩点"]) {
                [value addObject:item2];
                
            }else{
                [arrForPoint addObject:item2];
            }
            [Dict setObject:value forKey:item2.course_term];
        }
    }
    return Dict;
}

-(NSMutableArray *)arrForPoint{
    return arrForPoint;
}

-(NSMutableArray *)getArrForSchoolYear{
    scoreDao = [ScoreDAO shareManager];
    
    NSMutableArray* arr  = [scoreDao findSchoolYear];
    
    return arr;
}

-(void)deleteData{
    scoreDao = [ScoreDAO shareManager];
    [scoreDao remove];
}


@end
