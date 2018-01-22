//
//  IdentityAuthenticationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/21.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "IdentityAuthenticationVC.h"
#import "UDIDSafeAuthEngine.h"
#import "UDIDSafeDataDefine.h"
//#import "ZMCreditSDK.framework/Headers/ALCreditService.h"
#import "IdCardModel.h"
#import "AuthorizationView.h"
#import "XRootWebVC.h"

typedef NS_ENUM(NSUInteger, AdultIdentityVerifyRequest) {
    AdultIdentityVerifySubmitInfo,//提交姓名与身份证号
    AdultIdentityVerifyRequestNotificationInfo,//请求订单号和回调地址
    
};
@interface IdentityAuthenticationVC ()<UDIDSafeAuthDelegate>
@property (nonatomic,strong)UIButton *verifyButton;
@property (nonatomic,strong)UIImageView *frontImageV;
@property (nonatomic,strong)UIImageView *backImageV;
@property (nonatomic,strong)UILabel *frontLabel;
@property (nonatomic,strong)UILabel *backLabel;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *detailLab;
//@property (nonatomic,retain)AuthorizationBtnOnClick AuthorizationBtnOnClick;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation IdentityAuthenticationVC
{
    float _standardPoint;//标准分，用于比较相似度，合格后才上传姓名与身份证号给后台，开始芝麻信用认证，否则提示认证失败
}
-(void)setBackNavigationBarItem
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"身份信息" forState:UIControlStateNormal];
    [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];\
    button.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(28), 0, -AdaptationWidth(28));
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIView *lineview  = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
    lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
    [button addSubview:lineview];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.creditInfoModel.identity_status.integerValue == 1) {//判断是否认证过
        [self setStatusUI];
    }else{
        [self setupView];
    }
}
- (void)setStatusUI{
    UILabel *nameLab = [UILabel new];
    nameLab.text = self.creditInfoModel.true_name;
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
    nameLab.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    [self.view addSubview:nameLab];
    
    UILabel *sex = [UILabel new];
    NSString *car = [self.creditInfoModel.identity_card stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"***********"];
    sex.text = [NSString stringWithFormat:@"%@，%@",self.creditInfoModel.sex,car];
    sex.font = [UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)];
    sex.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    [self.view addSubview:sex];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(38));
    }];
    [sex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(nameLab.mas_bottom).offset(AdaptationWidth(8));
    }];
}
-(void)setupView{
    
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.detailLab];
    [self.view addSubview:self.frontImageV];
    [self.view addSubview:self.frontLabel];
    [self.view addSubview:self.backImageV];
    [self.view addSubview:self.backLabel];
    [self.view addSubview:self.verifyButton];
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.authView];
    if (self.creditInfoModel.identity_status.integerValue == 1) {//判断是否认证过
        self.authView.hidden = YES;
    }
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(32));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
    }];
    [_frontImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(_detailLab.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(159));
        make.height.mas_equalTo(AdaptationWidth(100));
    }];

    [_backImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(_detailLab.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(159));
        make.height.mas_equalTo(AdaptationWidth(100));
    }];

    [_frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_frontImageV.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backImageV.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(_backImageV);
    }];
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_verifyButton.mas_top);
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    [_verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(20));
        make.top.mas_equalTo(_backImageV.mas_bottom).offset(AdaptationWidth(105));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(20));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
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
//getter方法
-(UIImageView *)frontImageV{
    if (!_frontImageV) {
        _frontImageV = [UIImageView new];
        _frontImageV.contentMode = UIViewContentModeScaleAspectFit;
        _frontImageV.image = [UIImage imageNamed:@"myData_IdCard"];
    }
    return _frontImageV;
}

-(UIImageView *)backImageV{
    if (!_backImageV) {
        _backImageV = [UIImageView new];
        _backImageV.contentMode = UIViewContentModeScaleAspectFit;
        _backImageV.image = [UIImage imageNamed:@"myData_BlackIdCard"];
    }
    return _backImageV;
}

-(UILabel *)frontLabel{
    if (!_frontLabel) {
        _frontLabel = [UILabel new];
        _frontLabel.text = @"身份证正面";
        _frontLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:AdaptationWidth(12)];
        _frontLabel.textColor = XColorWithRBBA(34, 58, 80, 0.32);
        _frontLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _frontLabel;
}


-(UILabel *)backLabel{
    if (!_backLabel) {
        _backLabel = [UILabel new];
        _backLabel.text = @"身份证反面";
        _backLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:AdaptationWidth(12)];
        _backLabel.textColor = XColorWithRBBA(34, 58, 80, 0.32);
        _backLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _backLabel;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"身份信息认证";
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
        _titleLab.textColor = XColorWithRBBA(34, 58, 80, 0.8);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}


-(UILabel *)detailLab{
    if (!_detailLab) {
        _detailLab = [UILabel new];
        _detailLab.numberOfLines = 0;
        _detailLab.text = @"您只需将身份证正、反面及您的正脸通过摄像头即可完成认证。";
        _detailLab.font = [UIFont fontWithName:@"PingFang-SC-Light" size:AdaptationWidth(16)];
        _detailLab.textColor = XColorWithRBBA(34, 58, 80, 0.8);
//        _detailLab.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLab;
}
-(UIButton *)verifyButton{
    if (!_verifyButton) {
        _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyButton.backgroundColor = XColorWithRGB(252, 93, 109);
        _verifyButton.layer.cornerRadius = AdaptationWidth(5);
        _verifyButton.clipsToBounds = YES;
        [_verifyButton setTitle:@"进行认证" forState:UIControlStateNormal];
        [_verifyButton setTitle:@"进行认证" forState:UIControlStateHighlighted];
        [_verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_verifyButton setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [_verifyButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyButton;
}

-(void)start{
    
    //talkingdata
    [TalkingData trackEvent:@"进行身份认证按钮"];
    if (!self.authView.AgreementBtn.selected && self.creditInfoModel.identity_status.integerValue == 0) {
        [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {}];
        return;
    }
    [self prepareDataWithCount:AdultIdentityVerifyRequestNotificationInfo];
    
}
-(void)launchUDSDKWithDictionary:(NSDictionary *)dict{
    
    UDIDSafeAuthEngine * engine = [[UDIDSafeAuthEngine alloc]init];
    engine.delegate = self;
    //秘钥
    engine.authKey = [dict objectForKey:@"auth_key"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"auth_key"]] : @"";;
    // 订单号
    engine.outOrderId = [dict objectForKey:@"partner_order_id"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"partner_order_id"]] : @"";
    //回调地址
    engine.notificationUrl =[dict objectForKey:@"notification_url"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"notification_url"]] : @"";
    engine.showInfo = YES;
    //需要传入当前的 UIViewController
    [engine startIdSafeWithUserName:@"" IdentityNumber:@"" InViewController:self];
    
    
}


//4. 回调方法:
- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo{
    MyLog(@"Finish");
    MyLog(@"result-->%lu",(unsigned long)result);
    MyLog(@"userinfo-->%@",userInfo);
    
    
    if (result == UDIDSafeAuthResult_Done) {
        
        if ([[userInfo objectForKey:@"be_idcard"] floatValue] >= _standardPoint) {
            //保存用户的最新信息
//            CCXUser *user = [self getSeccsion];
//            user.identityCard = userInfo[@"id_no"];
//            user.customName = userInfo[@"id_name"];
//            [self saveSeccionWithUser:user];
            
//            _userName = [userInfo objectForKey:@"id_name"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id_name"]] : @"";
//            _identityCardNum = [userInfo objectForKey:@"id_no"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"id_no"]] : @"";
//            _gender =  [userInfo objectForKey:@"flag_sex"] ? [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"flag_sex"]] : @"";
            
            [[IdCardModel sharedInstance] mj_setKeyValues:userInfo];
            
            [self prepareDataWithCount:AdultIdentityVerifySubmitInfo];
        }else{
            [self setHudWithName:@"身份认证失败，请重新认证！" Time:1.0 andType:0];
        }
        
        
    }else{
        [self setHudWithName:@"身份认证失败，请重新认证！" Time:1.0 andType:0];
    }
}


-(void)setRequestParams
{
    if (self.requestCount == AdultIdentityVerifyRequestNotificationInfo) {
        self.cmd = XGetIdCardVerifyParams;
        self.dict = @{};
        
    }else if (self.requestCount == AdultIdentityVerifySubmitInfo) {
        self.cmd = XPostIdCardInfo;
        self.dict = @{@"identity_card":[IdCardModel sharedInstance].id_no,@"true_name":[IdCardModel sharedInstance].id_name,@"gender":[IdCardModel sharedInstance].flag_sex};
        
    }
}

- (void)requestSuccessWithDictionary:(XResponse *)response
{
    if (self.requestCount == AdultIdentityVerifyRequestNotificationInfo) {
        _standardPoint = [response.content objectForKey:@"score"] ? [[response.content objectForKey:@"score"] floatValue] : 0.00;
        [self launchUDSDKWithDictionary:response.content];
    }else if (self.requestCount == AdultIdentityVerifySubmitInfo) {
        [self setHudWithName:@"身份证认证成功" Time:0.5 andType:3];
        [self popToCenterController];
    }
}

-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
- (void)popToCenterController
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
