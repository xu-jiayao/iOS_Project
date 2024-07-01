//
//  FQAViewController.m
//  i西科
//
//  Created by weixvn_ios on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "FQAViewController.h"
#import "QuestionTableViewCell.h"
#import "AnswerTableViewCell.h"

@interface FQAViewController ()
{
    NSArray *questionArray;
    NSArray *answerArray;
}
@end


@implementation FQAViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    
    questionArray = [[NSArray alloc]initWithObjects:@"提示：请求超时,请检查网络是否可用？",
                    @"请确保无线网络数据或移动蜂窝数据处于打开状态。",
                    @"提示：数据请求失败？",
                    @"由于校园官方系统出现暂时性无法响应，请重试，若多次重试仍出现此结果，请查看相应教务系统是否可用。",
                    @"提示：教务处很傲娇很繁忙,进不去啊？",
                    @"此状况是由于教务处服务器过于繁忙，请稍后再试。",
                    @"有网络，校园官方系统也能访问，但就是不能登录或刷新？",
                    @"此情况很可能是由于当前网络状况不佳导致的数据传输中断，请在确保良好网络状况下登录、刷新。",
                    nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"QuestionTableViewCell" owner:nil options:nil];
       //  = [tableView dequeueReusableCellWithIdentifier:@"QCell"];
        QuestionTableViewCell *cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.questionStr.text = [questionArray objectAtIndex:indexPath.row];
        return cell;
    }else{
        
        NSArray *ANnib = [[NSBundle mainBundle] loadNibNamed:@"AnswerTableViewCell" owner:nil options:nil];

        AnswerTableViewCell *cell = [ANnib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.answerStr.text = [questionArray objectAtIndex:indexPath.row];
        return cell;
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
    

@end
