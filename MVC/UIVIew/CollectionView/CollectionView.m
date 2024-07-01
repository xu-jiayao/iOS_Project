//
//  CollectionView.m
//  i西科
//
//  Created by weixvn_android on 15/4/3.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "CollectionView.h"

@implementation CollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    float courseWidth;
    float sideSectionWidth;
    CGRect rt = [UIScreen mainScreen].bounds;
    if (rt.size.width >= 320) {
        courseWidth = (int)((rt.size.width / 320.0 ) * 42);
    }
    sideSectionWidth = rt.size.width - 7*courseWidth;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint point[] ={
        
        CGPointMake(0,courseWidth),CGPointMake(rt.size.width, courseWidth ),
        CGPointMake(0,courseWidth*2  ),CGPointMake(rt.size.width, courseWidth*2 ),
        CGPointMake(0,courseWidth*3 ),CGPointMake(rt.size.width, courseWidth*3 ),
        CGPointMake(0,courseWidth*4 ),CGPointMake(rt.size.width, courseWidth*4 ),
        CGPointMake(0,courseWidth*5 ),CGPointMake(rt.size.width, courseWidth*5 ),
        CGPointMake(0,courseWidth*6 ),CGPointMake(rt.size.width, courseWidth*6 ),
        CGPointMake(0,courseWidth*7 ),CGPointMake(rt.size.width, courseWidth*7 ),
        CGPointMake(0,courseWidth*8 ),CGPointMake(rt.size.width, courseWidth*8 ),
        CGPointMake(0,courseWidth*9 ),CGPointMake(rt.size.width, courseWidth*9 ),
        CGPointMake(0,courseWidth*10 ),CGPointMake(rt.size.width, courseWidth*10 ),
        CGPointMake(0,courseWidth*11 ),CGPointMake(rt.size.width, courseWidth*11),
        CGPointMake(0,courseWidth*12 ),CGPointMake(rt.size.width, courseWidth*12 ),
        CGPointMake(0,courseWidth*13 ),CGPointMake(rt.size.width, courseWidth*13 ),
        CGPointMake(sideSectionWidth,0 ),CGPointMake(sideSectionWidth, courseWidth*13 ),
        
    };
    CGContextSetLineWidth(ctx, 0.05);
    CGContextStrokeLineSegments(ctx, point, 28);
    
    //绘制zuoce边框
    CGPoint point2[] ={
        
        CGPointMake(0,courseWidth),CGPointMake(rt.size.width, courseWidth ),
        CGPointMake(0,courseWidth*2  ),CGPointMake(rt.size.width, courseWidth*2 ),
        CGPointMake(0,courseWidth*3 ),CGPointMake(rt.size.width, courseWidth*3 ),
        CGPointMake(0,courseWidth*4 ),CGPointMake(rt.size.width, courseWidth*4 ),
        CGPointMake(0,courseWidth*5 ),CGPointMake(rt.size.width, courseWidth*5 ),
        CGPointMake(0,courseWidth*6 ),CGPointMake(rt.size.width, courseWidth*6 ),
        CGPointMake(0,courseWidth*7 ),CGPointMake(rt.size.width, courseWidth*7 ),
        CGPointMake(0,courseWidth*8 ),CGPointMake(rt.size.width, courseWidth*8 ),
        CGPointMake(0,courseWidth*9 ),CGPointMake(rt.size.width, courseWidth*9 ),
        CGPointMake(0,courseWidth*10 ),CGPointMake(rt.size.width, courseWidth*10 ),
        CGPointMake(0,courseWidth*11 ),CGPointMake(rt.size.width, courseWidth*11),
        CGPointMake(0,courseWidth*12 ),CGPointMake(rt.size.width, courseWidth*12 ),
        CGPointMake(0,courseWidth*13 ),CGPointMake(rt.size.width, courseWidth*13 ),
        CGPointMake(sideSectionWidth,0 ),CGPointMake(sideSectionWidth, courseWidth*13 ),
        
    };
    CGContextSetLineWidth(ctx, 0.05);
    CGContextStrokeLineSegments(ctx, point2, 28);
    
    
    
}

@end
