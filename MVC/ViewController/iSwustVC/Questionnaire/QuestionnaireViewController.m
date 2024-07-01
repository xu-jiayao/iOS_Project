//
//  QuestionnaireViewController.m
//  i西科
//
//  Created by zw on 15/4/16.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "QuestionnaireTableViewCell.h"
#import "Questionnaire.h"
#import "QuestionWebViewController.h"
#import "Tools.h"
#import "BaiduMobStat.h"

@interface QuestionnaireViewController ()
{
}
@end

@implementation QuestionnaireViewController
@synthesize questionList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"问卷调查"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [questionList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // QuestionnaireTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuestionnaireTableViewCell" owner:nil options:nil];
    
     QuestionnaireTableViewCell *cell = [nib objectAtIndex:0];
    
    NSDictionary *questionItem = questionList[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = [questionItem objectForKey:@"survey_title"];
    NSArray *array = [[questionItem objectForKey:@"start_time"] componentsSeparatedByString:@" "];
    cell.startTimelabel.text = array[0];
    NSArray *array2 = [[questionItem objectForKey:@"end_time"] componentsSeparatedByString:@" "];
    cell.endTimeLabel.text = array2[0];
    cell.survey_status = [questionItem objectForKey:@"survey_status"];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
    NSString * judge = [questionList[indexPath.row] objectForKey:@"survey_status"];
    int judge1 = judge.intValue;
    if ( judge1 == 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您已完成此问卷！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else if (judge1 == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此问卷已关闭！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else if (judge1 == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此问卷已删除！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        QuestionWebViewController *questionWebVC = [self.storyboard instantiateViewControllerWithIdentifier:@"questionWebVC"];
        
        questionWebVC.questionItem = questionList[indexPath.row];
        
        [self.navigationController pushViewController:questionWebVC  animated:YES];
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"问卷调查"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"离开问卷调查"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}
@end
