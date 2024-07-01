//
//  DeanHttpRequestQueue.h
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface DeanHttpRequestQueue : NSObject

-(void)startDean_ALLHttpRequest;
-(void)startDean_ScoreHttpRequest_BG;

-(void)startDean_CourseTableHttpRequest;
-(void)startDean_ScoreHttpRequest;
-(void)startDean_ExamHttpRequest;
-(void)startDean_PersonalHttpRequest;
-(void)startDean_EvaluateOnlineRequest;
@end
