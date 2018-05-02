//
//  RegisterVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "RegisterVC.h"
#import "XCountDownButton.h"
#import "XWMCodeImageView.h"
#import "LoginVC.h"
#import "XSessionMgr.h"
#import "RsaHelper.h"
#import "ParamModel.h"
#import "XRootWebVC.h"
#import <AudioToolbox/AudioToolbox.h>
typedef NS_ENUM(NSInteger , XRegisterReuqst) {
    XRegisterReuqstMessageCode,
    XRegisterReuqstRegist,
};

@interface RegisterVC ()

@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UIView *loginView;
@property (nonatomic ,strong) UIImageView *loginImage;
@property (nonatomic ,strong) UIButton *btnBack;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@end

@implementation RegisterVC
{
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}
- (void)setUI{
    

//    self.btnBack = [[UIButton alloc]init];
//    [self.btnBack addTarget:self action:@selector(onBtnclick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnBack setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [self.view addSubview:self.btnBack];
    //
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"注册"];
    //    [self.lblLogin setFont:[UIFont systemFontOfSize: AdaptationWidth(36)]];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [self.lblLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
//    self.loginView  = [[UIView alloc]init];
//    self.loginView.backgroundColor = XColorWithRGB(255, 226, 134);
    
    self.loginImage  = [[UIImageView alloc]init];
    self.loginImage.image = [UIImage imageNamed:@"tatoo"];
    
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.lblLogin];
    [self.view addSubview:self.loginImage];
    
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(50);
    }];
//    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.mas_equalTo(self.lblLogin);
//        make.width.mas_equalTo(52);
//        make.height.mas_equalTo(23);
//    }];
    [self.loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-16);
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(23));
        make.width.mas_equalTo(AdaptationWidth(88));
        make.height.mas_equalTo(AdaptationWidth(88));
    }];
    
    
    [self creatTextField];
}
- (void)creatTextField{
    _phoneTextAccount = [[UITextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = [UIColor whiteColor];
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];

    if (self.phoneName.length) {
        _phoneTextAccount.text = self.phoneName;
    }
    _phoneTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _phoneTextAccount.tag = 1;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextAccount setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
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
    [lalPwd setText:@"密码"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.view addSubview:lalPwd];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.tag = 4;
    [_verificationText setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:_verificationText];
    
    _getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    _getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    [_getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationCodeButton setTitleColor:XColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    _getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    _getVerificationCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    _verificationText.rightView = _getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [_getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = [UIColor whiteColor];
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];

    if ([[UserInfo sharedInstance]getUserInfo].userId) {
        _pwdTextAccount.text = [UserInfo sharedInstance].password;
    }
    _pwdTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
    [_pwdTextAccount setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CGRectMake(0, AdaptationWidth(12.5), AdaptationWidth(28), AdaptationWidth(28));
    [secureButton setImage:[UIImage imageNamed:@"hidePwd"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"lookPwd"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _pwdTextAccount.rightView = secureButton;
    _pwdTextAccount.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTextAccount];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 4;
    registerButton.clipsToBounds = YES;
    registerButton.backgroundColor = XColorWithRGB(252, 93, 109);
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    registerButton.tag = 300;
    [registerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UIButton *login = [[UIButton alloc]init];
    [login setTitle:@"快速登录" forState:UIControlStateNormal];
    [login setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
    [login addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    UILabel *labLoginSure = [[UILabel alloc]init];
    [labLoginSure setText:@"注册即代表您已同意"];
    [labLoginSure setFont:[UIFont systemFontOfSize:AdaptationWidth(13)]];
    [labLoginSure setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [self.view addSubview:labLoginSure];
    
    UIButton *btnAgree = [[UIButton alloc]init];
    [btnAgree setTitle:@"「用户协议」" forState:UIControlStateNormal];
    [btnAgree setTitleColor:XColorWithRBBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
    [btnAgree.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(13)]];
    btnAgree.tag = 7;
    [btnAgree addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAgree];
    
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
    [btnAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerButton.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(registerButton);
    }];
    [labLoginSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(btnAgree);
        make.right.mas_equalTo(btnAgree.mas_left).offset(1);
    }];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerButton.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(registerButton);
        
    }];
    
}
#pragma mark - btn
- (void)onBtnclick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)loginButtonClick:(UIButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)onButtonClick:(UIButton *)btn{
    if (btn.tag == 300){//立即注册
        [self.view endEditing:YES];
        if (_verificationText.text.length == 0) {
            [self setHudWithName:@"请输入手机验证码" Time:0.5 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length == 0){
            [self setHudWithName:@"请输入密码" Time:0.5 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length<8) {
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return;
        }
        
        NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:_pwdTextAccount.text]){
            [self prepareDataWithCount:XRegisterReuqstRegist];
        }else{
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return;
        }
    }else if (btn.tag == 7){
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.url = self.clientGlobalInfoRM.wap_url_list.zcxy_url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)getVerificationCodeClick:(XCountDownButton *)sender{
    
    _getVerificationCodeButton = sender;
    UIView *view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = XColorWithRBBA(0, 0, 0, 0.5);
    [self.view addSubview:view];
    XWMCodeImageView *codeView = [[XWMCodeImageView alloc]initWithFrame:CGRectZero withController:self];
    
    [view addSubview:codeView];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(272);
        make.height.mas_equalTo(175);
        make.center.mas_equalTo(view);
    }];
    
    WEAKSELF
    codeView.block = ^(UIButton * result) {
        switch (result.tag) {
            case 100:
                
                [weakSelf prepareDataWithCount:XRegisterReuqstMessageCode];
                view.hidden = YES;
                break;
            case 101:
                view.hidden = YES;
                break;
                
            default:
                break;
        }
    };
}
/**
 *  密码切换显示
 */
- (void)securePasswordClick:(UIButton *)sender{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
//    AudioServicesPlaySystemSound(1520);
    sender.selected = !sender.selected;
    if (sender.selected) {
        _pwdTextAccount.secureTextEntry = NO;
    }else{
        _pwdTextAccount.secureTextEntry = YES;
    }
    NSString *text = _pwdTextAccount.text;
    _pwdTextAccount.text = @" ";
    _pwdTextAccount.text = text;
    
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
        return @"重新发送";
    }];
    
}

#pragma mark - textfield
- (void)textFieldDidChange:(UITextField *)textField{
    
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
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
            [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 网络请求
- (void)setRequestParams{
    if (self.requestCount == XRegisterReuqstRegist) {
        
        NSString *pwdStr = _pwdTextAccount.text;
        NSData* passDada = [RsaHelper encryptString:pwdStr publicKey:nil];
        NSString *str = [SecurityUtil bytesToHexString:passDada];
        self.cmd = XRegistUserByPhoneNum;
        self.dict = @{@"phone_num":_phoneTextAccount.text,@"password":str,@"sms_authentication_code":_verificationText.text};
//        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                     _phoneTextAccount.text,@"phone_num",
//                     str,"password",
//                     _verificationText.text,@"sms_authentication_code", nil];

    
    }else if (self.requestCount == XRegisterReuqstMessageCode){
        self.cmd = XSmsAuthenticationCode;
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextAccount.text,@"phone_num",@1,@"opt_type",nil];
    }else if(self.requestCount == 100){
        self.cmd = XGrantAuthorization;
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"opt_type", nil];
    }else if (self.requestCount == 101){
        self.cmd = XGrantAuthorization;
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"opt_type", nil];
    }
}
-(void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.requestCount == XRegisterReuqstRegist) {
         [self setHudWithName:@"注册成功" Time:0.5 andType:0];
        //talkingdata
        [TalkingData onRegister:_phoneTextAccount.text type:TDAccountTypeRegistered name:@"全网贷"];
        
        [[UserInfo sharedInstance]savePhone:_phoneTextAccount.text password:_pwdTextAccount.text userId:@"100" grantAuthorization:response.content[@"has_grant_authorization"]];
//        if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue != 1){
//            [self showAlertView];
//        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }else if (self.requestCount == XRegisterReuqstMessageCode){
        [self setHudWithName:@"验证码获取成功" Time:0.5 andType:0];
        [self beginCountDown];
        
    }
}
- (void)showAlertView{
    [XAlertView alertWithTitle:@"温馨提示" message:@"在使用过程中，全网贷会为您推荐相应的贷款产品，您部分必要的个人信息（包括但不限于手机号、工作信息等）可能会根据您的需求，匹配给对应的第三方机构。" cancelButtonTitle:@"不同意" confirmButtonTitle:@"同意授权" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UserInfo sharedInstance]savePhone:nil password:nil userId:nil grantAuthorization:@(1)];
            [self prepareDataWithCount:100];
        }
        if (buttonIndex == 0) {
            [[UserInfo sharedInstance]savePhone:nil password:nil userId:nil grantAuthorization:@(2)];
            [self prepareDataWithCount:101];
        }
    }];
    
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

