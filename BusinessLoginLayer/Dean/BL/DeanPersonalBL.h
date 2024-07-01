//
//  DeanPersonalBL.h
//  i西科
//
//  Created by MAC on 15/1/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeanPersonalDAO.h"
#import "DeanPersonal.h"
@interface DeanPersonalBL : NSObject

-(DeanPersonal *)findPersoanlData;
-(void)deleteData;
@end
