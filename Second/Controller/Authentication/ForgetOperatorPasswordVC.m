//
//  ForgetOperatorPasswordVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ForgetOperatorPasswordVC.h"
#import "XCountDownButton.h"

typedef NS_ENUM(NSInteger ,XForgetPwdVCReuqset ) {
    XForgetPwdVCReuqsetMessageCode,
    XForgetPwdVCReuqsetRevise,
};
@interface ForgetOperatorPasswordVC ()
@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UIButton *btnBack;
@end

@implementation ForgetOperatorPasswordVC
{
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
- (void)setUI{
    
    
    
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"忘记服务密码"];
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
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{}];
    _pwdTextAccount.text = [OperatorModel sharedInstance].operator_phone.length > 0 ?[OperatorModel sharedInstance].operator_phone : @"";
    _phoneTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _phoneTextAccount.tag = 1;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:_phoneTextAccount];
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
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
    [lalVerification setText:@"验证码"];
    [lalVerification setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalVerification setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalVerification];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"新服务密码"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalPwd];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.tag = 4;
    [self.view addSubview:_verificationText];
    
    _getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    _getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    [_getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationCodeButton setTitleColor:XColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    _getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _verificationText.rightView = _getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [_getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = [UIColor whiteColor];
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入服务密码" attributes:@{}];
    _pwdTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_pwdTextAccount];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = AdaptationWidth(4);
    registerButton.clipsToBounds = YES;
    registerButton.backgroundColor = XColorWithRGB(252, 93, 109);
    [registerButton setTitle:@"确定" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [registerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(AdaptationWidth(32));
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(4);
        make.left.mas_equalTo(lalPhone);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
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
        make.top.mas_equalTo(lalVerification.mas_bottom).offset(4);
        make.left.mas_equalTo(lalVerification);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
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
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(4);
        make.left.mas_equalTo(lalPwd);
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(43);
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
    
        [self.view endEditing:YES];
        if (_verificationText.text.length == 0) {
            [self setHudWithName:@"请输入短信验证码" Time:0.5 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length == 0){
            [self setHudWithName:@"请输入服务密码" Time:0.5 andType:3];
            return;
        }
        [self prepareDataWithCount:XForgetPwdVCReuqsetRevise];
 
}
- (void)getVerificationCodeClick:(XCountDownButton *)sender{
    
    _getVerificationCodeButton = sender;
    
    
    [self prepareDataWithCount:XForgetPwdVCReuqsetMessageCode];
    
    
}

#pragma mark - NSTimer
- (void)beginCountDown
{
    
    _getVerificationCodeButton.userInteractionEnabled = NO;
    
    [_getVerificationCodeButton startCountDownWithSecond:60];
    
    [_getVerificationCodeButton countDownChanging:^NSString *(XCountDownButton *countDownButton,NSUInteger second) {
        NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
        return title;
    }];
    [_getVerificationCodeButton countDownFinished:^NSString *(XCountDownButton *countDownButton, NSUInteger second) {
        _getVerificationCodeButton.userInteractionEnabled = YES;
        return @"未收到？";
    }];
    
}

#pragma mark - textfield
- (void)textFieldDidChange:(UITextField *)textField{
    
     if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
            //            _phontString = _phoneTextAccount.text;
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
    }
    
}
#pragma mark -- textFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1) {//密码
        if ((textField.text.length+string.length-range.length)>20) {
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 网络
- (void)setRequestParams{
    if (self.requestCount == XForgetPwdVCReuqsetMessageCode) {
        self.cmd = XResetOperatorPwd;
        self.dict = @{@"operator_phone":_phoneTextAccount.text,
                      @"type":@"RESEND_RESET_PWD_CAPTCHA"
                      };
    }else if (self.requestCount == XForgetPwdVCReuqsetRevise){
        
        self.cmd = XResetOperatorPwd;
        self.dict = @{@"operator_phone":_phoneTextAccount.text,
                      @"operator_password":_pwdTextAccount.text,
                      @"operator_website":[OperatorModel sharedInstance].operator_website,
                      @"operator_token":[OperatorModel sharedInstance].operator_token,
                      @"captcha":_verificationText.text,
                      @"type":@"SUBMIT_RESET_PWD",
                      @"reset_pwd_method":[OperatorModel sharedInstance].reset_pwd_method
                      };
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.requestCount == XForgetPwdVCReuqsetMessageCode) {
        [self setHudWithName:@"验证码获取成功" Time:0.5 andType:0];
        [self beginCountDown];
    }else if (self.requestCount == XForgetPwdVCReuqsetRevise){
        
    }
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
