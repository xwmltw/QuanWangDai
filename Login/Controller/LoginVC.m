//
//  LoginVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "XCountDownButton.h"
#import "ForgetPwdVC.h"
#import "XSessionMgr.h"
#import "ForgetPwdVC.h"
#import "NSString+NSHash.h"
#import "XWMCodeImageView.h"
#import <AudioToolbox/AudioToolbox.h>
typedef NS_ENUM(NSInteger ,XLoginRequest) {
    XLoginRequestMessageCode,
    XLoginRequestSignIn,
    XLoginRequestQuick,
    
};

@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic ,strong) UILabel *lblLogin;
@property (nonatomic ,strong) UIImageView *loginImage;

@property (nonatomic, strong) UIView * greenView;
@property (nonatomic, strong) UIView * orangeView;

/**底部按钮视图中间的分割线*/
@property (nonatomic, strong) UIView * centerView;

/**底部按钮视图中间的下划线*/
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * buttonView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *buttonA;
@property (nonatomic, strong) UIButton *buttonB;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;

@property (nonatomic, strong)UIView *seperatorLine;

@end

@implementation LoginVC
{
    UIButton *loginButtonAccount;
    UITextField *_phoneTextAccount;
    UITextField *_pwdTextAccount;
    UITextField *_phoneTextQuick;
    UITextField *_verificationTextQuick;
    UIButton          *_vericationRightBtn;
    NSInteger          _timer;
    NSTimer           *_timerCode;
    NSTimer           *_timerClose;
    XCountDownButton *_getVerificationButton;
    NSString          *_phoneString;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup_UI];
    
    [self addNoticeForKeyboard];
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = 0.0;
    if (_pwdTextAccount.editing || _verificationTextQuick.editing) {
        offset = (self.buttonView.frame.origin.y + AdaptationWidth(175)) - (self.view.frame.size.height - kbHeight);
    }else if(_phoneTextAccount.editing || _phoneTextQuick.editing){
        offset = (self.buttonView.frame.origin.y + AdaptationWidth(90)) - (self.view.frame.size.height - kbHeight);
    }
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
- (void)setup_UI {
        //v1.2
//        self.btnBack = [[UIButton alloc]init];
//        [self.btnBack addTarget:self action:@selector(onBtnclick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btnBack setImage:[UIImage imageNamed:@"NavigationBarBack"] forState:UIControlStateNormal];
//        [self.view addSubview:self.btnBack];
    
    self.lblLogin = [[UILabel alloc]init];
    [self.lblLogin setText:@"登录"];
    [self.lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:36]];
    [self.lblLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
    
    self.loginImage  = [[UIImageView alloc]init];
    self.loginImage.image = [UIImage imageNamed:@"tatoo"];
    
    [self.view addSubview:_lblLogin];
    [self.view addSubview:self.loginImage];
    
    //配置scrollView的属性
    self.scrollView = [[UIScrollView alloc] init];
    //    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:@"#f0eff5"]];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * 2, 0)];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.greenView  = [[UIView alloc] init];
    self.orangeView = [[UIView alloc] init];
    self.buttonView = [[UIView alloc] init];
    //    self.centerView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.buttonA = [[UIButton alloc] init];
    self.buttonB = [[UIButton alloc] init];
    
    [self.view addSubview:self.scrollView];
    //    [self.scrollView addSubview:self.greenView];
    //    [self.scrollView addSubview:self.orangeView];
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 115, ScreenWidth, ScreenHeight-115)];
        if (i == 0) {
            self.greenView = view;
            [self.scrollView addSubview:self.greenView];
        }else{
            self.orangeView = view;
            [self.scrollView addSubview:self.orangeView];
        }
    }
    
    [self.view addSubview:self.buttonView];
    [self.buttonView addSubview:self.buttonA];
    [self.buttonView addSubview:self.buttonB];
    self.seperatorLine =[UIView new];
    self.seperatorLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.buttonView addSubview:self.seperatorLine];
    [self.buttonView addSubview:self.bottomView];
    //    [self.buttonView addSubview:self.centerView];
    //    [self.greenView  setBackgroundColor:[UIColor whiteColor]];
    //    [self.orangeView setBackgroundColor:[UIColor whiteColor]];
    //    [self.centerView setBackgroundColor:[UIColor blackColor]];
    [self.bottomView setBackgroundColor:XColorWithRGB(23, 143, 149)];
    
    [self.buttonA setTitle:@"账号密码登录" forState:UIControlStateNormal];
    [self.buttonB setTitle:@"验证码登录" forState:UIControlStateNormal];
    [self.buttonA setTitleColor:XColorWithRBBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
    [self.buttonB setTitleColor:XColorWithRBBA(34, 58, 80, 0.48) forState:UIControlStateNormal];
    
    //    [self.buttonA setBackgroundColor:[UIColor whiteColor]];
    //    [self.buttonB setBackgroundColor:[UIColor whiteColor]];
    [self.buttonA setTitle:@"账号密码登录" forState:UIControlStateSelected];
    [self.buttonB setTitle:@"验证码登录" forState:UIControlStateSelected];
    [self.buttonA setTitleColor:XColorWithRGB(17, 142, 149) forState:UIControlStateSelected];
    [self.buttonB setTitleColor:XColorWithRGB(17, 142, 149) forState:UIControlStateSelected];
    
    self.buttonA.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
    self.buttonB.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
    
    self.buttonA.selected = YES;
    
    [self.buttonA addTarget:self action:@selector(clickButtonA) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonB addTarget:self action:@selector(clickButtonB) forControlEvents:UIControlEventTouchUpInside];
    
    [self setup_Layout];
    //    [self setup_ScrollView];
    
    [self createTextfieldAccount];
    [self createButtonAccount];
    [self createTextfieldQuick];
    [self createButtonQuick];
}

//按钮的点击方法，当按钮被点击时，移动到相应的位置，显示相应的view。
#pragma mark - 按钮的点击事件
- (void)onBtnclick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickButtonA {
    self.buttonB.selected = NO;
    self.buttonA.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
}

- (void)clickButtonB {
    self.buttonA.selected = NO;
    self.buttonB.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    }];
}
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    _getVerificationButton = sender;
    if (_phoneTextQuick.text.length != 11) {
        [self setHudWithName:@"请输入正确的手机号码" Time:0.5 andType:0];
        return;
    }
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
                
                [weakSelf prepareDataWithCount:XLoginRequestMessageCode];
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


//为各个控件设置约束，用Masonry设置约束。Masonry设置约束一定要注意：先添加然后再设置约束，不然会崩溃报错。
#pragma mark - 约束设置
- (void)setup_Layout {
    
    
    
    [self.lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
        make.left.mas_equalTo(self.view).offset(24);
        make.width.mas_equalTo(73);
        make.height.mas_equalTo(50);
    }];

    [self.loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-16);
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(23));
        make.width.mas_equalTo(AdaptationWidth(88));
        make.height.mas_equalTo(AdaptationWidth(88));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lblLogin.mas_bottom).offset(18);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(45);
    }];
    
    [self.greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.left.mas_equalTo(self.scrollView);
        make.top.mas_equalTo(self.buttonView.mas_bottom);
        make.centerX.equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(ScreenHeight - 115);
    }];
    
    [self.orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.mas_bottom);
        make.left.mas_equalTo(self.greenView.mas_right);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight - 115);
    }];
    
    [self.buttonA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(ScreenWidth / 3);
        make.left.mas_equalTo(self.buttonView);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    [self.buttonB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(ScreenWidth / 3);
        make.left.mas_equalTo(self.buttonA.mas_right);
        make.height.mas_equalTo(self.buttonView);
    }];
    
    //    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.width.mas_equalTo(3);
    //        make.height.mas_equalTo(34);
    //        make.center.mas_equalTo(self.buttonView);
    //    }];
    
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(0);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonView);
        make.width.mas_equalTo(AdaptationWidth(72) );
        make.height.mas_equalTo(2);
        make.left.mas_equalTo(self.buttonView).offset(AdaptationWidth(26));
//        make.centerX.mas_equalTo(self.buttonA);
    }];
}

////配置ScrollView的属性

//ScrollView代理方法的代理方法，通过此方法获取当前拖动时的contentOffset.x来判断当前的位置，然后选中相应的按钮，执行相应的动画效果。
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%s",__func__);
    //    [self.view endEditing:YES];
    //判断当前滚动的水平距离时候超过一半
    if (scrollView.contentOffset.x > ScreenWidth / 2) {
        //更新约束动画
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth / 3 + 26);
//            make.centerX.mas_equalTo(self.buttonB);
        }];
        if (_phoneString) {
            _phoneTextQuick.text = _phoneString;
        }
        //修改button按钮的状态
        [UIView animateWithDuration:0.3 animations:^{
            //强制刷新页面布局，不执行此方法，约束动画是没有用的！！！！！
            [self.buttonView layoutIfNeeded];
            self.buttonA.selected = NO;
            self.buttonB.selected = YES;
            self.buttonB.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
            self.buttonA.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
        }];
    } else {
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.buttonView).offset(AdaptationWidth(24));
        }];
        if (_phoneString) {
            _phoneTextAccount.text = _phoneString;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.buttonView layoutIfNeeded];
            self.buttonB.selected = NO;
            self.buttonA.selected = YES;
            self.buttonB.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
            self.buttonA.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)];
        }];
    }
}

/**
 创建textfield tag:(手机号码输入框)1   (密码输入框)2
 */
-(void)createTextfieldAccount{
    _phoneTextAccount = [[UITextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = [UIColor whiteColor];
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    if ([[UserInfo sharedInstance]getUserInfo].phoneName) {
        _phoneTextAccount.text = [UserInfo sharedInstance].phoneName;
    }
    [_phoneTextAccount setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    _phoneTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _phoneTextAccount.tag = 1;
    _phoneTextAccount.delegate = self;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
    [self.greenView addSubview:_phoneTextAccount];
    
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
    [lalPhone setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:14]];
    [self.greenView addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.greenView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.greenView addSubview:lineView2];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"密码"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:14]];
    [self.greenView addSubview:lalPwd];
    
    
    _pwdTextAccount = [[UITextField alloc]init];
    _pwdTextAccount.backgroundColor = [UIColor whiteColor];
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    if ([[UserInfo sharedInstance]getUserInfo].password) {
        _pwdTextAccount.text = [UserInfo sharedInstance].password;
    }
    [_pwdTextAccount setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    _pwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _pwdTextAccount.tag = 2;
    _pwdTextAccount.secureTextEntry = YES;
    _pwdTextAccount.delegate = self;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CGRectMake(0, AdaptationWidth(12.5), AdaptationWidth(28), AdaptationWidth(28));
    [secureButton setImage:[UIImage imageNamed:@"hidePwd"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"lookPwd"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _pwdTextAccount.rightView = secureButton;
    _pwdTextAccount.rightViewMode = UITextFieldViewModeAlways;
    [self.greenView addSubview:_pwdTextAccount];
    
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptationWidth(24));
        make.top.mas_equalTo(self.seperatorLine.mas_bottom).offset(20);
    }];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.greenView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.greenView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(_phoneTextAccount.mas_bottom).offset(AdaptationWidth(20));
        make.height.mas_equalTo(0.5);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptationWidth(24));
        make.top.mas_equalTo(lineView.mas_bottom).offset(AdaptationWidth(20));
    }];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.greenView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(25);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.greenView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.greenView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(_pwdTextAccount.mas_bottom).offset(AdaptationWidth(20));
        make.height.mas_equalTo(0.5);
    }];
    
}



/**
 创建textfield tag:(手机号码输入框):100
                  (验证码输入框):4
                  (获取验证码):30
 */
-(void)createTextfieldQuick{
    _phoneTextQuick = [[UITextField alloc]init];
    _phoneTextQuick.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextQuick.backgroundColor = [UIColor whiteColor];
    _phoneTextQuick.borderStyle = UITextBorderStyleNone;
    _phoneTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];

    if ([[UserInfo sharedInstance]getUserInfo].userId) {
        _phoneTextQuick.text = [UserInfo sharedInstance].phoneName;
    }
    [_phoneTextQuick setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    _phoneTextQuick.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    _phoneTextQuick.tag = 100;
    [_phoneTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextQuick.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextQuick.delegate = self;
    [self.orangeView addSubview:_phoneTextQuick];
    
    UILabel *lalPhone = [[UILabel alloc]init];
    [lalPhone setText:@"手机号"];
    [lalPhone setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPhone setFont:[UIFont systemFontOfSize:14]];
    [self.orangeView addSubview:lalPhone];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.orangeView addSubview:lineView];
    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.orangeView addSubview:lineView2];
    
    UILabel *lalPwd = [[UILabel alloc]init];
    [lalPwd setText:@"验证码"];
    [lalPwd setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lalPwd setFont:[UIFont systemFontOfSize:14]];
    [self.orangeView addSubview:lalPwd];
    
    
    
    _verificationTextQuick = [[UITextField alloc]init];
    _verificationTextQuick.backgroundColor = [UIColor whiteColor];
    _verificationTextQuick.borderStyle = UITextBorderStyleNone;
    _verificationTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.32)}];
    _verificationTextQuick.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    [_verificationTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationTextQuick.keyboardType = UIKeyboardTypeNumberPad;
    _verificationTextQuick.tag = 4;
    _verificationTextQuick.delegate = self;
    [_verificationTextQuick setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.orangeView addSubview:_verificationTextQuick];
    

    
    XCountDownButton *getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    [_orangeView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:XColorWithRGB(23, 143, 149) forState:UIControlStateNormal];
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    getVerificationCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    
    _verificationTextQuick.rightView = getVerificationCodeButton;
    _verificationTextQuick.rightViewMode = UITextFieldViewModeAlways;
    
    
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [lalPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptationWidth(24));
        make.top.mas_equalTo(self.seperatorLine.mas_bottom).offset(20);
    }];
    [_phoneTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.orangeView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(lalPhone.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(25);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.orangeView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(_phoneTextQuick.mas_bottom).offset(AdaptationWidth(20));
        make.height.mas_equalTo(0.5);
    }];
    [lalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AdaptationWidth(24));
        make.top.mas_equalTo(lineView.mas_bottom).offset(AdaptationWidth(20));
    }];
    [_verificationTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.orangeView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(lalPwd.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(25);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orangeView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.orangeView).offset(-(AdaptationWidth(24)));
        make.top.mas_equalTo(_verificationTextQuick.mas_bottom).offset(AdaptationWidth(20));
        make.height.mas_equalTo(0.5);
    }];
    
    
    
}





/**
 accountBtn     tag:(登录):10
                    (快速注册):11
                    (忘记密码):12
 */
-(void)createButtonAccount{
    loginButtonAccount = [[UIButton alloc]init];
    loginButtonAccount.frame = CGRectMake(AdaptationWidth(20), AdaptationWidth(204), AdaptationWidth(337), AdaptationWidth(50));
    loginButtonAccount.layer.cornerRadius = 4;
    loginButtonAccount.clipsToBounds = YES;
    loginButtonAccount.backgroundColor = XColorWithRGB(252, 93, 109);
    [loginButtonAccount setTitle:@"登录" forState:UIControlStateNormal];
    [loginButtonAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButtonAccount  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    loginButtonAccount.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    loginButtonAccount.tag = 10;
    [loginButtonAccount addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.greenView addSubview:loginButtonAccount];
    
    NSArray *array = @[@"快速注册",@"忘记密码?"];
    UIColor *fastRegesterBtnColor = XColorWithRGB(252, 93, 109);
    UIColor *forgetPwdColor = XColorWithRBBA(34, 58, 80, 0.48);
    NSArray *colorArr = @[fastRegesterBtnColor,forgetPwdColor];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake((AdaptationWidth(375)-AdaptationWidth(100))*i, AdaptationWidth(264), AdaptationWidth(100), AdaptationWidth(20));
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:colorArr[i] forState:UIControlStateNormal];
        btn.tag = 11 +i;
        [self.greenView addSubview:btn];
    }
}



/**
 QuickBtn    tag:(登录)20  (快速注册)21  (忘记密码)22
 */
-(void)createButtonQuick{
    UIButton *loginButtonQuick = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButtonQuick.frame = CGRectMake(AdaptationWidth(20), AdaptationWidth(204), AdaptationWidth(337), AdaptationWidth(50));
    loginButtonQuick.layer.cornerRadius = 4;
    loginButtonQuick.clipsToBounds = YES;
    loginButtonQuick.backgroundColor = XColorWithRGB(252, 93, 109);
    [loginButtonQuick setTitle:@"登录" forState:UIControlStateNormal];
    [loginButtonQuick setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButtonQuick.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(18)];
    loginButtonQuick.tag = 20;
    [loginButtonQuick addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.orangeView addSubview:loginButtonQuick];
    
    NSArray *array = @[@"快速注册",@"忘记密码?"];
    UIColor *fastRegesterBtnColor = XColorWithRGB(252, 93, 109);
    UIColor *forgetPwdColor = XColorWithRBBA(34, 58, 80, 0.48);
    NSArray *colorArr = @[fastRegesterBtnColor,forgetPwdColor];
    for (NSInteger i = 0; i<1; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((AdaptationWidth(375)-AdaptationWidth(100))*i, AdaptationWidth(264), AdaptationWidth(100), AdaptationWidth(20));
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(15)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:colorArr[i] forState:UIControlStateNormal];
        btn.tag = 21+i;
        [self.orangeView addSubview:btn];
    }
}

/**
 *   注意事项:
 *  在XIB,SB,或者是在代码中创建Button的时候,Button的样式要设置成为 Custom 样式,否则在倒计时过程中 Button 的Tittle 会闪动.
 */

//倒计时
- (void)timerFired{
    [_vericationRightBtn setTitle:[NSString stringWithFormat:@"(%@)",@(_timer)] forState:UIControlStateNormal];
    _timer -- ;
}

- (void)CloseTimer{
    [_vericationRightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _vericationRightBtn.userInteractionEnabled = YES;
    _vericationRightBtn.backgroundColor = XColorWithRGB(23, 143, 149);
    [_vericationRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timerCode invalidate];
    _timerCode = nil;
    [_timerClose invalidate];
    _timerClose = nil;
}
-(void)buttonClick:(UIButton *)btn{
    [self.view endEditing:YES];
    if (btn.tag == 10) {//登录
        if (_phoneTextAccount.text.length == 0) {
            [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
            return;
        }
        if (_pwdTextAccount.text.length == 0) {
            [self setHudWithName:@"请输入密码" Time:0.5 andType:3];
            return;
        }
        if (_phoneTextAccount.text.length != 11) {
            [self setHudWithName:@"请输入正确的手机号" Time:0.5 andType:3];
            return;
        }
        [self prepareDataWithCount:XLoginRequestSignIn];
    }else if (btn.tag == 12) {//找回密码
        ForgetPwdVC *vc = [[ForgetPwdVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
      
    }else if (btn.tag == 11){//快速注册
        RegisterVC *vc = [[RegisterVC alloc]init];
        vc.phoneName =  _phoneTextAccount.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 20) {//登录
        if (_phoneTextQuick.text.length == 0) {
            [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
            return;
        }
        if (_verificationTextQuick.text.length == 0) {
            [self setHudWithName:@"请输入短信验证码" Time:0.5 andType:3];
            return;
        }
        [self prepareDataWithCount:XLoginRequestQuick];
        
    }else if (btn.tag == 22) {//找回密码
        ForgetPwdVC *vc = [[ForgetPwdVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (btn.tag == 21){//快速注册
        RegisterVC *vc = [[RegisterVC alloc]init];
        vc.phoneName =  _phoneTextQuick.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UITextfield TextChange
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self buttonClick:loginButtonAccount];
    return YES;
}
-(CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectMake(0, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
            _phoneString = _phoneTextAccount.text;
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
    }else if (textField == _phoneTextQuick) {
        if (_phoneTextQuick.text.length >= 11) {
            _phoneTextQuick.text = [_phoneTextQuick.text substringToIndex:11];
            _phoneString = _phoneTextQuick.text;
        }
    }else if (textField == _verificationTextQuick) {
        if (_verificationTextQuick.text.length >= 6) {
            _verificationTextQuick.text = [_verificationTextQuick.text substringToIndex:6];
        }
    }
}

#pragma mark - 网络请求
- (void)setRequestParams{
    if (self.requestCount == XLoginRequestSignIn) {
        self.cmd = XUserLogin;
        
        NSString *str =[[[NSString stringWithFormat:@"%@%@",_pwdTextAccount.text,[XSessionMgr sharedInstance].challenge]MD5] uppercaseString];
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextAccount.text,@"username",str,@"password", nil];
    }else if (self.requestCount == XLoginRequestMessageCode ){
        self.cmd = XSmsAuthenticationCode;
        self.dict = @{@"phone_num":_phoneTextQuick.text,@"opt_type":@2};
    }else if (self.requestCount == XLoginRequestQuick ){
        self.cmd = XUserLogin;
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextQuick.text,@"username",_verificationTextQuick.text,@"dynamic_sms_code", nil];
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.requestCount == XLoginRequestSignIn) {
        [self setHudWithName:@"登录成功" Time:0.5 andType:0];
       
        //talkingData 数据统计
        [TalkingData onLogin:_phoneTextAccount.text type:TDAccountTypeRegistered name:@"全网贷"];
        [[UserInfo sharedInstance]savePhone:_phoneTextAccount.text password:_pwdTextAccount.text userId:response.content[@"id"] grantAuthorization:response.content[@"has_grant_authorization"]];
        if (self.isModifyPwd.integerValue == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([[UserInfo sharedInstance]getUserInfo].has_grant_authorization.integerValue == 0 && self.clientGlobalInfoModel.recomment_entry_hide.integerValue != 1) {
            XBlockExec(self.loginblock, nil);
        }
         [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
    }else if (self.requestCount == XLoginRequestMessageCode ){
        [self setHudWithName:@"验证码获取成功" Time:0.5 andType:0];
        
        _getVerificationButton.userInteractionEnabled = NO;
        [_getVerificationButton startCountDownWithSecond:60];
        [_getVerificationButton countDownChanging:^NSString *(XCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
            return title;
        }];
        [_getVerificationButton countDownFinished:^NSString *(XCountDownButton *countDownButton, NSUInteger second) {
            _getVerificationButton.userInteractionEnabled = YES;
            return @"重新获取";
        }];
    }else if (self.requestCount == XLoginRequestQuick ){
        [self setHudWithName:@"登录成功" Time:0.5 andType:0];
        [TalkingData onLogin:_phoneTextQuick.text type:TDAccountTypeRegistered name:@"全网贷"];
        [[UserInfo sharedInstance]savePhone:_phoneTextQuick.text password:nil userId:response.content[@"id"] grantAuthorization:response.content[@"has_grant_authorization"]];
        NSDictionary *dict = @{@"login":_phoneTextQuick.text};
        
        if (self.isModifyPwd.integerValue == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([[UserInfo sharedInstance]getUserInfo].has_grant_authorization.integerValue == 0 && self.clientGlobalInfoModel.recomment_entry_hide.integerValue != 1) {
            XBlockExec(self.loginblock, nil);
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Login" object:self userInfo:dict];
        
    }
}

-(void)requestFaildWithDictionary:(XResponse *)response{
    [self setHudWithName:response.errMsg Time:2 andType:1];
    if (response.errCode.integerValue ==3) {
        RegisterVC *vc = [[RegisterVC alloc]init];
        vc.phoneName =  _phoneTextQuick.text;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
