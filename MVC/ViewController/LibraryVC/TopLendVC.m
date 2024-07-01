//
//  TopLendVC.m
//  i西科
//
//  Created by weixvn_android on 15/4/30.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "TopLendVC.h"
#import "LibTableViewCell.h"
#import "MBProgressHUD.h"
#import "BookInfo.h"
#import "SearchBook.h"
#import "BookDetailViewController.h"
#import "SearchBookResult.h"
#import "Tools.h"
@interface TopLendVC ()
{
    LibTableViewCell *cell_Lib;
    MBProgressHUD *hud;
    
    BookInfo *bookInfo;
    SearchBook *searchBook;
    BookDetailViewController *bookDetailVC;
    SearchBookResult *searchResultVC;
    
    BOOL searchFlage;
    NSMutableArray *books;
}


@end

@implementation TopLendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLendTableView.delegate = self;
    self.topLendTableView.dataSource = self;
    
    searchBook = [[SearchBook alloc] init];
    bookInfo = [[BookInfo alloc] init];

    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 120, 35)];//allocate titleView
    UIColor *color =  self.navigationController.navigationBar.barTintColor;
    
    [titleView setBackgroundColor:color];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    searchBar.frame = CGRectMake(0, 5, kScreenW - 120, 30);
    searchBar.backgroundColor = color;
    searchBar.layer.cornerRadius = 5;
    searchBar.layer.masksToBounds = YES;
    [searchBar.layer setBorderWidth:8];
    [searchBar.layer setBorderColor:[UIColor whiteColor].CGColor];  //设置边框为白色
    
    searchBar.placeholder = @"书名/作者名";
    [titleView addSubview:searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_SearchBook_TopLend" object:nil];
    //搜索热门图书
    [searchBook Toplend];
    [self searchBookWait];
}

-(void)selfNotificationDO:(NSNotification *)aNotification{
    if (hud) {
        [hud hide:YES];
    }
    
    if ([aNotification.name isEqualToString:@"Library_SearchBook_TopLend"]){
        if ([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"热门搜索成功"]) {
            books = [aNotification.userInfo objectForKey:@"BookArray"];
            [self.topLendTableView reloadData];
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


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    searchResultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchBookResult"];
    searchResultVC.SearchStr = searchBar.text;
    [self.navigationController pushViewController:searchResultVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    cell_Lib.bookName.text = bookInfo.bookName;
    NSString *str = [NSString stringWithFormat:@"%d",(indexPath.row + 1)];
    cell_Lib.bookFirstName.text = str;
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
   
        NSString *header = @"热门借阅:";
        return header;
  
}

@end
