//
//  DeanPersonalBL.m
//  i西科
//
//  Created by MAC on 15/1/19.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "DeanPersonalBL.h"

@implementation DeanPersonalBL

-(DeanPersonal *)findPersoanlData{
    DeanPersonalDAO *personalDAO = [DeanPersonalDAO shareManager];
    DeanPersonal *persoanlItem = [[personalDAO findAll]objectAtIndex:0];
    return persoanlItem;
}

-(void)deleteData{
    DeanPersonalDAO *personalDAO = [DeanPersonalDAO shareManager];
    [personalDAO remove];
}

@end
