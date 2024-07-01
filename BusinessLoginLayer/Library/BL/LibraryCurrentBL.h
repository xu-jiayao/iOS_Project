//
//  LibraryCurrentBL.h
//  i西科
//
//  Created by MAC on 14-8-2.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryCurrentBL : NSObject

-(void)deleteData;

-(void)updateCurrentBorrowDate;

-(NSMutableArray *)findData;

@end
