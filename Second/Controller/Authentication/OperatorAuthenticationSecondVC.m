//
//  OperatorAuthenticationSecondVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OperatorAuthenticationSecondVC.h"
#import "XCountDownButton.h"
#import "OperatorModel.h"
typedef NS_ENUM(NSInteger ,OperatorRequestSceond) {
    OperatorRequestSceondCode,
    OperatorRequestSceondSure,
};
@interface OperatorAuthenticationSecondVC ()

@end

@implementation OperatorAuthenticationSecondVC
{
    UITextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:OperatorRequestSceondCode];
    [self setUI];
}
- (void)setUI{
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setText:@"运营商认证"];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:titleLab];
    
    
    UILabel *phoneLab = [[UILabel alloc]init];
    [phoneLab setText:@"短信验证码"];
    [phoneLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [phoneLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:phoneLab];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入短信验证码" attributes:@{}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
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
    
    [self beginCountDown];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:line1];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [sureBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [sureBtn setCornerValue:5];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
    }];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(32));
    }];
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(_verificationText.mas_bottom);
        make.height.mas_equalTo(AdaptationWidth(1));
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(line1.mas_bottom).offset(AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
}
#pragma  mark - btn
- (void)getVerificationCodeClick:(XCountDownButton *)sender{
    
    [self prepareDataWithCount:OperatorRequestSceondCode];

}
- (void)btnOnClick:(UIButton *)btn{
    if (_verificationText.text.length == 0) {
        [self setHudWithName:@"请输入短信验证码" Time:0.5 andType:1];
        return;
    }
    [self prepareDataWithCount:OperatorRequestSceondSure];
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
        return @"重新获取？";
    }];
    
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case OperatorRequestSceondCode:
            self.cmd  = XPostOperatorVerify;
            self.dict = @{@"operator_phone":self.phoneStr,
                          @"operator_password":self.pwdStr,
                          @"operator_website":[OperatorModel sharedInstance].operator_website,
                          @"operator_token":[OperatorModel sharedInstance].operator_token,
                          @"captcha":@"",
                          @"type":@"RESEND_CAPTCHA"
                          };
            break;
        case OperatorRequestSceondSure:
            self.cmd = XPostOperatorVerify;
            self.dict = @{@"operator_phone":self.phoneStr,
                          @"operator_password":self.pwdStr,
                          @"operator_website":[OperatorModel sharedInstance].operator_website,
                          @"operator_token":[OperatorModel sharedInstance].operator_token,
                          @"captcha":_verificationText.text,
                          @"type":@"SUBMIT_CAPTCHA"
                          };
            break;
            
        default:
            break;
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OperatorRequestSceondCode:
           [self setHudWithName:response.errMsg Time:0.5 andType:1];
            break;
        case OperatorRequestSceondSure:{
            NSString *result = response.content[@"process_code"];
            if ([result isEqualToString:@"10008"]) {
                [self setHudWithName:@"运营商认证成功" Time:0.5 andType:1];
                [self.navigationController popToRootViewControllerAnimated:NO];
                return;
            }
            if ([result isEqualToString:@"10007"]) {
                [self setHudWithName:@"简单密码/初始密码或错误密码无法登陆" Time:0.5 andType:1];
                
                return;
            }
            [self setHudWithName:result Time:0.5 andType:1];
            
        }
            break;
            
        default:
            break;
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
