//
//  ModifyPwdVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/17.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ModifyPwdVC.h"
#import "RsaHelper.h"
#import "LoginVC.h"
@interface ModifyPwdVC ()
@property (nonatomic ,strong) UILabel *lblLogin;
@end

@implementation ModifyPwdVC
{
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_verificationText;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setUI];
}
- (void)setUI{

    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"修改密码"];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [self.lblLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:self.lblLogin];
    
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        //        make.width.mas_equalTo(73);
        //        make.height.mas_equalTo(50);
    }];
    
    
    [self creatTextField];
}
- (void)creatTextField{
    _phoneTextAccount = [[UITextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = [UIColor whiteColor];
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入原密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    [_phoneTextAccount setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    _phoneTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _phoneTextAccount.tag = 1;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    [_phoneTextAccount setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:_phoneTextAccount];
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"原密码"];
    [lalPhone setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:lineView3];
    
    UILabel *lalVerification = [[UILabel alloc]init];
    [lalVerification setText:@"新密码"];
    [lalVerification setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalVerification setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalVerification];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"确认新密码"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalPwd];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.secureTextEntry = YES;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    [_verificationText setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    _verificationText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeASCIICapable;
    _verificationText.tag = 4;
    [_verificationText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CGRectMake(0, AdaptationWidth(12.5), AdaptationWidth(28), AdaptationWidth(28));
    [secureButton setImage:[UIImage imageNamed:@"hidePwd"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"lookPwd"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    secureButton.tag= 100;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _verificationText.rightView = secureButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_verificationText];
    
    _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = [UIColor whiteColor];
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"再次输入新密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    _pwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
    [_pwdTextAccount setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIButton *secureButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton1.frame = CGRectMake(0, AdaptationWidth(12.5), AdaptationWidth(28), AdaptationWidth(28));
    [secureButton1 setImage:[UIImage imageNamed:@"hidePwd"] forState:UIControlStateNormal];
    [secureButton1 setImage:[UIImage imageNamed:@"lookPwd"] forState:UIControlStateSelected];
    secureButton1.selected = NO;
    secureButton1.tag = 101;
    [secureButton1 addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _pwdTextAccount.rightView = secureButton1;
    _pwdTextAccount.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTextAccount];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = AdaptationWidth(4);
    registerButton.clipsToBounds = YES;
    registerButton.backgroundColor = XColorWithRGB(252, 93, 109);
    [registerButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    registerButton.tag = 300;
    [registerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(AdaptationWidth(32));
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(AdaptationWidth(4));
        make.left.mas_equalTo(lalPhone);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_phoneTextAccount);
        make.height.mas_equalTo(0.5);
    }];
    [lalVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView);
    }];
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalVerification.mas_bottom).offset(AdaptationWidth(4));
        make.left.mas_equalTo(lalVerification);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_verificationText.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_verificationText);
        make.height.mas_equalTo(0.5);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView2);
    }];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(AdaptationWidth(4));
        make.left.mas_equalTo(lalPwd);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pwdTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_pwdTextAccount);
        make.height.mas_equalTo(0.5);
    }];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom).offset(AdaptationWidth(24));
        make.left.right.mas_equalTo(lineView3);
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
}
#pragma mark - btn

- (void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 300){//立即注册
        [self.view endEditing:YES];
        if (![[[UserInfo sharedInstance]getUserInfo].password isEqualToString: _phoneTextAccount.text]){
            [self setHudWithName:@"原密码错误" Time:0.5 andType:3];
            return;
        }
       
        if (_verificationText.text.length == 0){
            [self setHudWithName:@"请输入新密码" Time:0.5 andType:3];
            return;
        }
        if (_verificationText.text.length<8) {
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
            return;
        }
        
        NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:_verificationText.text]){
           
        }else{
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
            return;
        }
        if(![_pwdTextAccount.text isEqualToString:_verificationText.text]){
            [self setHudWithName:@"新密码和确认不一致！" Time:0.5 andType:3];
            return;
        }
        [self prepareDataWithCount:0];
        
    }
    
}
/**
 *  密码切换显示
 */
- (void)securePasswordClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 100:{
            if (sender.selected) {
                _verificationText.secureTextEntry = NO;
            }else{
                _verificationText.secureTextEntry = YES;
            }
            NSString *text1 = _verificationText.text;
            _verificationText.text = @" ";
            _verificationText.text = text1;
        }
            break;
            
        case 101:{
            if (sender.selected) {
                _pwdTextAccount.secureTextEntry = NO;
            }else{
                _pwdTextAccount.secureTextEntry = YES;
            }
            NSString *text = _pwdTextAccount.text;
            _pwdTextAccount.text = @" ";
            _pwdTextAccount.text = text;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - textfield
- (void)textFieldDidChange:(UITextField *)textField{

    if (textField.text.length >= 20) {
        textField.text = [textField.text substringToIndex:20];
    }
 
}
#pragma mark -- textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ((textField.text.length+string.length-range.length)>20) {
        [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
        return NO;
    }
    return YES;
}
#pragma mark - 网络
- (void)setRequestParams{
    NSData* oldPwd = [RsaHelper encryptString:_phoneTextAccount.text publicKey:nil];
    NSData* newPwd = [RsaHelper encryptString:_verificationText.text publicKey:nil];
    
    self.cmd = XModifyPassword;
    self.dict =[NSDictionary dictionaryWithObjectsAndKeys:[SecurityUtil bytesToHexString:oldPwd],@"oldPassword",[SecurityUtil bytesToHexString:newPwd],@"newPassword", nil];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    [self setHudWithName:@"修改成功" Time:0.5 andType:3];
    [[UserInfo sharedInstance]savePhone:nil password:_verificationText.text userId:nil grantAuthorization:nil];
    LoginVC *vc = [[LoginVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isModifyPwd = @(1);
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
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
