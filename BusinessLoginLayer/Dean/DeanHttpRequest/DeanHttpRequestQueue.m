//
//  DeanHttpRequestQueue.m
//  i西科
//
//  Created by MAC on 15/1/12.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "DeanHttpRequestQueue.h"
#import "CourseTableParser.h"
#import "ExamParser.h"
#import "ScoreParser.h"
#import "DeanPersonalParser.h"
#import "EvaluateParser.h"
#import "config.h"
#import "DeanTeacherPersonalParser.h"
@implementation DeanHttpRequestQueue

-(void)startDean_ALLHttpRequest{

    [self startDean_CourseTableHttpRequest];
    [self startDean_ScoreHttpRequest];
    [self startDean_ExamHttpRequest];
    [self startDean_PersonalHttpRequest];
}

-(void)startDean_PersonalHttpRequest{
    __weak ASIHTTPRequest *requestPersonal;
    
    if([[Config Instance ]getIsTeacher] == YES){
        requestPersonal = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Teacher_Personal]];
        [requestPersonal setValidatesSecureCertificate:NO];
        [requestPersonal setCompletionBlock:^{
            DeanTeacherPersonalParser *parser = [DeanTeacherPersonalParser new];
            [parser parserTeacherPersonal:[requestPersonal responseData]];
            
        }];

    }
    else{
    requestPersonal = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Personal]];
        [requestPersonal setValidatesSecureCertificate:NO];
        [requestPersonal setCompletionBlock:^{
            DeanPersonalParser *parser = [DeanPersonalParser new];
            [parser parserPersonal:[requestPersonal responseData]];
            
        }];
    }
    //公共部分
    [requestPersonal setFailedBlock:^{
        NSLog(@"个人信息请求错误：%s:error == %@",__FUNCTION__,requestPersonal.error);
    }];
    [requestPersonal startSynchronous];
    
}

-(void)startDean_CourseTableHttpRequest{
    __weak ASIHTTPRequest *requestCourseTable;
    if([[Config Instance]getIsTeacher] == YES){
         requestCourseTable= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Teacher_CourseTable]];
    }
    else{
        requestCourseTable = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_CourseTable]];
    }
    // [requestCourseTable setDelegate:self];
    [requestCourseTable setValidatesSecureCertificate:NO];
    [requestCourseTable setCompletionBlock:^{
        CourseTableParser *parser = [CourseTableParser new];
        [parser parserCoursetable:[requestCourseTable responseData]];
        
    }];
    [requestCourseTable setFailedBlock:^{
        NSLog(@"课表请求错误：%s:error == %@",__FUNCTION__,requestCourseTable.error);
    }];
    [requestCourseTable startSynchronous];
    
    
}
-(void)startDean_ScoreHttpRequest{
    
    
    __weak ASIHTTPRequest *requestScore = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Score]];
    //  [requestScore setDelegate:self];
    [requestScore setValidatesSecureCertificate:NO];
    [requestScore setCompletionBlock:^{
        ScoreParser *parser = [ScoreParser new];
        [parser parserScore:[requestScore responseData]];
    }];
    [requestScore setFailedBlock:^{
        NSLog(@"成绩请求错误：%s:error == %@",__FUNCTION__,requestScore.error);
    }];
    [requestScore startSynchronous];
 
}

-(void)startDean_ScoreHttpRequest_BG{
    
    
    __weak ASIHTTPRequest *requestScore = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Score]];
    //  [requestScore setDelegate:self];
    [requestScore setValidatesSecureCertificate:NO];
    [requestScore setCompletionBlock:^{
        ScoreParser *parser = [ScoreParser new];
        [parser parserScore_BG:[requestScore responseData]];
    }];
    [requestScore setFailedBlock:^{
        NSLog(@"成绩请求错误：%s:error == %@",__FUNCTION__,requestScore.error);
    }];
    [requestScore startAsynchronous];
    
}

-(void)startDean_ExamHttpRequest{
    
    __weak ASIHTTPRequest *requestExam = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Exam]];
    //[requestExam setDelegate:self];
    // 默认为YES, 你可以设定它为NO来禁用gzip压缩
    [requestExam setAllowCompressedResponse:YES];
    [requestExam setValidatesSecureCertificate:NO];
    [requestExam setCompletionBlock:^{
        ExamParser *parser = [ExamParser new];
        [parser parserExam:[requestExam responseData]];
    }];
    [requestExam setFailedBlock:^{
        NSLog(@"考试请求错误：%s:error == %@",__FUNCTION__,requestExam.error);
    }];
    [requestExam startSynchronous];
}


-(void)startDean_EvaluateOnlineRequest{
    __weak ASIHTTPRequest *requestEvaluate = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Dean_Evaluate]];
    [requestEvaluate setAllowCompressedResponse:YES];
     [requestEvaluate setValidatesSecureCertificate:NO];
    [requestEvaluate setCompletionBlock:^{
//        NSLog(@"评教string == %@",[requestEvaluate responseString]);
        EvaluateParser *parser = [EvaluateParser new];
        [parser parserEvaluate:[requestEvaluate responseData]];
    }];
    [requestEvaluate setFailedBlock:^{
        NSLog(@"评教请求错误：%s:error == %@",__FUNCTION__,requestEvaluate.error);
    }];
    [requestEvaluate startSynchronous];
}

@end
