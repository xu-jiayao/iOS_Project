//
//  Update.h
//  i西科
//
//  Created by weixvn_ios on 15/1/23.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Update : NSObject
{
    NSDictionary *releaseInfo;
    NSString *latestVersion;
    NSString *currentVersion;
    NSString *trackViewUrl;;
}

- (BOOL)update;
- (NSString *)getTrackViewUrl;
@end
