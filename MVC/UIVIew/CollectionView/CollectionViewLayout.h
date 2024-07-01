//
//  collectionViewLayout.h
//  UICollectionView
//
//  Created by weixvn_android on 15/2/1.
//  Copyright (c) 2015年 weixvn_android. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseTableBL.h"
#import "CourseTable.h"
@interface CollectionViewLayout : UICollectionViewFlowLayout
- (void)weekGetWeekCourese:(NSArray *)showCourse noshowCourse:(NSArray *)noshowcourses;
@end
