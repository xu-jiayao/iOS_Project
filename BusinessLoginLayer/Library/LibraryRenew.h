//
//  LibraryRenew.h
//  i西科
//
//  Created by MAC on 14-9-23.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "TFHpple.h"
@interface LibraryRenew : NSObject
{
    ASIFormDataRequest *_request;
}

-(void) initWithRENEWURL:(NSString *)barCode barCheck
                        :(NSString *)barCheck;

@end
