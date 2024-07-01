//
//  CollectionViewCell.h
//  UICollectionView
//
//  Created by weixvn_android on 15/3/8.
//  Copyright (c) 2015年 weixvn_android. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray *courseArray;
@end
