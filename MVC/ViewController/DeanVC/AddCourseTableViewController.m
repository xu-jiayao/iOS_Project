//
//  AddCourseTableViewController.m
//  i西科
//
//  Created by MAC on 15/1/18.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "AddCourseTableViewController.h"
#import "CourseTable.h"
#import "CourseTableBL.h"
#import "Sign.h"
#import "Tools.h"
#import "MBProgressHUD.h"
#import "ISwustServerInterface.h"
#import "ISwustLoginHttpRequest.h"
@interface AddCourseTableViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *_dayCount;
    NSArray *_preSection;
    NSArray *_laterSection;
    NSArray *_preWeek;
    NSArray *_laterWeek;
    MBProgressHUD *hud;
    
    CourseTableBL *courseBL;
    
    ISwustServerInterface *_iSwustServer;
}
@end

@implementation AddCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"ISwust_AddCourse_Notice" object:nil];
    
    [self.txt_courseName setDelegate:self];
    [self.txt_coursePlace setDelegate:self];
    [self.txt_courseTeacher setDelegate:self];
    
    [self initData];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addCoursefinished)];
    
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)initData{
    NSMutableArray *weekCount = [NSMutableArray arrayWithCapacity:25];
    for (int i = 1; i<=25; i++) {
        [weekCount addObject:[NSString stringWithFormat:@"第%d周",i]];
    }
    _preWeek = weekCount;
    
    NSMutableArray *weekCount2 = [NSMutableArray arrayWithCapacity:25];
    for (int i = 1; i<=25; i++) {
        [weekCount2 addObject:[NSString stringWithFormat:@"到%d周",i]];
    }
    _laterWeek = weekCount2;
    
    _dayCount = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    _preSection = [NSArray arrayWithObjects:@"第1节",@"第2节",@"第3节",@"第4节",@"第5节",@"第6节",@"第7节",@"第8节",@"第9节",@"第10节",@"第11节",@"第12节",@"第13节", nil];
    _laterSection = [NSArray arrayWithObjects:@"到1节",@"到2节",@"到3节",@"到4节",@"到5节",@"到6节",@"到7节",@"到8节",@"到9节",@"到10节",@"到11节",@"到12节",@"到13节", nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selfNotificationDO:(NSNotification *)aNotification
{
    if (hud) {
        [hud hide:YES];
    }
    
    //处理notification
    if ([aNotification.name isEqualToString:@"ISwust_AddCourse_Notice"] && [[aNotification.userInfo objectForKey:@"Message"]isEqualToString:@"成功"]) {
        [self operationAfterRequestSuccess];
    }else{
        [Tools ToastNotification:[aNotification.userInfo objectForKey:@"Message"]  andView:self.view andLoading:NO andIsBottom:NO];
    }
}

-(NSString *)changeToWeekNum:(NSString *)weekdayStr{
    if ([weekdayStr isEqualToString:@"周一"]) {
        return @"1";
    }else if ([weekdayStr isEqualToString:@"周二"]){
        return @"2";
    }else if ([weekdayStr isEqualToString:@"周三"]){
        return @"3";
    }else if ([weekdayStr isEqualToString:@"周四"]){
        return @"4";
    }else if ([weekdayStr isEqualToString:@"周五"]){
        return @"5";
    }else if ([weekdayStr isEqualToString:@"周六"]){
        return @"6";
    }else if ([weekdayStr isEqualToString:@"周日"]){
        return @"7";
    }
    return @"0";
}

-(void)addCoursefinished{
    
    if ([Tools checkNetWorking]) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
        CourseTable *courseItem = [CourseTable new];
        courseItem.course_name = self.txt_courseName.text;
        courseItem.course_place = self.txt_coursePlace.text;
        courseItem.course_teacher = self.txt_courseTeacher.text;
        
        
        NSInteger dayRow =[self.pickerView_section selectedRowInComponent:0];
        courseItem.course_weekday = [self changeToWeekNum:[_dayCount objectAtIndex:dayRow]];
        
        
        NSInteger preSectionRow =[self.pickerView_section selectedRowInComponent:1];
        NSInteger laterRow =[self.pickerView_section selectedRowInComponent:2];
        courseItem.course_section = [NSString stringWithFormat:@"%d-%d",preSectionRow+1,laterRow+1];
        
        
        NSInteger preWeekRow =[self.pickerView_week selectedRowInComponent:0];
        NSInteger laterWeekRow =[self.pickerView_week selectedRowInComponent:1];
        
        NSString *preWeekRowStr;
        if (preWeekRow+1 < 10) {
            preWeekRowStr = [NSString stringWithFormat:@"%d%d",0,preWeekRow+1];
        }else{
            preWeekRowStr = [NSString stringWithFormat:@"%d",preWeekRow+1];
        }
        NSString *laterWeekRowStr;
        if (laterWeekRow+1 < 10) {
            laterWeekRowStr = [NSString stringWithFormat:@"%d%d",0,laterWeekRow+1];
        }else{
            laterWeekRowStr = [NSString stringWithFormat:@"%d",laterWeekRow+1];
        }
        courseItem.course_week = [NSString stringWithFormat:@"%@-%@",preWeekRowStr,laterWeekRowStr];
        
        courseItem.course_action = @"0";
        
        if (preSectionRow > laterRow) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请检查课程节数" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            if (hud) {
                [hud hide:YES];
            }
        }else if (preWeekRow > laterWeekRow){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请检查课程周数" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            if (hud) {
                [hud hide:YES];
            }
        }else{
            if (courseBL == nil) {
                courseBL = [CourseTableBL new];
            }
            NSString *term = [courseBL findCurrentTerm];
            
            courseItem.course_academic_semester = term;
            
            NSDictionary *finalDict = [NSDictionary dictionaryWithObjects:@[courseItem.course_academic_semester,courseItem.course_name,courseItem.course_section,courseItem.course_week,courseItem.course_place,courseItem.course_teacher,courseItem.course_weekday,[NSNumber numberWithInt:[courseItem.course_action intValue] ]] forKeys:@[@"course_academic_semester",@"course_name",@"course_section",@"course_week",@"course_place",@"course_teacher",@"course_weekday",@"course_action"]];
            
            
            NSArray *array = [NSArray arrayWithObject:finalDict];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[array,courseItem.course_academic_semester] forKeys:@[@"course_list",@"course_academic_semester"]];
            
//            ////
//            //登录服务
//            
//            ISwustLoginHttpRequest *login = [ISwustLoginHttpRequest new];
//            [login justiSwustLoginHttpRequest];
//            
            
            if (_iSwustServer == nil) {
                _iSwustServer = [ISwustServerInterface new];
            }
            [_iSwustServer ISwust_AddCourse:dict];
        }

    }else{
         [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
    
}

-(void)operationAfterRequestSuccess{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"term" forKey:@"course_academic_semester"];
    
    if (_iSwustServer == nil) {
        _iSwustServer = [ISwustServerInterface new];
    }
    [_iSwustServer ISwust_downloadCourse:dict];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1) {
        return 3;
    }else{
        return 2;
    }
    
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            switch (component) {
                case 0:
                    return [_dayCount count];
                    break;
                case 1:
                    return [_preSection count];
                    break;
                case 2:
                    return [_laterSection count];
                    break;
            }
            break;
        case 2:
            switch (component) {
                case 0:
                    return [_preWeek count];
                    break;
                case 1:
                    return [_laterWeek count];
                    break;
            }
            break;
    }
    return 0;
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 1:
            switch (component) {
                case 0:
                    return [_dayCount objectAtIndex:row];
                    break;
                case 1:
                    return [_preSection objectAtIndex:row];
                    break;
                case 2:
                    return [_laterSection objectAtIndex:row];
                    break;
            }
            break;
        case 2:
            switch (component) {
                case 0:
                    return [_preWeek objectAtIndex:row];
                    break;
                case 1:
                    return [_laterWeek objectAtIndex:row];
                    break;
            }
            break;
    }
    return @"";
}
-(CGFloat)pickerView: (UIPickerView *)pickerView widthForComponent:(NSInteger) component{
    if (pickerView.tag == 1) {
        if (component == 1 || component == 2) {
            return 90;
        }else{
            return 60;
        }
    }else{
        return 100;
    }

}




//点击非textField和键盘的屏幕后隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txt_courseName resignFirstResponder];
    [self.txt_coursePlace resignFirstResponder];
    [self.txt_courseTeacher resignFirstResponder];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.txt_courseName resignFirstResponder];
    [self.txt_coursePlace resignFirstResponder];
    [self.txt_courseTeacher resignFirstResponder];
    return YES;
}
@end
