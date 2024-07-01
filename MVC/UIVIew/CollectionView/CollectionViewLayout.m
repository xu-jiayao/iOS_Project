//
//  collectionViewLayout.m
//  UICollectionView
//
//  Created by weixvn_android on 15/2/1.
//  Copyright (c) 2015年 weixvn_android. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout{
    NSUInteger courseCount;
    NSArray *showCourses;
    NSArray *noshowCourses;
    NSArray *courses;
    CourseTable * course;
    float courseWidth;
    float sideSectionWidth;
}


-(void)prepareLayout{
    [super prepareLayout];
    course = [[CourseTable alloc] init];
    courses = [[NSArray alloc] init];
    
    CGRect rt = [UIScreen mainScreen].bounds;
    if (rt.size.width >= 320) {
        courseWidth = (int)((rt.size.width / 320.0 ) * 42);
    }
    sideSectionWidth = rt.size.width - 7*courseWidth;
    
}
- (void)weekGetWeekCourese:(NSArray *)showCourse noshowCourse:(NSArray *)noshowcourses{
    showCourses = showCourse;
    noshowCourses = noshowcourses;
    courseCount = [showCourses count] + [noshowCourses count];
    
}
// 该方法的返回值决定UICollectionView所包含控件的大小
-(CGSize)collectionViewContentSize
{
    
    CGRect rt = [UIScreen mainScreen].bounds;
    if (rt.size.height == 480) {
        return  CGSizeMake(320, 548);
    }else if (rt.size.height == 568){
        return  CGSizeMake(320, 542);
    }else if (rt.size.width == 375){
    return  CGSizeMake(375, 627);
    }else{
        return  CGSizeMake(414, 702);
    }
   
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if(indexPath.row < (courseCount - [noshowCourses count])){
        course = [showCourses objectAtIndex:indexPath.row];
        
    int weekday = [course.course_weekday intValue];
        NSString *course_section = course.course_section;
        NSString *b = [course_section substringWithRange:NSMakeRange(1, 1)];
        int start,end;
        if([b isEqualToString:@"-"]){
        start = [[course_section substringWithRange:NSMakeRange(0, 1)] intValue];
        end = [[course_section substringFromIndex:[course_section length] - 1] intValue];

        }else{
            start = [[course_section substringWithRange:NSMakeRange(0, 2)] intValue];
            end = [[course_section substringFromIndex:[course_section length] - 2] intValue];
        }
        
        int n = end - start + 1;
        
  
    attributes.size = CGSizeMake(courseWidth - 2, courseWidth*n - 2);
        //attributes.size = CGSizeMake(40, 40);
    attributes.center = CGPointMake(sideSectionWidth +courseWidth/2 + courseWidth*(weekday - 1),n*courseWidth/2 + (start - 1)*courseWidth );
        
    }else if(indexPath.row < courseCount){
        course = [noshowCourses objectAtIndex:indexPath.row - [showCourses count]];
        
        int weekday = [course.course_weekday intValue];
        NSString *course_section = course.course_section;
        NSString *b = [course_section substringWithRange:NSMakeRange(1, 1)];
        int start,end;
        if([b isEqualToString:@"-"]){
            start = [[course_section substringWithRange:NSMakeRange(0, 1)] intValue];
            end = [[course_section substringFromIndex:[course_section length] - 1] intValue];
            
        }else{
            start = [[course_section substringWithRange:NSMakeRange(0, 2)] intValue];
            end = [[course_section substringFromIndex:[course_section length] - 2] intValue];
        }
        
        int n = end - start + 1;
        
//        attributes.size = CGSizeMake(40, 42*n - 2);
//        //attributes.size = CGSizeMake(40, 40);
//        attributes.center = CGPointMake(47 + 42*(weekday - 1),n*21 + (start - 1)*42 );
        attributes.size = CGSizeMake(courseWidth - 2, courseWidth*n - 2);
        //attributes.size = CGSizeMake(40, 40);
        attributes.center = CGPointMake(sideSectionWidth +courseWidth/2 + courseWidth*(weekday - 1),n*courseWidth/2 + (start - 1)*courseWidth );
    }else if(indexPath.row < courseCount +13){
        attributes.size = CGSizeMake(sideSectionWidth - 2, courseWidth - 2);
        attributes.center = CGPointMake(sideSectionWidth/2, courseWidth/2 + (indexPath.row - courseCount)*courseWidth);
    }
    
    return attributes;
    
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    // 将控制每个单元格大小和位置的UICollectionViewLayoutAttributes
    // 添加到NSArray中

  
    
    for (NSInteger i=0 ; i < courseCount + 13; i++) {
        NSIndexPath* indexPath = [NSIndexPath
                                  indexPathForItem:i inSection:0];
        [attributes addObject:
         [self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}


@end
