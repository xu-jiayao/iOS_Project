//
//  EvaluateOnlineBL.m
//  i西科
//
//  Created by MAC on 15/1/4.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "EvaluateOnlineBL.h"

@implementation EvaluateOnlineBL

-(NSMutableArray *)findData{
    EvaluateOnlineDAO *evaluateDao = [EvaluateOnlineDAO sharedManager];
    NSMutableArray *outArray = [evaluateDao findCourseData];
    return outArray;
}

@end
