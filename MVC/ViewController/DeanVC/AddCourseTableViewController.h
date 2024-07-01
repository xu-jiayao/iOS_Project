//
//  AddCourseTableViewController.h
//  i西科
//
//  Created by MAC on 15/1/18.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCourseTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *txt_courseName;
@property (strong, nonatomic) IBOutlet UITextField *txt_coursePlace;
@property (strong, nonatomic) IBOutlet UITextField *txt_courseTeacher;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView_section;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView_week;

@end
