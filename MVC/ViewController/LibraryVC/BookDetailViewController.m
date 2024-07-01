//
//  BookDetailViewController.m
//  i西科
//
//  Created by weixvn_android on 15/4/26.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "BookDetailViewController.h"
#import "bookPlaceCell.h"
#import "MBProgressHUD.h"
#import "SearchBook.h"
#import "Tools.h"
@interface BookDetailViewController (){
    UITableView *bookPlaceTableview;
    MBProgressHUD *hud;
    SearchBook *searchBook;
    
}

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchBook = [[SearchBook alloc]  init];

    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"图书详情"];
    self.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selfNotificationDO:) name:@"Library_SearchBook_Detail" object:nil];
    [searchBook searchPlace:self.bookInfo];
    [self searchBookWait];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.bookMassege.layer.cornerRadius = 5;
    
}
-(void)selfNotificationDO:(NSNotification *)aNotification{
    if (hud) {
        [hud hide:YES];
    }
    if ([aNotification.name isEqualToString:@"Library_SearchBook_Detail"]){
        if([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"搜索图书详情成功"]){
            self.bookInfo = [aNotification.userInfo objectForKey:@"BookDetail"];
            [self viewWillAppear:NO];
            //[self tableView:bookPlaceTableview numberOfRowsInSection:1];
            CGRect rect = CGRectMake(0, 350, kScreenW, [self.bookInfo.bookPlace count]*44 + 20);
            bookPlaceTableview = [[UITableView alloc] initWithFrame:rect];
            bookPlaceTableview.delegate =self;
            bookPlaceTableview.dataSource = self;
            bookPlaceTableview.scrollEnabled = NO;
         
            [self.scrollView addSubview:bookPlaceTableview];
            
            self.bookIndex.text = self.bookInfo.bookIndex;
            if (self.bookInfo.bookName.length >= 4){
                NSString * ss =[self.bookInfo.bookName substringWithRange:NSMakeRange(1,1)];
                NSLog(@"---%@\n",[self.bookInfo.bookName  substringToIndex:2]);
                if([[self.bookInfo.bookName substringWithRange:NSMakeRange(1,1)] isEqualToString:@"."]){
                    self.bookName.text = [self.bookInfo.bookName  substringFromIndex:2];
                } else if ([[self.bookInfo.bookName substringWithRange:NSMakeRange(2,1)] isEqualToString:@"."]){
                    self.bookName.text = [self.bookInfo.bookName substringFromIndex:3];
                }else if ([[self.bookInfo.bookName substringWithRange:NSMakeRange(3,1)] isEqualToString:@"."]) {
                    self.bookName.text = [self.bookInfo.bookName  substringFromIndex:4];
                }else{
                    self.bookName.text = self.bookInfo.bookName;
                }
                
            }else if (self.bookInfo.bookName.length >= 3){
                if([[self.bookInfo.bookName substringWithRange:NSMakeRange(1,1)] isEqualToString:@"."]){
                    self.bookName.text = [self.bookInfo.bookName  substringFromIndex:2];
                } else if ([[self.bookInfo.bookName substringWithRange:NSMakeRange(2,1)] isEqualToString:@"."]){
                    self.bookName.text = [self.bookInfo.bookName substringFromIndex:3];
                }else{
                    self.bookName.text = self.bookInfo.bookName;
                }
            }else if (self.bookInfo.bookName.length >= 2){
                if([[self.bookInfo.bookName substringWithRange:NSMakeRange(1,1)] isEqualToString:@"."]){
                    self.bookName.text = [self.bookInfo.bookName  substringFromIndex:2];
                }else{
                    self.bookName.text = self.bookInfo.bookName;
                }
            }else{
                self.bookName.text = self.bookInfo.bookName;
            }
            self.bookMassege.text = @"摘要获取中....";
            self.bookWriter.text = self.bookInfo.bookWriter;
            
            self.scrollView.contentSize = CGSizeMake(kScreenW,420 + rect.size.height);
        }else if ([[aNotification.userInfo objectForKey:@"Message"] isEqualToString:@"获取图书摘要成功"]){
            self.bookMassege.text = [aNotification.userInfo objectForKey:@"summury"];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.bookInfo.bookPlace count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    UINib *nib = [UINib nibWithNibName:@"BookPlaceCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellId];
    bookPlaceCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.bookPlace.text = [[self.bookInfo.bookPlace objectAtIndex:indexPath.row] objectForKey:@"bookPlace"];
    cell.bookState.text = [[self.bookInfo.bookPlace objectAtIndex:indexPath.row] objectForKey:@"bookState"];
    NSLog(@"%d\n",indexPath.row);
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    NSString *header = @"馆藏地:";
    return header;
    
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

@end
