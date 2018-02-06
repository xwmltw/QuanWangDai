//
//  OperatorAuthenticationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OperatorAuthenticationVC.h"
#import "OperatorModel.h"
#import "OperatorAuthenticationSecondVC.h"
#import "ForgetOperatorPasswordVC.h"
#import "AuthorizationView.h"
#import "XRootWebVC.h"
#import "XAlertView.h"
typedef NS_ENUM(NSInteger, OperatorsCreditRequest) {
    OperatorsCreditRequestInfo,
    OperatorsCreditRequestVerify,
};
@interface OperatorAuthenticationVC ()<UITextFieldDelegate>
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation OperatorAuthenticationVC
{
    UITextField *_phoneText;
    UITextField *_operatorsText;
    UIAlertView *alert;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:OperatorsCreditRequestInfo];
    [self setUI];
    
}
- (void)setUI{
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setText:@"运营商认证"];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:titleLab];
    
    
    UILabel *phoneLab = [[UILabel alloc]init];
    [phoneLab setText:@"手机号码（不可更改）"];
    [phoneLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [phoneLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:phoneLab];
    
    _phoneText = [[UITextField alloc]init];
    
    [self.view addSubview:_phoneText];
    _phoneText.font = [UIFont fontWithName:@"PingFangSC-Regular" size: AdaptationWidth(18)];
    _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号" attributes:@{NSForegroundColorAttributeName: XColorWithRBBA(34, 58, 80, 0.32)}];
    _phoneText.textColor = XColorWithRBBA(34, 58, 80, 0.8);

    if ([[UserInfo sharedInstance]getUserInfo].phoneName.length) {
        _phoneText.enabled = NO;
    }
//    _phoneText.text = [[UserInfo sharedInstance]getUserInfo].phoneName.length > 0 ? [[UserInfo sharedInstance]getUserInfo].phoneName : @"";
    
    
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:line1];
    
    UILabel *pwdLab = [[UILabel alloc]init];
    [pwdLab setText:@"服务密码"];
    [pwdLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [pwdLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:pwdLab];
    
    _operatorsText = [[UITextField alloc]init];
    [self.view addSubview:_operatorsText];
    _operatorsText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _operatorsText.keyboardType = UIKeyboardTypeNumberPad;
    _operatorsText.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    _operatorsText.delegate = self;
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:line2];
    
    [self refreshView];
    
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.authView];
    if (self.creditInfoModel.operator_status.integerValue == 1) {//判断是否认证过
        self.authView.hidden = YES;
    }
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.tag = 100;
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(17)]];
    [sureBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [sureBtn setCornerValue:4];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    UIButton *forgetBtn = [[UIButton alloc]init];
    forgetBtn.tag = 101;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    [forgetBtn setTitleColor:XColorWithRBBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
    }];
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(32));
    }];
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(phoneLab.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(_phoneText.mas_bottom).offset(AdaptationWidth(5));
        make.height.mas_equalTo(0.5);
    }];
    [pwdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(line1.mas_bottom).offset(AdaptationWidth(20));
    }];
    [_operatorsText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(pwdLab.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(_operatorsText.mas_bottom).offset(AdaptationWidth(5));
        make.height.mas_equalTo(0.5);
    }];
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(line2.mas_bottom).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(sureBtn.mas_top);
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(self.authView.mas_bottom);
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(sureBtn.mas_bottom).offset(AdaptationWidth(8));
    }];
    
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        if ([OperatorModel sharedInstance].reset_pwd_method.integerValue == 1) {
            [self setHudWithName:@"需要重置密码" Time:0.5 andType:1];
            return;
        }
        
        if (_operatorsText.text.length == 0) {
            [self setHudWithName:@"请输入服务密码" Time:0.5 andType:1];
            return;
        }
        
        if (_operatorsText.text.length != 6 && _operatorsText.text.length != 8) {
            [self setHudWithName:@"服务密码为6位或8位" Time:0.5 andType:1];
            return;
        }
        if (!self.authView.AgreementBtn.selected && self.creditInfoModel.operator_status.integerValue == 0) {
            [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {}];
            return;
        }
        [self prepareDataWithCount:OperatorsCreditRequestVerify];
    }
    if (btn.tag == 101) {
//        ForgetOperatorPasswordVC *vc = [[ForgetOperatorPasswordVC alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"忘记密码?" message:@"如果您忘记了服务密码，请拨打运营商客服热线进行密码重置。\n\n\n 移动请拨10086 转人工服务\n 联通请拨10010 转人工服务\n 电信请拨10000 转人工服务" preferredStyle:UIAlertControllerStyleAlert];
        UIView *subView1 = alertController.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
        UILabel *message = subView5.subviews[1];
        message.textAlignment = NSTextAlignmentLeft;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)refreshView
{
    if ([[UserInfo sharedInstance]getUserInfo].phoneName.length != 0) {
        _phoneText.text = [[UserInfo sharedInstance]getUserInfo].phoneName;
        [_phoneText setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
    }else {
        _phoneText.text = @"";
    }
    
    if ( [OperatorModel sharedInstance].operator_password != 0) {
        _operatorsText.text = [OperatorModel sharedInstance].operator_password;
    }
}

-(void)buttonClick:(UIButton*)button{
    switch (button.tag) {
        case AuthorizationBtnOnClickAgreement:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.clientGlobalInfoModel.wap_url_list.collect_info_grant_authorization_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case AuthorizationBtnOnClickTick:
            button.selected = !button.selected;
            self.authView.AgreementBtn.selected = button.selected;
            break;
            
        default:
            break;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _operatorsText) {
        if (textField.text.length >= 8 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        if ([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
        {
            return NO;
        }
        
    }
    return YES;
}
#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case OperatorsCreditRequestInfo:
            self.cmd = XGetOperatorInfo;
            self.dict = @{};
            break;
        case OperatorsCreditRequestVerify:
            self.cmd  = XPostOperatorVerify;
            self.dict = @{@"operator_phone":_phoneText.text,
                          @"operator_password":_operatorsText.text,
                          @"operator_website":[OperatorModel sharedInstance].operator_website,
                          @"operator_token":[OperatorModel sharedInstance].operator_token
                          };
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OperatorsCreditRequestInfo:{
            [[OperatorModel sharedInstance] mj_setKeyValues:response.content];
            if ([OperatorModel sharedInstance].operator_password.length > 0) {
                _operatorsText.attributedPlaceholder = nil;
                _operatorsText.text = [OperatorModel sharedInstance].operator_password.length > 0 ? [OperatorModel sharedInstance].operator_password : @"";
            }else{
//                _operatorsText.placeholder = @"请输入您的服务密码";
                _operatorsText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的服务密码" attributes:@{NSForegroundColorAttributeName: XColorWithRBBA(34, 58, 80, 0.32)}];
            }
//            [self setUI];
        }
            break;
        case OperatorsCreditRequestVerify:{
            
            if (response.errCode.integerValue == 20) {
                
                return;
            }
            OperatorAuthenticationSecondVC *vc = [[OperatorAuthenticationSecondVC alloc]init];
            vc.phoneStr = _phoneText.text;
            vc.pwdStr = _operatorsText.text;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
        }
            break;
            
        default:
            break;
    }
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
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
