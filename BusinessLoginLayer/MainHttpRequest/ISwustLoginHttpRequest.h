//
//  ISwustLoginHttpRequest.h
//  i西科
//
//  Created by MAC on 15/1/21.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "Sign.h"
#import "AccountNumberInfo.h"
#import "Config.h"
#import "Tools.h"
@interface ISwustLoginHttpRequest : NSObject
{
    NSArray *_array;
}

-(void)justiSwustLoginHttpRequest;
@end
