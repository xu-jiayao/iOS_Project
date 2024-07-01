//
//  SearchBookResult.m
//  i西科
//
//  Created by weixvn_android on 15/4/30.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "SearchBookResult.h"
#import "LibTableViewCell.h"
#import "MBProgressHUD.h"
#import "BookInfo.h"
#import "SearchBook.h"
#import "BookDetailViewController.h"
#import "Tools.h"
#include "Config.h"
@interface SearchBookResult (){
    
    LibTableViewCell *cell_Lib;
    MBProgressHUD *hud;
    
    BookInfo *bookInfo;
    SearchBook *searchBook;
    BookDetailViewController *bookDetailVC;
     NSMutableArray *books;
}

@end

@implementation SearchBookResult

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBook = [[SearchBook alloc] init];
    bookInfo = [[BookInfo alloc] init];

    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"搜索结果"];
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_SearchBook_Search" object:nil];
    
    //搜索图书
    [self searchBookWait];
    [searchBook seacrhBy_bookName:self.SearchStr];
}

-(void)selfNotificationDO:(NSNotification *)aNotification
{
    if (hud) {
        [hud hide:YES];
    }
    //处理notification
    if ([aNotification.name isEqualToString:@"Library_SearchBook_Search"]){
        
        if([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"搜索成功"]){
            
            books = [aNotification.userInfo objectForKey:@"BookArray"];
            [self.searchResultTableView reloadData];
            if([books count] != 0){
                self.searchResultTableView.delegate = self;
                self.searchResultTableView.dataSource = self;
                //[self.searchResultTableView reloadData];
            }
        }else if ([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"书名搜索不到"]){
            [searchBook searchBy_Writer:self.SearchStr];
            ;
        }else if([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"作者搜索不到"]){
            books = [aNotification.userInfo objectForKey:@"BookArray"];
            if ([books count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未搜索到相关信息" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        }
    }
   
}


-(void)searchBookWait{
    if ([Tools checkNetWorking]) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Tools showHUD:@"施工中..." andView:self.view andHUD:hud];
        
    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (cell_Lib == nil) {
        cell_Lib= [tableView dequeueReusableCellWithIdentifier:@"libCell"];
    }
    
    //cell.backgroundColor = [UIColor clearColor];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LibTableViewCell" owner:nil options:nil];
    cell_Lib = [nib objectAtIndex:0];
    
    bookInfo = [books objectAtIndex:indexPath.row];
    
    if([[bookInfo.bookName substringWithRange:NSMakeRange(1,1)] isEqualToString:@"."]){
        cell_Lib.bookFirstName.text = [bookInfo.bookName substringToIndex:1];
        cell_Lib.bookName.text = [bookInfo.bookName  substringFromIndex:2];
    }else if ([[bookInfo.bookName substringWithRange:NSMakeRange(2,1)] isEqualToString:@"."]){
        cell_Lib.bookFirstName.text = [bookInfo.bookName substringToIndex:2];
        cell_Lib.bookName.text = [bookInfo.bookName substringFromIndex:3];
    }else{
        cell_Lib.bookFirstName.text = [bookInfo.bookName substringToIndex:3];
        cell_Lib.bookName.text = [bookInfo.bookName  substringFromIndex:4];
    }
    
    cell_Lib.detail.text = bookInfo.bookWriter;
    return cell_Lib;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([books count] != 0) {
        bookDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"bookDetail"];
        bookDetailVC.bookInfo = [books objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:bookDetailVC animated:YES];
        
    }


}

@end
