//
//  DataDetailVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/11.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "DataDetailVC.h"
#import "SuccessApplicationVC.h"
#import "XRootWebVC.h"

#import "IdentityAuthenticationVC.h"
#import "CreditInfoModel.h"
#import "ZMAuthenticationVC.h"
#import "BaseInfoVC.h"
#import "OperatorAuthenticationVC.h"
#import "AuthenticationBankVC.h"
#import "CertifiedBankVC.h"
#import "PlatformViewController.h"
#import "WorkInfoVC.h"
#import "ApplyProductModel.h"
#import "AuthorizationVC.h"
#import "ApplicantManVC.h"

typedef NS_ENUM(NSInteger ,RequiredType) {
    IDENTITYCARD = 1,
    ZMXY,
    BASICINFO,
    JXLINFO,
    CREDITINFO,
    LOANINFO,
    BUSINESSINFO,
    APPLICANT,
    
};
typedef NS_ENUM(NSInteger , DataDetailRequest) {
    DataDetailRequestGetCreditInfo,
    DataDetailRequestApplyLoan,
};
@interface DataDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic, strong) ApplyProductModel *applyProductModel;
@end

@implementation DataDetailVC
{
    NSArray *requiredArry;
    UICollectionView *collectionView;
    NSString *cooperationUrl;//合作方式连接
}
 static NSString * identifier = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:DataDetailRequestGetCreditInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Refresh) name:@"Refresh" object:nil];
}
-(void)Refresh
{
    [self prepareDataWithCount:DataDetailRequestGetCreditInfo];
}
-(void)setBackNavigationBarItem
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"资料完善" forState:UIControlStateNormal];
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


- (void)setData{
    requiredArry =  [self.productModel.apply_required_data componentsSeparatedByString:@","];
}
- (void)setUI{
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"dataDetail_low"]];
    [self.view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:@"您的信用评级太低"];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    [labDetail setText:@"完成以下资料后方可完成申请"];
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [self.view addSubview:labDetail];
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(32));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(48));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(AdaptationWidth(72), AdaptationWidth(73));
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    //注册一个collectionCell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(6));
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    
    UIButton *btnLoan = [[UIButton alloc]init];
    [btnLoan setTitle:@"完成申请" forState:UIControlStateNormal];
    [btnLoan setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnLoan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLoan  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btnLoan addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLoan];
    [btnLoan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
    
    
}

#pragma  mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return requiredArry.count;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(AdaptationWidth(80), AdaptationWidth(81));
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RequiredType type = [requiredArry[indexPath.row]integerValue];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc]init];
    }
    UIImageView *image = [[UIImageView alloc]init];
    [cell.contentView addSubview:image];

    UIImageView *authImage = [[UIImageView alloc]init];
    [cell.contentView addSubview:authImage];

    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [cell.contentView addSubview:lab];
    switch (type) {
        case IDENTITYCARD:
            [image setImage:[UIImage imageNamed:@"myData_identity"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconCardInfoP"]];
            [lab setText:@"身份认证"];
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case BASICINFO:
            [image setImage:[UIImage imageNamed:@"myData_baseInfo"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconBaseInfoP"]];
            [lab setText:@"基本信息认证"];
            if (self.creditInfoModel.base_info_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case ZMXY:
            [image setImage:[UIImage imageNamed:@"myData_ZMXY"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconZhimaInfoP"]];
            [lab setText:@"芝麻信息认证"];
            if (self.creditInfoModel.zhima_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_authorization"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case JXLINFO:
            [image setImage:[UIImage imageNamed:@"myData_YYS"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconOperatorInfoP"]];
            [lab setText:@"运营商认证"];
            if (self.creditInfoModel.operator_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case CREDITINFO:
            [image setImage:[UIImage imageNamed:@"myData_bank"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconBankInfoP"]];
            [lab setText:@"银行卡"];
            if (self.creditInfoModel.bank_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case LOANINFO:
            [image setImage:[UIImage imageNamed:@"myData_JieDaiInfo"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconLoanPlatformP"]];
            [lab setText:@"借贷平台信息"];
            if (self.creditInfoModel.loan_info_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case BUSINESSINFO:
            [image setImage:[UIImage imageNamed:@"myData_workInfo"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconWorkInfoP"]];
            [lab setText:@"工作信息"];
            if (self.creditInfoModel.company_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case APPLICANT:
            [image setImage:[UIImage imageNamed:@"iconAuthorizationP"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconIdInfoP"]];
            [lab setText:@"申请人资质"];
            if (self.creditInfoModel.applicant_qualification_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        default:
            break;
    }

    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(cell.contentView);
        make.top.mas_equalTo(cell.contentView);
        make.bottom.mas_equalTo(lab.mas_top).offset(1);
    }];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(cell.contentView);

    }];
    [authImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(image);
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    RequiredType type = [requiredArry[indexPath.row]integerValue];
    switch (type) {
        case IDENTITYCARD:{
            
            IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
            vc.creditInfoModel = self.creditInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case BASICINFO:
        {
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                BaseInfoVC *vc = [[BaseInfoVC alloc]init];
                vc.creditInfoModel = self.creditInfoModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }

        }
            break;
        case ZMXY:{
            if (self.creditInfoModel.zhima_status.integerValue == 1) {
                [self setHudWithName:@"芝麻信用已认证" Time:0.5 andType:3];
                return;
            }
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                ZMAuthenticationVC *vc = [[ZMAuthenticationVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
            
        }
            break;
        case JXLINFO:
        {
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                if (self.creditInfoModel.base_info_status.integerValue == 1) {
                    OperatorAuthenticationVC *vc = [[OperatorAuthenticationVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self setHudWithName:@"请先完成基本信息认证" Time:0.5 andType:3];
                }
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
            
        }
            break;
        case CREDITINFO:
        {
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                if (self.creditInfoModel.bank_status.integerValue == 1) {
                    CertifiedBankVC *vc = [[CertifiedBankVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    AuthenticationBankVC *vc = [[AuthenticationBankVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
        }
            break;
        case LOANINFO:
        {
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                PlatformViewController *vc = [[PlatformViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
        }
            
            break;
        case BUSINESSINFO:
        {
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                WorkInfoVC *vc = [[WorkInfoVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
        }
            
            break;
        case APPLICANT:{
           if (self.creditInfoModel.identity_status.integerValue == 1) {
               ApplicantManVC *vc = [[ApplicantManVC alloc]init];
               [self.navigationController pushViewController:vc animated:YES];
           }else{
               [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
           }
        }
            break;
        default:
            break;
    }
}
//用户资料是否认证完成
- (BOOL)requiredData{

    for (NSString *str in requiredArry) {
        switch (str.integerValue) {
            case IDENTITYCARD:
                if( self.creditInfoModel.identity_status.integerValue == 0){
                    return NO;
                }
                break;
            case ZMXY:
                if( self.creditInfoModel.zhima_status.integerValue == 0){
                    return NO;
                }
                break;
            case BASICINFO:
                if( self.creditInfoModel.base_info_status.integerValue == 0){
                    return NO;
                }
                break;
            case JXLINFO:
                if( self.creditInfoModel.operator_status.integerValue == 0){
                    return NO;
                }
                break;
            case CREDITINFO:
                if( self.creditInfoModel.bank_status.integerValue == 0){
                    return NO;
                }
                break;
            case LOANINFO:
                if( self.creditInfoModel.loan_info_status.integerValue == 0){
                    return NO;
                }
                break;
            case BUSINESSINFO:
                if( self.creditInfoModel.company_status.integerValue == 0){
                    return NO;
                }
                break;
            case APPLICANT:
                if( self.creditInfoModel.applicant_qualification_status.integerValue == 0){
                    return NO;
                }
                break;
                
            default:
                break;
        }
    }
    return YES;
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (![self requiredData]) {
        [self setHudWithName:@"用户信息不完善，无法申请贷款" Time:1 andType:0];
        return;
    }
    if ([[UserInfo sharedInstance]getUserInfo].has_grant_authorization.integerValue == 2) {//判断是否授权
        [XAlertView alertWithTitle:@"温馨提示" message:@"您当前处于拒绝授权状态，想要获得更多服务,请前往修改状态。" cancelButtonTitle:@"取消" confirmButtonTitle:@"前往授权" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                AuthorizationVC *vc = [[AuthorizationVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    [self prepareDataWithCount:DataDetailRequestApplyLoan];
}

#pragma mark - wangluo
- (void)setRequestParams{
    switch (self.requestCount) {
        case DataDetailRequestGetCreditInfo:
            self.cmd = XGetCreditInfo;
            self.dict = @{};
            break;
        case DataDetailRequestApplyLoan:{
            self.cmd = XApplyLoan;
            if(self.productModel.cooperation_type.integerValue == 3){
                self.dict = @{@"loan_pro_id":self.productModel.loan_pro_id,
                              @"apply_loan_amount":self.apply_loan_amount,
                              @"apply_loan_days":self.apply_loan_days
                              };
            }else{
                self.dict = @{@"loan_pro_id":self.productModel.loan_pro_id};
            }
           
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case DataDetailRequestGetCreditInfo:
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.content];
            [self setData];
            [self setUI];
            [collectionView reloadData];
            break;
        case DataDetailRequestApplyLoan:{
            
            self.applyProductModel = [ApplyProductModel mj_objectWithKeyValues:response.content];
            cooperationUrl = response.content[@"cooperation_url"];
            //talkingdata
            [TalkingData trackEvent:@"完成申请按钮"];
            [self pushControllerView];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 跳转界面
- (void)pushControllerView{
    NSInteger row = self.productModel.cooperation_type.integerValue;
    switch (row) {
        case 1:{//落地页
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = cooperationUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{//注册信息对接
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = cooperationUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{//商户后台
            SuccessApplicationVC *vc  =[[SuccessApplicationVC alloc]init];
            vc.applyProductModel = self.applyProductModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel alloc]init];
    }
    return _creditInfoModel;
}
- (ApplyProductModel *)applyProductModel{
    if (!_applyProductModel) {
        _applyProductModel  = [[ApplyProductModel alloc]init];
    }
    return _applyProductModel;
}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refresh" object:nil];
//}
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
