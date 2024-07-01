//
//  SearchBook.m
//  i西科
//
//  Created by weixvn_android on 15/4/25.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "SearchBook.h"

@implementation SearchBook{
    BookInfo *bookInfo;
}

-(void)Toplend{
    
    NSMutableArray *bookArry = [[NSMutableArray alloc] init];
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:URL_Library_TopLend]];
    [request setAllowCompressedResponse:YES];
    [request setCompletionBlock:^(void){
        
        NSData *reponsData = [request responseData];
        NSLog(@"-----热门借阅----\n");
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:reponsData];
        NSArray *arry = [[[hpple searchWithXPathQuery:@"//div/div/table"] objectAtIndex:0] children];
        int i = 3;
        
        
        while (i <= 101) {
            bookInfo = [[BookInfo alloc] init];
            NSArray *book = [[arry objectAtIndex:i] children];
            TFHppleElement *rankNumber = [[[book objectAtIndex:1] children] objectAtIndex:0];
            NSLog(@"图书借阅排名:%@\n",[rankNumber content]);
            
            TFHppleElement *bookHref_BookName = [[[book objectAtIndex:3] children] objectAtIndex:0];
            TFHppleElement *bookName = [[bookHref_BookName children] objectAtIndex:0];
            NSLog(@"书名:%@\n",[bookName content]);
            bookInfo.bookName = [bookName content]; 
            TFHppleElement *bookWriter = [[[book objectAtIndex:5] children] objectAtIndex:0];
            NSLog(@"作者:%@\n",[bookWriter content]);
            bookInfo.bookWriter = [bookWriter content];
            
            TFHppleElement *bookIndex = [[[book objectAtIndex:9] children] objectAtIndex:0];
            NSLog(@"索书号:%@\n",[bookIndex content]);
            bookInfo.bookIndex = [bookIndex content];
            NSDictionary *bookHref_dic = [bookHref_BookName attributes];
            NSString *str = [[NSString alloc] init];
            str = [bookHref_dic objectForKey:@"href"];
            str = [str substringFromIndex:8];
            NSLog(@"图书连接:%@\n\n\n",str);
            bookInfo.bookHref = str;
      //      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[[rankNumber content],[bookName content],[bookIndex content],str] forKeys:@[@"rankNumber",@"bookName",@"bookIndex",@"bookhref"]];
            //  [dic writeToFile:plistPath atomically:YES];
            
            [bookArry addObject:bookInfo];
            
            i = i + 2;
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_TopLend" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"热门搜索成功",bookArry] forKeys:@[@"Message",@"BookArray"]]];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (error) {
            
            NSLog(@"%s:error == %@",__FUNCTION__,error);
        }
    }];
    [request startAsynchronous];
    
}
-(void)seacrhBy_bookName:(NSString *)Str{
    NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    NSString *str1 = @"http://202.115.162.45:8080/opac/openlink.php?strSearchType=title&match_flag=forward&historyCount=1&strText=";
    NSString *str2 =@"&doctype=ALL&displaypg=100&showmode=list&sort=CATA_DATE&orderby=desc&location=ALL";
    NSString *urlStr = [[NSString alloc] init];
    //字符串转码
    Str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    
    urlStr = [urlStr stringByAppendingFormat:@"%@%@%@",str1,Str,str2];
    NSLog(@"%@\n",urlStr);
    
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setAllowCompressedResponse:YES];
    [request setCompletionBlock:^{
        
        NSData *reponsData = [request responseData];
        NSString *str = [[NSString alloc] initWithData:reponsData encoding:NSUTF8StringEncoding];
        NSLog(@"-----按书名搜索----%@\n",str);
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:reponsData];
        NSArray *books = [hpple searchWithXPathQuery:@"//div/div/div/div/ol/li"];
        
        for (int i = 0; i < [books count]; i++) {
            
            bookInfo = [[BookInfo alloc] init];
            
            NSArray *bookName = [[books objectAtIndex:i] children];
            NSArray *ary1 = [[bookName objectAtIndex:3] children];
            
            
            NSArray *ary2 = [[[[bookName  objectAtIndex:1] children] objectAtIndex:1] children];
            TFHppleElement *bookNameStr = [ary2 objectAtIndex:0];
           
            bookInfo.bookName = [bookNameStr content];
            TFHppleElement *writer = [ary1 objectAtIndex:2];
            NSLog(@"作者:%@\n",[writer content]);
            bookInfo.bookWriter = [writer content];
            
            TFHppleElement *jieyueCountStart = [[[ary1 objectAtIndex:1] children] objectAtIndex:0];
            TFHppleElement * jieyueCountEnd = [[[ary1 objectAtIndex:1] children] objectAtIndex:2];
            NSLog(@"可借阅的数目:%@----%@\n",[jieyueCountStart content],[jieyueCountEnd content]);
            
            NSArray *jieyueUrls = [hpple searchWithXPathQuery:@"//div/div/div/div/ol/li/p/a"];
            NSDictionary *jieyueUrl_dic = [[jieyueUrls objectAtIndex:i] attributes];
            
            NSLog(@"可借阅书籍的链接:%@\n",[jieyueUrl_dic objectForKey:@"href"]);
            
            bookInfo.bookHref = [jieyueUrl_dic objectForKey:@"href"];
            [bookArray addObject:bookInfo];
          
        }
        if([bookArray count] != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Search" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"搜索成功",bookArray] forKeys:@[@"Message",@"BookArray"]]];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Search" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"书名搜索不到",bookArray] forKeys:@[@"Message",@"BookArray"]]];
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (error) {
            
            NSLog(@"%s:error == %@",__FUNCTION__,error);
        }
    }];
    [request startAsynchronous];
    
}
-(void)searchBy_Writer:(NSString *)Str{
    
    NSMutableArray *bookArray = [[NSMutableArray alloc] init];
    NSString *str1 = @"http://202.115.162.45:8080/opac/openlink.php?strSearchType=author&match_flag=forward&historyCount=1&strText=";
    NSString *str2 =@"&doctype=ALL&displaypg=20&showmode=list&sort=CATA_DATE&orderby=desc&location=ALL";
    NSString *urlStr = [[NSString alloc] init];
    //字符串转码
    Str = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Str,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
    urlStr = [urlStr stringByAppendingFormat:@"%@%@%@",str1,Str,str2];
    NSLog(@"%@\n",urlStr);
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setAllowCompressedResponse:YES];
    [request setCompletionBlock:^{
        
        NSData *reponsData = [request responseData];
        NSString *str = [[NSString alloc] initWithData:reponsData encoding:NSUTF8StringEncoding];
        NSLog(@"-----作者搜索----%@\n",str);
        
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:reponsData];
        NSArray *books = [hpple searchWithXPathQuery:@"//div/div/div/div/ol/li"];
        
        for (int i = 0; i < [books count]; i++) {
            bookInfo = [[BookInfo alloc] init];
            NSArray *bookName = [[books objectAtIndex:i] children];
            NSArray *ary1 = [[bookName objectAtIndex:3] children];
            
            
            NSArray *ary2 = [[[[bookName  objectAtIndex:1] children] objectAtIndex:1] children];
            TFHppleElement *bookNameStr = [ary2 objectAtIndex:0];
            NSLog(@"书名:%@\n",[bookNameStr content]);
            bookInfo.bookName = [bookNameStr content];
            TFHppleElement *writer = [ary1 objectAtIndex:2];
            NSLog(@"作者:%@\n",[writer content]);
            bookInfo.bookWriter = [writer content];
            
            TFHppleElement *jieyueCountStart = [[[ary1 objectAtIndex:1] children] objectAtIndex:0];
            TFHppleElement * jieyueCountEnd = [[[ary1 objectAtIndex:1] children] objectAtIndex:2];
            NSLog(@"可借阅的数目:%@----%@\n",[jieyueCountStart content],[jieyueCountEnd content]);
            
            NSArray *jieyueUrls = [hpple searchWithXPathQuery:@"//div/div/div/div/ol/li/p/a"];
            NSDictionary *jieyueUrl_dic = [[jieyueUrls objectAtIndex:i] attributes];
            
            NSLog(@"可借阅书籍的链接:%@\n",[jieyueUrl_dic objectForKey:@"href"]);
            bookInfo.bookHref = [jieyueUrl_dic objectForKey:@"href"];
            [bookArray addObject:bookInfo];
            
        }
        if([bookArray count] != 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Search" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"搜索成功",bookArray] forKeys:@[@"Message",@"BookArray"]]];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Search" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"作者搜索不到",bookArray] forKeys:@[@"Message",@"BookArray"]]];
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if (error) {
            
            NSLog(@"%s:error == %@",__FUNCTION__,error);
        }
    }];
    [request startAsynchronous];
    
}
-(void)searchPlace:(BookInfo *)bookinfo{
    
    NSString *urlStr = [[NSString alloc] init];
    urlStr = [urlStr stringByAppendingFormat:@"%@%@",@"http://202.115.162.45:8080/opac/",bookinfo.bookHref];
    NSLog(@"图书详细链接:%@\n",urlStr);
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[[NSURL alloc] initWithString:urlStr]];
    [request setAllowCompressedResponse:YES];//gzip压缩
    [request setCompletionBlock:^{
        NSMutableArray *bookPlaceArray = [[NSMutableArray alloc] init];
        
        NSData *responseData = [request responseData];
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:responseData];
        
        
        
        NSArray *arryMassege = [hpple searchWithXPathQuery:@"//div/div/div/div/ul/li/a"];
        NSDictionary *elementMassege =[[arryMassege objectAtIndex:0] attributes];
        
        
        
        NSString *urlStrDouban = [elementMassege objectForKey:@"href"];
        NSURL *urlDouban = [[NSURL alloc] initWithString:urlStrDouban];
        ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:urlDouban];
        [request1 setAllowCompressedResponse:YES];//gzip压缩
        [request1 startAsynchronous];
        [request1 setCompletionBlock:^{
            
            TFHpple *hppleDouban = [[TFHpple alloc] initWithHTMLData:[request1 responseData]];
            NSArray *arryDouban = [hppleDouban searchWithXPathQuery:@"//div/div/div/div/div/div/div/div/p"];
            if([arryDouban count] > 2){
                TFHppleElement *elementDouban = [arryDouban objectAtIndex:2];
                NSLog(@"图书摘要:%@\n",[elementDouban text]);
                NSString *str = [elementDouban text];
                str = [str stringByAppendingString:@"(提示:该数据来自豆瓣读书)"];
                if(str == nil)
                    str = @"暂无";
                bookinfo.bookMassege = str;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Detail" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"获取图书摘要成功",bookinfo.bookMassege] forKeys:@[@"Message",@"summury"]]];
            }else{
                bookinfo.bookMassege = @"暂无";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Detail" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"获取图书摘要成功",bookinfo.bookMassege] forKeys:@[@"Message",@"summury"]]];
            }
            
        }];
        [request1 setFailedBlock:^{
            bookinfo.bookMassege = @"暂无";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Detail" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"获取图书摘要成功",bookinfo.bookMassege] forKeys:@[@"Message",@"summury"]]];
        }];
        
        
        
        NSString *str;
        NSArray *arry1 = [hpple searchWithXPathQuery:@"//div/div/div/div/div/table"];
        NSArray *arry2 = [[arry1 objectAtIndex:0] children];
        for (int i = 3; i < [arry2 count]; i++) {
            if(i%2 != 0){
                
                NSArray *arry3 = [[arry2 objectAtIndex:i] children];
                TFHppleElement *elementIndex = [[[arry3 objectAtIndex:1] children] objectAtIndex:0];
                NSLog(@"索书号:%@\n",[elementIndex content]);
                if([elementIndex content] == nil)
                bookinfo.bookIndex = @"此书刊可能正在订购中或者处理中";
                else
                    bookinfo.bookIndex = [elementIndex content];
                if([arry3 count] > 7){
                    TFHppleElement *elementPlace =  [[[arry3 objectAtIndex:7] children] objectAtIndex:1];
                    NSLog(@"馆藏地:%@\n",[elementPlace content]);
                    bookinfo.bookPlace = [elementPlace content];
                }else{
                    bookinfo.bookPlace = @"暂无";
                }
                
                if ([arry3 count] > 9) {
                    
                TFHppleElement *elementState = [[[arry3 objectAtIndex:9] children] objectAtIndex:0];
                if ([elementState content] == nil) {
                    elementState = [[[[[arry3 objectAtIndex:9] children] objectAtIndex:0] children] objectAtIndex:0];
                 }
                
                NSLog(@"书刊状态:%@\n",[elementState content]);
                str = [elementState content];
                if (str.length > 4) {
                    str = [str substringToIndex:2];
                  }
                    
                }else{
                str = @"暂无";
                }
              
                
                NSDictionary *bookPlaceDic = [[NSDictionary alloc] initWithObjects:@[bookinfo.bookIndex,bookinfo.bookPlace,str] forKeys:@[@"bookIndex",@"bookPlace",@"bookState"]];
                [bookPlaceArray addObject:bookPlaceDic];
            }
            
        }
        
        bookinfo.bookPlace = bookPlaceArray;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Library_SearchBook_Detail" object:nil userInfo:[NSDictionary dictionaryWithObjects:@[@"搜索图书详情成功",bookinfo] forKeys:@[@"Message",@"BookDetail"]]];
    }];
    [request startAsynchronous];
    
}

@end
