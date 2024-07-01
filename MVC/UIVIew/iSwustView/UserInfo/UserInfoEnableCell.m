//
//  UserInfoEnableCell.m
//  i西科
//
//  Created by MAC on 15/4/3.
//  Copyright (c) 2015年 weixvn. All rights reserved.
//

#import "UserInfoEnableCell.h"

@implementation UserInfoEnableCell{
    
    NSString *textBeforEdit;
    NSString *textAfterEdit;
    
}

- (void)awakeFromNib {
    // Initialization code
    self.valueTF.delegate  = self;
    self.formIllegal = NO;//格式合法
}
- (void)checkForm{
    textAfterEdit = self.valueTF.text;
    if(![textBeforEdit isEqualToString:textAfterEdit]){
        self.contentChanged = YES;
        NSLog(@"asdasdasd用户信息修改了\n");
    }
    
    if(self.tag == 6 && ![self.valueTF.text isEqualToString:@""]){
        NSString *telNumber = self.valueTF.text;
        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
        if([phoneTest evaluateWithObject:telNumber]){
            self.valueTF.backgroundColor = [UIColor whiteColor];
            self.formIllegal = NO;
        }else{
            self.valueTF.backgroundColor = [UIColor redColor];
            self.formIllegal = YES;
        }
        
    }else if (self.tag == 7 && ![self.valueTF.text isEqualToString:@""]) {
        NSString *email = self.valueTF.text;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if ([emailTest evaluateWithObject:email]) {
            self.valueTF.backgroundColor = [UIColor whiteColor];
            self.formIllegal = NO;
        }else{
            self.valueTF.backgroundColor = [UIColor redColor];
            self.formIllegal = YES;
        }
    }else if(self.tag == 5 && ![self.valueTF.text isEqualToString:@""]){
        NSString *qqNumber = self.valueTF.text;
        NSString *qqNumberRegex = @"[0-9]{1,20}";
        NSPredicate *qqTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qqNumberRegex];
        if ([qqTest evaluateWithObject:qqNumber]) {
            self.valueTF.backgroundColor = [UIColor whiteColor];
            self.formIllegal = NO;
        }else{
            self.valueTF.backgroundColor = [UIColor redColor];
            self.formIllegal = YES;
        }
        
    }
    else {
        self.valueTF.backgroundColor = [UIColor whiteColor];
        self.formIllegal = NO;
    }
    
    NSLog(@"tag --- %d\n",self.tag);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//初始化

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    

    
    self.contentChanged = NO;
    self.formIllegal = NO;
    self.valueTF.backgroundColor = [UIColor grayColor];
    textBeforEdit = self.valueTF.text;
    
    
}
- (void)delete:(id)sender{
    [self checkForm];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkForm];
}
@end
