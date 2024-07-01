//
//  EvalauteTableViewController.m
//  i西科
//
//  Created by weixvn_android on 15/1/15.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "EvalauteTableViewController.h"
#import "Tools.h"


@interface EvalauteTableViewController ()
{
    ScoreTableViewCell *cell_score;
}
@end

@implementation EvalauteTableViewController
@synthesize evaluateArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可评教课程";
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clearBG"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    evaluateBL = [EvaluateOnlineBL new];
    evaluateArray = [evaluateBL findData];
}

-(void)refresh{
    
//    [self performSelectorInBackground:@selector(backgroundOperation) withObject:nil];
//    evaluateBL = [EvaluateOnlineBL new];
//    [evaluateBL removeData];
//    int reNumber = [evaluateBL getEvaluateList];
//    
//    
//    if (reNumber != 0) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    
//     
//    }else{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        evaluateArray = [evaluateBL findData];
//        [self.tableView reloadData];
//    }
    NSLog(@"刷新");
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)netNoWorkHUD{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    HUD.labelText = @"当前网络不可用哦!";
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    HUD.yOffset = -200.0f;
    HUD.xOffset = 0.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return evaluateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell_score == nil) {
        cell_score = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    }

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell" owner:nil options:nil];
    
    cell_score = [nib objectAtIndex:0];
    EvaluateOnline *item = [evaluateArray objectAtIndex:[indexPath row]];
    
    cell_score.tittleString.text = item.courseName;
    cell_score.detailString.text = [[NSString alloc] initWithFormat:@"学分: %@",item.credit];
    
    cell_score.score = @"请先完成课程教学质量评价";
    return cell_score;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([Tools NetWorkIsOK]) {
        
        EvaluateWebViewController *evaluateWebVC = [self.storyboard instantiateViewControllerWithIdentifier:@"evaluateWebVC"];
        EvaluateOnline *item = [evaluateArray objectAtIndex:[indexPath row]];
        
        evaluateWebVC.indexURL = item.evaluateURL;
        [self.navigationController pushViewController:evaluateWebVC animated:YES];
        
    }else{
        [self netNoWorkHUD];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
