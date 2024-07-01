//
//  QuestionnaireViewController.h
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionnaireViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong) NSArray *questionList;
@end
