//
//  LibraryHttpRequest.m
//  i西科
//
//  Created by houborui on 15-1-16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "LibraryHttpRequest.h"
#import "LibraryCurrentParser.h"
#import "LibraryHistoryParser.h"

@implementation LibraryHttpRequest

-(void)startHttpRequest{
    
    __weak ASIHTTPRequest *requestLibCurrent = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Library_Current]];
    // [requestCourseTable setDelegate:self];
    [requestLibCurrent setTimeOutSeconds:20];//设置超时
    
    [requestLibCurrent setCompletionBlock:^{
        LibraryCurrentParser *parser = [LibraryCurrentParser new];
        [parser parserLibraryCurrent:[requestLibCurrent responseData]];
        
    }];
    [requestLibCurrent setFailedBlock:^{
        NSLog(@"图书馆 当前借阅 请求错误：%s:error == %@",__FUNCTION__,requestLibCurrent.error);
    }];
    [requestLibCurrent startAsynchronous];
    
    
    
    __weak ASIHTTPRequest *requestLibHistory = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Library_History]];
    //[requestExam setDelegate:self];
    // 默认为YES, 你可以设定它为NO来禁用gzip压缩
    [requestLibHistory setAllowCompressedResponse:YES];
    [requestLibHistory setCompletionBlock:^{
        LibraryHistoryParser *parser = [LibraryHistoryParser new];
        [parser parserLibraryHistoryParser:[requestLibHistory responseData]];
    }];
    [requestLibHistory setFailedBlock:^{
        NSLog(@"图书馆 借阅历史 请求错误：%s:error == %@",__FUNCTION__,requestLibHistory.error);
    }];
    [requestLibHistory startAsynchronous];
    
    
}


@end
