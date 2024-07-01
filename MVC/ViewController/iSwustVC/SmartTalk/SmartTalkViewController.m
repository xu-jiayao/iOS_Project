//
//  SmartTalkViewController.m
//  i西科
//
//  Created by 张为 on 15/5/9.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "SmartTalkViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ASIFormDataRequest.h"
#import "Tools.h"
#import "BaiduMobStat.h"
@interface SmartTalkViewController ()
{
    dispatch_queue_t queue ; // 创建

}

@end

@implementation SmartTalkViewController
@synthesize resultArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [Tools getNavigationItemTittleLabelWithText:@"小i机器人"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upToLost) name:@"uptolost" object:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",@"你好，我是萌萌哒的小i，快来试试‘调教’或‘常见问题’吧！",@"content", nil];
    
    resultArray = [NSMutableArray arrayWithObjects:dict, nil];
    
    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    

}


- (void) registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void) keyboardWasShown:(NSNotification *) notif

{
    CGRect keyBoardRect=[notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
    
}

- (void) keyboardWasHidden:(NSNotification *) notif

{
    
    [UIView animateWithDuration:[notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{ self.view.transform = CGAffineTransformIdentity; }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [self sendMessages:nil];
    
    return YES;
    
}

-(IBAction) backgroundTap:(id)sender{
    [self.myTextView resignFirstResponder];
}

-(void)sedMassage

{
    NSString * getCouseURL = [[NSString alloc]init];
    NSString *str1 =@"http://www.tuling123.com/openapi/api";
    
    getCouseURL = [str1 stringByAppendingFormat:@"?key=fa9da63cfdb420de2c87db0f84fa2e3f&info=%@",self.myTextView.text];
    getCouseURL = [getCouseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:getCouseURL]];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    
    [request setDelegate:self];
    [request startAsynchronous];//use 异步请求
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError* err = [request error];

    NSData *data = [request responseData];
    
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    
    NSString *answer = [info objectForKey:@"text"];
    
    answer = [answer stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    NSLog(@"%@",[request responseString]);
    
    NSDictionary *dicty = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"name",answer,@"content", nil];
    [resultArray addObject:dicty];
    
    [self.myTableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uptolost" object:nil];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    
    NSError *error = [request error];
    
}

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    //背影图片
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"SenderAppNodeBkg_HL":@"ReceiverTextNodeBkg" ofType:@"png"]];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    NSLog(@"%f,%f",size.width,size.height);
    
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf)
        returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView;
}

-(void)upToLost
{
    [self.myTableView setContentOffset:CGPointMake(0, self.myTableView.contentSize.height -self.myTableView.bounds.size.height) animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    NSString* cName = [NSString stringWithFormat:@"小i机器人"];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];

}

-(void)viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"退出小i机器人"];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
    [super viewDidDisappear:animated];
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


#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [resultArray objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [[dict objectForKey:@"content"] sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height+44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        for (UIView *cellView in cell.subviews){
            [cellView removeFromSuperview];
        }
    }
    
    NSDictionary *dict = [resultArray objectAtIndex:indexPath.row];
    
    //创建头像
    UIImageView *photo ;
    if ([[dict objectForKey:@"name"]isEqualToString:@"rhl"]) {
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(320-60, 10, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"photo1"];
        
        UIBezierPath* path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(photo.bounds.size.width/2, photo.bounds.size.height/2) radius:photo.bounds.size.width/2-5 startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer* shape1 = [CAShapeLayer layer];
        
        shape1.path = path1.CGPath;
        photo.layer.mask = shape1;
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            //   [cell addSubview:[self yuyinView:1 from:YES withIndexRow:indexPath.row withPosition:65]];
            
            
        }else{
            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:YES withPosition:65]];
        }
        
    }else{
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        [cell addSubview:photo];
        photo.image = [UIImage imageNamed:@"i西科"];
        UIBezierPath* path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(photo.bounds.size.width/2, photo.bounds.size.height/2) radius:photo.bounds.size.width/2-5 startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        CAShapeLayer* shape1 = [CAShapeLayer layer];
        
        shape1.path = path1.CGPath;
        photo.layer.mask = shape1;
        
        if ([[dict objectForKey:@"content"] isEqualToString:@"0"]) {
            //    [cell addSubview:[self yuyinView:1 from:NO withIndexRow:indexPath.row withPosition:65]];
        }else{
            [cell addSubview:[self bubbleView:[dict objectForKey:@"content"] from:NO withPosition:65]];
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}




- (IBAction)sendMessages:(id)sender {
    NSDictionary *dicty = [NSDictionary dictionaryWithObjectsAndKeys:@"rhl",@"name",self.myTextView.text,@"content", nil];
    [resultArray addObject:dicty];
    [self.myTableView reloadData];
    
     [self sedMassage];
    

    self.myTextView.text = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uptolost" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    [self.myTextView resignFirstResponder];
    
}

@end
