//
//  ISwustServerHttpRequest.h
//  i西科
//
//  Created by MAC on 15/1/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sign.h"
#import "ASIFormDataRequest.h"
#import "ISwustServerParser.h"
@interface ISwustServerHttpRequest : NSObject
{
    ISwustServerParser *parser;
}
-(void)startiSwustServerHttpRequest:(Sign *)signItem ActionURL:(ISwustServerIndex )actionIndex;


@end
