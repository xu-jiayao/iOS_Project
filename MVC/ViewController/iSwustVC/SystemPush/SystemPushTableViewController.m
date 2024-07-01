//
//  SystemPushTableViewController.m
//  i西科
//
//  Created by Fox on 14-10-2.
//  Copyright (c) 2014年 weixvn. All rights reserved.
//

#import "SystemPushTableViewController.h"
#import "BDNoticeBL.h"
#import "Tools.h"
//#import "BaiduMobStat.h"
@interface SystemPushTableViewController ()

{
    BDNoticeBL *newsBL;
    NSArray *allData;
}
@end

@implementation SystemPushTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)viewDidAppear:(BOOL)animated{
// //   NSString* cName = [NSString stringWithFormat:@"百度推送页面"];
////    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
//   
//}

- (void)viewDidDisappear: (BOOL)animated {
    
    [super viewDidDisappear:YES];
    //把所有消息设置为已读
     [newsBL setMessageAllisReaded];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ISwust_PushMessage_Notice" object:nil userInfo:nil];
    

 //   NSString* cName = [NSString stringWithFormat:@"退出百度推送页面"];
//    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    newsBL = [BDNoticeBL new];
    allData = [newsBL findData];
    self.tabBarController.tabBar.hidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: YES];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"系统消息"];

    //self.hidesBottomBarWhenPushed = YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [allData count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [[allData objectAtIndex:(allData.count-indexPath.section-1)]objectForKey:@"alert"];
    
    NSString *detailStr = [NSString stringWithFormat:@"%@",[[allData objectAtIndex:(allData.count-indexPath.section-1)]objectForKey:@"date"]];
    
    cell.detailTextLabel.text = detailStr;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bdpushimg"]];   //cell的背景图
    cell.textLabel.backgroundColor = [UIColor clearColor];
}

@end
