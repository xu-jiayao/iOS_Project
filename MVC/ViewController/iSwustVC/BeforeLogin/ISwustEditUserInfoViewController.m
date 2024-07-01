//
//  ISwustEditUserInfoViewController.m
//  i西科
//
//  Created by Mac_240 on 15/1/24.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "ISwustEditUserInfoViewController.h"
#import "ISwustServerInterface.h"
#import "ISwustLoginHttpRequest.h"
#import "ISwustUserInfo.h"
#import "IswustUserInfoBL.h"
#import "UserInfoUnableCell.h"
#import "UserInfoEnableCell.h"
#import "Tools.h"
#import "config.h"
@interface ISwustEditUserInfoViewController ()<UIActionSheetDelegate>{
    BOOL isFullScreen;
    NSData *imageData;
    ISwustServerInterface *_iSwustServer;
    ISwustUserInfo *iswustUserInfo;
    IswustUserInfoBL *dao;
    NSArray *arr_unableCellKey;
    NSMutableArray *arr_unableCellValue;
    NSArray *arr_enableCellKey;
    NSMutableArray *arr_enableCellValue;
    UIImage *userPhoto;
    BOOL userInfoChanged;
    BOOL rightButtonTouched;
    BOOL formIllegal;
    BOOL isExistUserInfo;

}


@end

@implementation ISwustEditUserInfoViewController

int celltag = 4;

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfoChanged = NO;
    rightButtonTouched = NO;
    formIllegal = NO;
    celltag = 4;
    self.tableView.contentSize = CGSizeMake(kScreenW, kScreenH  + 500);
    if([[Config Instance]getIsTeacher] == YES){
        arr_unableCellKey = [[NSArray alloc]initWithObjects:@"姓名：",@"性别：",@"学院：",@"职称：",@"学历：", nil];
    }
    else{
    arr_unableCellKey = [[NSArray alloc]initWithObjects:@"姓名：",@"性别：",@"学院：",@"专业：",@"班级：", nil];
    }
    arr_enableCellKey = [[NSArray alloc]initWithObjects:@"生日：",@"QQ：",@"电话：",@"邮箱：",@"住址：", nil];
    
    [self getIswustUserInfo];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(editCompleteUserInfo)];
    
    [self.navigationItem setRightBarButtonItem:item];
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnlast)];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnLeft)];
     [self.navigationItem setLeftBarButtonItem:leftitem];
    
    
    [self.user_Signature.layer setCornerRadius:6];
    [self.user_Signature.layer setBorderWidth:0.5];
    [self.user_Signature.layer setBorderColor:[UIColor clearColor].CGColor];
    self.user_NikName.layer.borderColor = [UIColor clearColor].CGColor;
    self.user_NikName.layer.cornerRadius = 6;
    self.user_Signature.layer.masksToBounds = YES;
    self.user_NikName.delegate = self;
    self.user_Signature.delegate = self;
    
    //设置头像为圆形
    self.user_Image.layer.cornerRadius = self.user_Image.frame.size.width/2;
    self.user_Image.clipsToBounds = YES;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo) name:@"ISwust_SynchUserInfo_Notice" object:nil];
    
   


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getIswustUserInfo{
    
    iswustUserInfo = [ISwustUserInfo new];
    dao = [IswustUserInfoBL new];
    iswustUserInfo = [dao findData];
    
    if (iswustUserInfo == nil) {
        isExistUserInfo = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"个人信息获取失败，是否重新获取?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }else{
        isExistUserInfo = YES;
        [self setUserInfo];
       
    }
   
    
}
-(void)setUserInfo{
    NSString *userSex;
    if([iswustUserInfo.user_sex isEqualToString:@"0"]){
        userSex = @"女";
    }
    else{
        userSex = @"男";
    }
    
    
    arr_unableCellValue = [NSMutableArray new];
    NSArray *array;
    if([[Config Instance]getIsTeacher] == YES){
        array = @[iswustUserInfo.user_name,userSex,iswustUserInfo.user_college,iswustUserInfo.user_capacity,iswustUserInfo.user_education];
    }
    else{
        array = @[iswustUserInfo.user_name,userSex,iswustUserInfo.user_college,iswustUserInfo.user_professional,iswustUserInfo.user_class];
    }
    
    [arr_unableCellValue addObjectsFromArray:array];
    
    
    arr_enableCellValue = [NSMutableArray new];
    NSArray *array2 = @[[iswustUserInfo.user_birthday substringToIndex:10],iswustUserInfo.user_qq,iswustUserInfo.user_tel,iswustUserInfo.user_email,iswustUserInfo.user_hometown];
    [arr_enableCellValue addObjectsFromArray:array2];
    
    
    self.user_NikName.text = iswustUserInfo.nick_name;
    self.user_Signature.text = iswustUserInfo.user_signature;
    
    // 从沙盒获取图片
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",iswustUserInfo.user_number];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        imageData = [NSData dataWithContentsOfFile:fullPath];
        self.user_Image.image = [UIImage imageWithData:imageData];
    }
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}
-(void)readyForSycnUserInfo{
    //个人信息同步
    iswustUserInfo = [ISwustUserInfo new];
    dao = [IswustUserInfoBL new];
    iswustUserInfo = [dao findData];
    
    iswustUserInfo.nick_name = self.user_NikName.text ;
    iswustUserInfo.user_signature = self.user_Signature.text;
    
    [self.tableView indexPathsForSelectedRows];
    
    //获取cell中修改后的值
    UserInfoEnableCell *cell = nil;
    UITextField *valueLabel = nil;
    
    cell = (UserInfoEnableCell *)[self.tableView viewWithTag:4];
    valueLabel = (UITextField *)[cell viewWithTag:2];
    if(![valueLabel.text isEqualToString: [arr_unableCellValue objectAtIndex:0]])
        iswustUserInfo.user_birthday = valueLabel.text;
    
    cell = (UserInfoEnableCell *)[self.tableView viewWithTag:5];
    valueLabel = (UITextField *)[cell viewWithTag:2];
    iswustUserInfo.user_qq = valueLabel.text;
    
    cell = (UserInfoEnableCell *)[self.tableView viewWithTag:6];
    valueLabel = (UITextField *)[cell viewWithTag:2];
    iswustUserInfo.user_tel = valueLabel.text;
    
    cell = (UserInfoEnableCell *)[self.tableView viewWithTag:7];
    valueLabel = (UITextField *)[cell viewWithTag:2];
    iswustUserInfo.user_email = valueLabel.text;
    
    cell = (UserInfoEnableCell *)[self.tableView viewWithTag:8];
    valueLabel = (UITextField *)[cell viewWithTag:2];
    iswustUserInfo.user_hometown = valueLabel.text;
    
    
    
    [_iSwustServer ISwust_SynchUserInfo:iswustUserInfo];
}
-(void)editCompleteUserInfo{
    //   NSArray *arr = [self.tableView indexPathsForSelectedRows];
    
    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    if ([Tools checkNetWorking]) {
        [self checkUserInfoChange];
        if (formIllegal == NO && userInfoChanged == YES) {
            if([self.user_Image.image.description length] != 0 && [self.user_NikName.text length] != 0 && ![Tools spaceString:self.user_NikName.text]){
                //登录
                _iSwustServer = [ISwustServerInterface new];
                //        ISwustLoginHttpRequest *request = [ISwustLoginHttpRequest new];
                //        [request justiSwustLoginHttpRequest];
                //上传头像
                if(imageData){
                    int n = (int)[imageData length]/1000;
                    NSString *imageSize =[NSString stringWithFormat:@"%d",n];
                    [_iSwustServer ISwust_UpdatePicture:imageData file_Size:imageSize];
                }
                
                //个人信息同步
                [self readyForSycnUserInfo];
                userInfoChanged = NO;
                rightButtonTouched = YES;
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
                //[self.navigationController popToRootViewControllerAnimated:YES];

                
               }else{
                
                UIAlertView *alertView12 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"头像或昵称为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView12 show];
                
            }
        }else if(formIllegal == YES){
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"填写的信息格式不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView2 show];
        }
    }else{
        [Tools ToastNotification:@"网络异常"  andView:self.view andLoading:NO andIsBottom:NO];
        
    }
    
    
    celltag = 4;//设置cell初始化值
    
}

- (IBAction)choseUserImage:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"更改头像" delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}

//检查是否编辑过个人信息
-(void)checkUserInfoChange{
    //初始化
    userInfoChanged = NO;
    formIllegal = NO;
    //检查
    UserInfoEnableCell *cell = [[UserInfoEnableCell alloc] init];
    for (int i = 5 ; i< 9; i++) {
        cell = (UserInfoEnableCell *)[self.tableView viewWithTag:i];
        if (cell.contentChanged == YES) {
            userInfoChanged = YES;
            NSLog(@"用户信息修改了\n");
            
        }
        
        if (cell.formIllegal == YES){
            formIllegal = YES;
            NSLog(@"格式不正确\n");
        }
        
        if (![self.user_NikName.text isEqualToString:iswustUserInfo.nick_name] || ![self.user_Signature.text isEqualToString:iswustUserInfo.user_signature]) {
            userInfoChanged = YES;
        }
    }
    
    
    
    
}
- (void)refreshUserInfo{
    [self getIswustUserInfo];
    [self.tableView reloadData];
    [Tools ToastNotification:@"完成"  andView:self.view andLoading:NO andIsBottom:NO];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.user_NikName.backgroundColor = [UIColor grayColor];
   
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.user_NikName.backgroundColor = [UIColor whiteColor];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.user_Signature.backgroundColor = [UIColor grayColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.user_Signature.backgroundColor = [UIColor whiteColor];
}
- (void)returnLeft{
    
    [self checkUserInfoChange];
    if(rightButtonTouched == YES)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if(rightButtonTouched == NO && userInfoChanged == NO){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃当前编辑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        celltag = 4;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        switch (buttonIndex) {
            case 0:
                userInfoChanged = NO;
                rightButtonTouched = NO;
                formIllegal = NO;
                [self dismissViewControllerAnimated:YES completion:nil];
                break;
            case 1:
                if (isExistUserInfo == NO) {
                    
                    iswustUserInfo.nick_name = @"";
                    iswustUserInfo.user_signature = @"";
                    iswustUserInfo.user_qq = @"";
                    iswustUserInfo.user_email = @"";
                    iswustUserInfo.user_tel = @"";
                    iswustUserInfo.user_bedroom = @"";
                    iswustUserInfo.user_hometown = @"";
                    
                    
                    [_iSwustServer Iswust_GetUserInfo:iswustUserInfo];
                    iswustUserInfo = [dao findData];
                    if (iswustUserInfo == nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户个人信息获取失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        [self setUserInfo];
                        isExistUserInfo = YES;
                    }
                }
                break;
            default:
                break;
        }
        
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    imageData = UIImageJPEGRepresentation(image, 0.2);
    
    if ([Tools checkNetWorking]) {
        //上传头像
        int n = (int)[imageData length]/1000;
        NSString *imageSize =[NSString stringWithFormat:@"%d",n];
        [_iSwustServer ISwust_UpdatePicture:imageData file_Size:imageSize];
        
        //保存头像到沙盒
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",iswustUserInfo.user_number]];
        NSFileManager *fielManager = [NSFileManager defaultManager];
        if([fielManager fileExistsAtPath:fullPath]){
            [fielManager removeItemAtPath:fullPath error:nil];
        }
        [imageData writeToFile:fullPath atomically:YES];
        
        [self.user_Image setImage:image];
    }else{
        [Tools ToastNotification:@"网络异常" andView:self.view andLoading:NO andIsBottom:NO];
    }
   
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;}
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
        
    }
}


#pragma mark - dataSource and delegate
-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        UserInfoUnableCell *cell;
        //  static NSString *CellIdentifier = @"unableCell";
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"unableCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //    cell.userInteractionEnabled  = NO;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoUnableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.keyText.text = [arr_unableCellKey objectAtIndex:indexPath.row];
        cell.valueText.text = [arr_unableCellValue objectAtIndex:indexPath.row];
        return cell;
        
    }else{
        
        UserInfoEnableCell *cell;
        //  static NSString *CellIdentifier = @"enableCell";
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"enableCell"];
        }
        
        // cell.userInteractionEnabled  = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoEnableCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.tag = celltag;
        if(celltag == 4){
            cell.userInteractionEnabled = NO;
        }
        NSLog(@"cellTag == %d",celltag);
        cell.keyText.text = [arr_enableCellKey objectAtIndex:indexPath.row];
        cell.valueTF.text = [arr_enableCellValue objectAtIndex:indexPath.row];
        
        cell.contentChanged = NO;
        
        celltag++;
        return cell;
    }
}


-(void)returnlast{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
     //[self.navigationController popToViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserinfoVC"] animated:YES];
}
@end
