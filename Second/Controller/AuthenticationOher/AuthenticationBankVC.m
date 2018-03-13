//
//  AuthenticationBankVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "AuthenticationBankVC.h"
#import "XCountDownButton.h"
#import "XControllerViewHelper.h"
#import "ScanningBankDetailVC.h"
#import "AuthorizationView.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSInteger ,AuthenticationBankRequest) {
    AuthenticationBankRequestPostInfo,
    AuthenticationBankRequestMessageCode,
    AuthenticationBankRequestGetInfo,
};
@interface AuthenticationBankVC ()
@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UILabel *textLogin;
@property (nonatomic,strong)  UIScrollView *scrollView;
@property (nonatomic,strong)  UIView *bgView;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation AuthenticationBankVC
{
    UILabel *bankNume;
    UITextField *_bankTextAccount;
    UITextField *_phoneTextAccount;
    UITextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
    NSDictionary *_bankInfoDict;//银行卡信息
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bankInfoModel = [BankInfoModel new];
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.isScanBan) {
        [self.view removeAllSubviews];
        [self setUI];
    }
}

- (void)setUI{
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height );
    self.scrollView.directionalLockEnabled  = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.bgView];
    
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"银行卡认证"];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:30]];
    [self.lblLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.bgView addSubview:self.lblLogin];
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(AdaptationWidth(16));
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
    }];
    
    self.textLogin = [[UILabel alloc]init];
    [self.textLogin setText:@"所填的手机号必须为银行预留手机号, 以便您顺利申请借款!"];
    self.textLogin.numberOfLines = 2;
    [self.textLogin setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
    [self.textLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.scrollView addSubview:self.textLogin];
    [self.textLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
    }];

    [self creatTextField];
}
- (void)creatTextField{
    UILabel *bankInfo = [[UILabel alloc]init];
    [bankInfo setText:@"银行信息"];
    [bankInfo setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [bankInfo setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.bgView addSubview:bankInfo];
    
    bankNume = [[UILabel alloc]init];
    [bankNume setText:@"点击扫描您的银行卡"];
    [bankNume setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [bankNume setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [self.bgView addSubview:bankNume];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn  addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"credit_Scan"] forState:UIControlStateNormal];
    [self.bgView addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc]init];
    [btn2 setBackgroundImage:[XControllerViewHelper imageWithColor:XColorWithRBBA(248, 249, 250, 0.4)] forState:UIControlStateHighlighted];
    [btn2  addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:btn2];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.bgView addSubview:line];
    
    _bankTextAccount = [[UITextField alloc]init];
    [_bankTextAccount setTextColor:XColorWithRGB(35, 58, 80)];
    if (self.bankInfoModel.bank_name && self.bankInfoModel.bank_card_no ) {
        _bankTextAccount.text = [NSString stringWithFormat:@"%@:   %@",self.bankInfoModel.bank_name,self.bankInfoModel.bank_card_no];
    }
    _bankTextAccount.backgroundColor = [UIColor whiteColor];
    _bankTextAccount.borderStyle = UITextBorderStyleNone;
    _bankTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"扫描银行卡后将自动录入" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.16)}];
    
    _bankTextAccount.enabled = NO;
    _bankTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];

    [self.bgView addSubview:_bankTextAccount];
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"开户银行及卡号"];
    [lalPhone setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.bgView addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.bgView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.bgView addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc]init];
    lineView3.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.bgView addSubview:lineView3];
    
    UILabel *lalVerification = [[UILabel alloc]init];
    [lalVerification setText:@"验证码"];
    [lalVerification setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalVerification setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.bgView addSubview:lalVerification];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"手机号"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [self.bgView addSubview:lalPwd];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
//    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.tag = 4;
    [self.bgView addSubview:_verificationText];
    
    _getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    _getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    [_getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationCodeButton setTitleColor:XColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    _getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _verificationText.rightView = _getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [_getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _phoneTextAccount = [[UITextField alloc]init];
    [_phoneTextAccount setTextColor:XColorWithRGB(34, 58, 80)];
    _phoneTextAccount.backgroundColor = [UIColor whiteColor];
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"银行预留的手机号" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    _phoneTextAccount.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _phoneTextAccount.tag = 2;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bgView addSubview:_phoneTextAccount];
    
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.authView];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = AdaptationWidth(4);
    registerButton.clipsToBounds = YES;
    registerButton.backgroundColor = XColorWithRGB(252, 93, 109);
    [registerButton setTitle:@"提交" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    registerButton.tag = 300;
    [registerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:registerButton];
    
    
    [bankInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.textLogin.mas_bottom).offset(AdaptationWidth(32));
    }];
    [bankNume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(bankInfo.mas_bottom).offset(8);
        make.height.mas_equalTo(AdaptationWidth(30));
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(bankNume);
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankInfo.mas_bottom).offset(8);
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankNume.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_phoneTextAccount);
        make.height.mas_equalTo(0.5);
    }];
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(15));
    }];
    [_bankTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(8);
        make.left.mas_equalTo(lalPhone);
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bankTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_bankTextAccount);
        make.height.mas_equalTo(0.5);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView);
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(8);
        make.left.mas_equalTo(lalPwd);
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(30);
    }];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneTextAccount.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_phoneTextAccount);
        make.height.mas_equalTo(0.5);
    }];
    [lalVerification mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(lineView3);
    }];
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lalVerification.mas_bottom).offset(8);
        make.left.mas_equalTo(lalVerification);
        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(30));
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_verificationText.mas_bottom).offset(AdaptationWidth(15));
        make.left.right.mas_equalTo(_verificationText);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView);
        make.right.mas_equalTo(self.bgView);
        make.top.mas_equalTo(lineView2.mas_bottom).offset(AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    
    if (self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 1)
    {
        self.authView.hidden = YES;
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView2.mas_bottom).offset(AdaptationWidth(16));
            make.left.right.mas_equalTo(lineView2);
            make.height.mas_equalTo(AdaptationWidth(50));
        }];
    }else{
        [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.authView.mas_bottom);
            make.left.right.mas_equalTo(lineView2);
            make.height.mas_equalTo(AdaptationWidth(50));
        }];
    }
    
}
#pragma mark - btn
- (void)btnOnClick:(UIButton*)btn{
    [self startBankCardOCR];//开始扫描银行卡
}
- (void)onButtonClick:(UIButton *)btn{
    if(_phoneTextAccount.text.length == 0){
        [self setHudWithName:@"请输入手机号码" Time:0.5 andType:1];
        return;
    }
    if (_verificationText.text.length == 0) {
        [self setHudWithName:@"请输入短信验证码" Time:0.5 andType:1];
        return;
    }
    if (!self.authView.AgreementBtn.selected) {
        [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {}];
        return;
    }
    _bankInfoModel.phone = _phoneTextAccount.text;
    _bankInfoModel.sms_authentication_code = _verificationText.text;
    [self prepareDataWithCount:AuthenticationBankRequestPostInfo];
}
- (void)getVerificationCodeClick:(XCountDownButton *)sender{
    [self beginCountDown];
    [self prepareDataWithCount:AuthenticationBankRequestMessageCode];
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
            //            NSLog(@"按钮");
            break;
            
        default:
            break;
    }
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
        return @"重新获取";
    }];
    
}

#pragma mark - textfield
- (void)textFieldDidChange:(UITextField *)textField{
    
     if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
            //            _phontString = _phoneTextAccount.text;
        }
    }
    
}
/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name
{
    MyLog(@"%s", __func__);
    _bankInfoDict = @{@"bank_num":bank_num,
                      @"bank_name":bank_name
                      };
    _bankInfoModel.bank_card_no = bank_num;
    _bankInfoModel.bank_name = bank_name;
    _bankInfoModel.true_name = card_name;
    
    
    
}

/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage
{
    
    ScanningBankDetailVC *vc = [[ScanningBankDetailVC alloc]init];
    vc.model = _bankInfoModel;
    vc.bankImage = BankCardImage;
    
    vc.block = ^(NSString *bankName, NSString *bankNumer) {
        _bankInfoModel.bank_name = bankName;
        _bankInfoModel.bank_card_no = bankNumer;
    };
    self.isScanBan = YES;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"%s", __func__);
    
}

#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case AuthenticationBankRequestMessageCode:{
            self.cmd = XSmsAuthenticationCode;
            self.dict = @{@"phone_num":_phoneTextAccount.text,
                          @"opt_type":@4
                          };
        }
            break;
       
        case AuthenticationBankRequestPostInfo:{
            self.cmd = XBankCardCheck;
            self.dict = [_bankInfoModel mj_keyValues];
        }
            break;
        
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case AuthenticationBankRequestMessageCode:{
            [self setHudWithName:@"短信发送成功" Time:0.5 andType:0];
        }
            break;
        
        case AuthenticationBankRequestPostInfo:{
            [self setHudWithName:@"银行卡授权成功" Time:0.5 andType:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
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

