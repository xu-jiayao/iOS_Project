//
//  Update.m
//  i西科
//
//  Created by weixvn_ios on 15/1/23.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "Update.h"
#import <Tools.h>
#import <AboutTableViewController.h>

@implementation Update

- (BOOL)update{
    [self getVersion];
    
    if ([currentVersion isEqualToString:latestVersion]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)getVersion{
    //获取当前版本信息（当前运行版本信息可以通过info.plist文件中的bundle version中获取）
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    NSLog(@"currentVersion--%@",currentVersion);
    
    //newversion
    NSURL *url = [[NSURL alloc] initWithString:@"http://itunes.apple.com/lookup?id=935319396"];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    //将json转化成字典
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    //将字典中的信息存在数组中
    NSArray *infoArray = [jsonDic objectForKey:@"results"];

    //再次转化成字典
    releaseInfo = [infoArray objectAtIndex:0];
    //获取值
    latestVersion = [releaseInfo objectForKey:@"version"];
    NSLog(@"latestVersion--%@",latestVersion);
    trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];

}
- (NSString *)getTrackViewUrl{
    return trackViewUrl;
}

@end
