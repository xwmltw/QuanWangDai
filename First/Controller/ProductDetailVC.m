//
//  ProductDetailVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/10.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ProductDetailVC.h"
#import "DataDetailVC.h"
#import "CreditInfoModel.h"
#import "XRootWebVC.h"
#import "SuccessApplicationVC.h"
#import "UITextField+ExtendRange.h"
#import "XTextField.h"
#import "ProductDetailTableViewCell.h"
#import "ApplyProductModel.h"
#import "AuthorizationVC.h"
typedef NS_ENUM(NSInteger ,ProductDetailModule){
    ProductDetailMaterial,
    ProductDetailCondition,
    ProductDetailFlow,
};
typedef NS_ENUM(NSInteger ,ProductDetailRequest) {
    ProductDetailRequestInfo,
    ProductDetailRequestStaticInfo,
    ProductDetailRequestApplyLoan,
};
typedef NS_ENUM(NSInteger ,RequiredType) {
    IDENTITYCARD = 1,
    BASICINFO,
    ZMXY,
    JXLINFO,
    CREDITINFO,
    LOANINFO,
    BUSINESSINFO,
    APPLICANT,
    
};
@interface ProductDetailVC ()<UITextFieldDelegate>

@property (nonatomic ,copy) UILabel *headTitle;
@property (nonatomic, strong) ProductModel *detailModel;
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic, strong) ApplyProductModel *applyProductModel;
@property (nonatomic,strong) UILabel *cellLabel;
@end

@implementation ProductDetailVC
{
    NSMutableArray *moduleArry;
    NSMutableArray *materialArry, *conditionArry, *flowArry;
    XTextField *tfMoney;
    XTextField *tfDate;
    NSString *cooperationUrl;//合作方式连接
    UIButton *btnLoan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"贷款详情页"];
    [self prepareDataWithCount:ProductDetailRequestInfo];

    btnLoan = [[UIButton alloc]init];
    [btnLoan setTitle:@"申请借款" forState:UIControlStateNormal];
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
- (void)getData{
    
    moduleArry = [NSMutableArray array];
 
    if (self.detailModel.loan_need_data.count) {
        materialArry = [NSMutableArray arrayWithArray:self.detailModel.loan_need_data];
        [moduleArry addObject:@(ProductDetailMaterial)];
    }

    if (self.detailModel.loan_condition.count) {
        conditionArry = [NSMutableArray arrayWithArray:self.detailModel.loan_condition];
        [moduleArry addObject:@(ProductDetailCondition)];
    }
    
    if (self.detailModel.loan_process.count) {
        flowArry = [NSMutableArray arrayWithArray:self.detailModel.loan_process];
        [moduleArry addObject:@(ProductDetailFlow)];
    }
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self creatHeadView];
    self.tableView.mj_header = nil;
    
    if (self.detailModel.cooperation_type.integerValue == 3) {//商户后台显示
        self.tableView.tableFooterView = [self creatFooterView];
    }
    
}
#pragma mark- tableView
- (UIView *)creatHeadView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(269))];
    view.backgroundColor = [UIColor clearColor];
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setCornerValue:AdaptationWidth(16)];
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = AdaptationWidth(0.5);
    image.layer.borderColor = XColorWithRGB(233, 233, 235).CGColor;
    [image sd_setImageWithURL:[NSURL URLWithString:self.detailModel.loan_pro_logo_url]];
//    [image setImage:[UIImage imageNamed:@"alldaikuan"]];
    [view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:self.detailModel.loan_pro_name];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(24)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
//    labDetail.translatesAutoresizingMaskIntoConstraints  = YES;
    labDetail.autoresizingMask =UIViewAutoresizingFlexibleRightMargin;
    labDetail.textAlignment = NSTextAlignmentLeft;
    labDetail.numberOfLines = 2;
    [labDetail setText:self.detailModel.loan_pro_slogan];
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [view addSubview:labDetail];
    
    UIView *hotView = [[UIView alloc]init];
    [hotView setCornerValue:AdaptationWidth(2)];
    hotView.backgroundColor = XColorWithRGB(253, 244, 232);
    [view addSubview:hotView];
    
    UILabel *hotLab = [[UILabel alloc]init];
    if (_detailModel.be_staged.integerValue == 1) {
        [hotLab setText:@"分期还款"];
    }else{
        [hotLab setText:@"到期还款"];
    }
    [hotLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
    [hotLab setTextColor:XColorWithRGB(255, 176, 53)];
    [view addSubview:hotLab];
    
    UILabel *cityLab = [[UILabel alloc]init];
    if (self.detailModel.run_address_name.length > 0) {
        [cityLab setText:[NSString stringWithFormat:@"经营区域:%@",self.detailModel.run_address_name]];
    }else{
        [cityLab setText:[NSString stringWithFormat:@""]];
    }
    [cityLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [cityLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
    [view addSubview:cityLab];
    
   
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(view).offset(AdaptationWidth(24));
        make.width.height.mas_equalTo(AdaptationWidth(64));
    }];
    
    if (self.detailModel.run_address_name.length == 0) {
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image.mas_right).offset(AdaptationWidth(16));
            make.width.mas_lessThanOrEqualTo(AdaptationWidth(164));
            make.centerY.mas_equalTo(image);
        }];
    }else{
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image.mas_right).offset(AdaptationWidth(16));
            make.width.mas_lessThanOrEqualTo(AdaptationWidth(164));
            make.top.mas_equalTo(image.mas_top);
        }];
    }
    
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.width.mas_lessThanOrEqualTo(AdaptationWidth(327));
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(16));
    }];
    
    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(labTitle.mas_right).offset(AdaptationWidth(8));
        make.centerY.mas_equalTo(labTitle);
        make.width.mas_equalTo(AdaptationWidth(69));
        make.height.mas_equalTo(AdaptationWidth(26));
    }];
    [hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(hotView);
    }];
    
    [cityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(image.mas_right).offset(AdaptationWidth(16));
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(8));
    }];
    
    UIView *frameView = [[UIView alloc]init];
    [frameView setCornerValue:AdaptationWidth(2)];
    [frameView setBorderColor:XColorWithRGB(7, 137, 133)];
    [view addSubview:frameView];
    
    UILabel *labMoney = [[UILabel alloc]init];
    labMoney.textAlignment = NSTextAlignmentCenter;
    [labMoney setText:self.detailModel.loan_credit_str];
    labMoney.numberOfLines = 0;
    [labMoney setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(18)]];
    [labMoney setTextColor:XColorWithRGB(7, 137, 133)];
    [frameView addSubview:labMoney];
    
    UILabel *labMoneyD = [[UILabel alloc]init];
    labMoneyD.textAlignment = NSTextAlignmentCenter;
    [labMoneyD setText:@"可贷额度 (元)"];
    [labMoneyD setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [labMoneyD setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [frameView addSubview:labMoneyD];
    
    UIView *lineview  = [[UIView alloc] init];
    lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
    [frameView addSubview:lineview];
    
    UILabel *labDate = [[UILabel alloc]init];
    labDate.textAlignment = NSTextAlignmentCenter;
    [labDate setText:self.detailModel.loan_deadline_str];
    labDate.numberOfLines = 0;
    [labDate setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(18)]];
    [labDate setTextColor:XColorWithRGB(7, 137, 133)];
    [frameView addSubview:labDate];
    
    UILabel *labDateD = [[UILabel alloc]init];
    labDateD.textAlignment = NSTextAlignmentCenter;
    if (_detailModel.loan_deadline_type.integerValue == 1) {
        [labDateD setText:@"借款期限 (天)"];
    }else{
        [labDateD setText:@"借款期限 (月)"];
    }
    
    [labDateD setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [labDateD setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [frameView addSubview:labDateD];
    
    UIView *lineview1  = [[UIView alloc] init];
    lineview1.backgroundColor  = XColorWithRGB(233, 233, 235);
    [frameView addSubview:lineview1];
    
    
    UILabel *labRate = [[UILabel alloc]init];
    labRate.textAlignment = NSTextAlignmentCenter;
    labRate.numberOfLines = 0;
    if (self.detailModel.loan_rate.length > 5) {
        NSString *substring = [self.detailModel.loan_rate substringToIndex:5];
        [labRate setText:[NSString stringWithFormat:@"%@%%",substring]];
    }else{
        [labRate setText:[NSString stringWithFormat:@"%@%%",self.detailModel.loan_rate]];
    }
    [labRate setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(18)]];
    [labRate setTextColor:XColorWithRGB(7, 137, 133)];
    [frameView addSubview:labRate];
    
    UILabel *labRateD = [[UILabel alloc]init];
    labRateD.textAlignment = NSTextAlignmentCenter;
    switch ([_detailModel.loan_rate_type integerValue]) {
        case 1:
            [labRateD setText:@"参考日利率"];
            break;
        case 2:
            [labRateD setText:@"参考月利率"];
            break;
        case 3:
            [labRateD setText:@"参考年利率"];
            break;
            
        default:
            break;
    }
    [labRateD setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [labRateD setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [frameView addSubview:labRateD];
    
    if (self.detailModel.loan_year_rate.intValue > 36) {
        
        UILabel *labbubble = [[UILabel alloc]init];
        labbubble.textAlignment = NSTextAlignmentCenter;
        [labbubble setText:@"浮动利率"];
        [labbubble setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [labbubble setTextColor:XColorWithRGB(7, 137, 133)];
        [frameView addSubview:labbubble];
        labRate.hidden = YES;
        labRateD.hidden = YES;
        
        [labbubble mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(frameView);
            make.width.mas_equalTo(AdaptationWidth(343/3));
            make.centerY.mas_equalTo(frameView);
        }];
    }
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(frameView.mas_bottom);
    }];
    
    [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(343));
        
    }];
    
    [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.left.mas_equalTo(frameView);
        make.top.mas_equalTo(frameView).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(labMoneyD.mas_top).offset(-AdaptationWidth(8));
    }];
    [labMoneyD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.height.mas_equalTo(17);
        make.left.mas_equalTo(frameView);
        make.bottom.mas_equalTo(frameView.mas_bottom).offset(-AdaptationWidth(16));
    }];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(AdaptationWidth(16));
        make.left.mas_equalTo(labMoney.mas_right);
        make.centerY.mas_equalTo(frameView);
    }];
    
    [labDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.centerX.mas_equalTo(frameView);
        make.top.mas_equalTo(frameView).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(labDateD.mas_top).offset(-AdaptationWidth(8));
    }];
    [labDateD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.centerX.mas_equalTo(labDate);
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(frameView.mas_bottom).offset(-AdaptationWidth(16));
    }];
    
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(AdaptationWidth(16));
        make.left.mas_equalTo(labDate.mas_right);
        make.centerY.mas_equalTo(frameView);
    }];
    
    [labRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(frameView);
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.top.mas_equalTo(frameView).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(labRateD.mas_top).offset(-AdaptationWidth(8));
    }];
    [labRateD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(labRate);
        make.width.mas_equalTo(AdaptationWidth(343/3));
        make.height.mas_equalTo(17);
        make.bottom.mas_equalTo(frameView.mas_bottom).offset(-AdaptationWidth(16));
        
    }];
    

    
    
    return view;
}
- (UIView *)creatFooterView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(226))];
    view.backgroundColor = [UIColor clearColor];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(233, 233, 235);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(view).offset(AdaptationWidth(16));
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *labDescribe = [[UILabel alloc]init];
//    NSArray *arrcredit = [self.detailModel.loan_credit_str componentsSeparatedByString:@"~"];
    [labDescribe setText:[NSString stringWithFormat:@"想借多少 (%@元)",self.detailModel.loan_credit_str]];
    [labDescribe setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(14)]];
    [labDescribe setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labDescribe];
    
    UILabel *labDescribe2 = [[UILabel alloc]init];
//    NSArray *arrdead = [self.detailModel.loan_deadline_str componentsSeparatedByString:@"~"];
    if (_detailModel.loan_deadline_type.integerValue == 1) {
        [labDescribe2 setText:[NSString stringWithFormat:@"想借多久 (%@天)",self.detailModel.loan_deadline_str]];
    }else{
        [labDescribe2 setText:[NSString stringWithFormat:@"想借多久 (%@月)",self.detailModel.loan_deadline_str]];
    }
    
    [labDescribe2 setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(14)]];
    [labDescribe2 setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labDescribe2];
    
    UILabel *yuan = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    [yuan setText:@"元"];
    [yuan setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    [yuan setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
    tfMoney = [[XTextField alloc]init];
    tfMoney.tag = 100;
    tfMoney.backgroundColor = XColorWithRGB(248, 248, 250);
    [tfMoney setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    tfMoney.borderStyle = UITextBorderStyleNone;
    tfMoney.placeholder = self.detailModel.loan_credit_str;
    [tfMoney setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    tfMoney.clearsOnBeginEditing = YES;
    tfMoney.keyboardType = UIKeyboardTypeDecimalPad;
    tfMoney.delegate = self;
//    tfMoney.textAlignment = NSTextAlignmentCenter;
    tfMoney.rightView = yuan;
    tfMoney.rightViewMode = UITextFieldViewModeAlways;
    tfMoney.text = [NSString stringWithFormat:@"%.f",(self.detailModel.loan_max_credit.integerValue*0.01)];
    
//    [tfMoney setSelectedRange:NSMakeRange(2, tfMoney.text.length)];
//    NSMutableAttributedString * pointMut = [[NSMutableAttributedString alloc] initWithString:self.detailModel.loan_max_credit];
//    [pointMut setAttributes:@{NSForegroundColorAttributeName: XColorWithRBBA(34, 58, 80, 0.8),
//                              NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]} range:NSMakeRange(16, self.detailModel.loan_max_credit.length)];
//    tfMoney.attributedText = pointMut;
    [view addSubview:tfMoney];
    
    UILabel *tian = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    if (_detailModel.loan_deadline_type.integerValue == 1) {
        [tian setText:@"天"];
    }else{
        [tian setText:@"月"];
    }
    [tian setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    [tian setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
    tfDate = [[XTextField alloc]init];
    tfDate.text  = self.detailModel.loan_max_deadline;
    tfDate.tag = 101;
    tfDate.backgroundColor = XColorWithRGB(248, 248, 250);
    [tfDate setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    tfDate.borderStyle = UITextBorderStyleNone;
    tfDate.placeholder = self.detailModel.loan_deadline_str;
    [tfDate setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    tfDate.clearsOnBeginEditing = YES;
    tfDate.keyboardType = UIKeyboardTypeDecimalPad;
    tfDate.delegate = self;
//    tfDate.textAlignment = NSTextAlignmentCenter;
    tfDate.rightView = tian;
    tfDate.rightViewMode = UITextFieldViewModeAlways;
    [view addSubview:tfDate];
    
 
    
    [labDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(line).offset(AdaptationWidth(16));
    }];
    [tfMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(labDescribe.mas_bottom).offset(AdaptationWidth(8));
        make.width.mas_equalTo(AdaptationWidth(327));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    
    
    [labDescribe2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfDate);
        make.top.mas_equalTo(tfMoney.mas_bottom).offset(AdaptationWidth(32));
    }];
    [tfDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(labDescribe2.mas_bottom).offset(AdaptationWidth(8));
        make.width.mas_equalTo(AdaptationWidth(327));
        make.height.mas_equalTo(AdaptationWidth(45));
    }];
    
    
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = [moduleArry[section]integerValue];
    switch (row) {
        case ProductDetailMaterial:
            
            return materialArry.count;
            break;
        case ProductDetailCondition:
            
            return conditionArry.count;
            break;
        case ProductDetailFlow:
            
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return moduleArry.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    
    _headTitle = [[UILabel alloc]init];
    [_headTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
    [_headTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:_headTitle];
    
    
    
    NSInteger row = [moduleArry[section]integerValue];
    switch (row) {
        case ProductDetailMaterial:{
            [self.headTitle setText:@"借款所需材料"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.centerY.mas_equalTo(view);
            }];
        }
            break;
        case ProductDetailCondition:{
            [self.headTitle setText:@"申请条件"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.top.mas_equalTo(view).offset(AdaptationWidth(28));
            }];
        }
            break;
        case ProductDetailFlow:{
            [self.headTitle setText:@"申请流程"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.top.mas_equalTo(view).offset(AdaptationWidth(28));
            }];
        }
            break;
            
        default:
            break;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
//    return AdaptationWidth(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger row = [moduleArry[section]integerValue];
    switch (row) {
        case ProductDetailMaterial:{
             return AdaptationWidth(50);
        }
            break;
        case ProductDetailCondition:{
             return AdaptationWidth(60);
        }
            break;
        case ProductDetailFlow:{
             return AdaptationWidth(60);
        }
            break;
        default:
            break;
    }
    return AdaptationWidth(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"detailCell";
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    
//    }
    ProductDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductDetailTableViewCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [moduleArry[indexPath.section]integerValue];
    switch (row) {
        case ProductDetailMaterial:{
            NSString *cellstring = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,materialArry[indexPath.row]];
            [cell setIntroductionText:cellstring];
        }
            break;
        case ProductDetailCondition:{
            NSString *cellstring = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,conditionArry[indexPath.row]];
            [cell setIntroductionText:cellstring];
        }
            break;
        case ProductDetailFlow:{
            NSString *cellstring = [NSString stringWithFormat:@"%@",flowArry.firstObject];
            for (int i = 1 ; i < flowArry.count; i++) {
                cellstring = [cellstring stringByAppendingString:[NSString stringWithFormat:@"  ->  %@",flowArry[i]]];
            }
            [cell setIntroductionText:cellstring];
        }
            break;
        default:
            break;
    }
    return cell;
}
#pragma mark - textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
//      [textField resignFirstResponder];
    if (!([textField.text rangeOfString:@"."].location == NSNotFound)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"仅能输入整数" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
        [alert show];
        textField.text = @"";
        
        return;
    }
    if ( textField.tag == 100)
    {
        if(textField.text.integerValue *100 > self.detailModel.loan_max_credit.integerValue){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"借款金额不能超过最大值" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            
            textField.text = @"";
            
            return;
        }
        if([textField.text integerValue] *100 < [self.detailModel.loan_min_credit integerValue ] ){

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"借款金额不能低于最小值" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            textField.text = @"";
            return;
        }

    }
    if ( textField.tag == 101)
    {
        if(self.detailModel.loan_max_deadline.integerValue < textField.text.integerValue  ){
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"借款期限不能超过最大值" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            textField.text = @"";
        
            return;
        }
        if(self.detailModel.loan_min_deadline.integerValue > textField.text.integerValue ){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"借款期限不能低于最小值" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
            [alert show];
            textField.text = @"";
           
            return;
        }
    }
}
- (BOOL)requiredData{
    
    NSArray *arry = [self.detailModel.apply_required_data componentsSeparatedByString:@","];
    for (NSString *str in arry) {
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
    
    //点击按钮后先取消之前的操作，再进行需要进行的操作
    btnLoan.enabled =NO;
    [self performSelector:@selector(changeButtonStatus:)withObject:nil afterDelay:2.0f];//防止重复点击
    
    if (self.detailModel.cooperation_type.integerValue == 3) {//商户后台显示
        if (!tfDate.text.length || !tfMoney.text.length) {
            [self setHudWithName:@"请输入想借金额和想借期限" Time:0.5 andType:1];
            return;
        }
    }
    
    //talkingdata
    [TalkingData trackEvent:@"申请借款按钮"];
    [self prepareDataWithCount:ProductDetailRequestStaticInfo];
   
}
-(void)changeButtonStatus:(UIButton *)btn{
    btnLoan.enabled =YES;
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case ProductDetailRequestInfo:
            self.cmd = XGetLoanProDetail;
            self.dict = @{@"loan_pro_id":self.loan_pro_id};
            break;
        case ProductDetailRequestStaticInfo:{
            self.cmd = XGetCreditInfo;
            self.dict = @{};
        }
            break;
        case ProductDetailRequestApplyLoan:{
            self.cmd = XApplyLoan;
            if(self.detailModel.cooperation_type.integerValue == 3){
                
                self.dict = @{@"loan_pro_id":self.detailModel.loan_pro_id,
                              @"apply_loan_amount":[NSString stringWithFormat:@"%ld",(tfMoney.text.integerValue*100)],
                              @"apply_loan_days":tfDate.text
                              };
            }else{
                self.dict = @{@"loan_pro_id":self.detailModel.loan_pro_id};
            }
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ProductDetailRequestInfo:
        {
            self.detailModel = [ProductModel mj_objectWithKeyValues:response.content[@"loan_pro"]];
            [self getData];
        }
            break;
        case ProductDetailRequestStaticInfo:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.content];
            if ([self requiredData]) {//判断资料是否齐全
                if ([[UserInfo sharedInstance]getUserInfo].has_grant_authorization.integerValue == 2) {//判断是否授权
                    [XAlertView alertWithTitle:@"温馨提示" message:@"您当前处于拒绝授权状态，想要获得更多服务,请前往修改状态。" cancelButtonTitle:@"取消" confirmButtonTitle:@"前往授权" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            AuthorizationVC *vc = [[AuthorizationVC alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }];
                    return;
                }
                [self prepareDataWithCount:ProductDetailRequestApplyLoan];
                return;
            }
            
            DataDetailVC *vc = [[DataDetailVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.productModel = self.detailModel;
            vc.apply_loan_amount = tfMoney.text;
            vc.apply_loan_days = tfDate.text;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
            break;
        case ProductDetailRequestApplyLoan:{
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
- (void)requestFaildWithDictionary:(XResponse *)response{
    if (response.errCode.integerValue == 33) {
        SuccessApplicationVC *vc  =[[SuccessApplicationVC alloc]init];
        vc.errCode = response.errCode;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self setHudWithName:response.errMsg Time:1 andType:1];
    
}
#pragma mark - 跳转界面
- (void)pushControllerView{
    NSInteger row = self.detailModel.cooperation_type.integerValue;
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
- (ProductModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [[ProductModel alloc]init];
    }
    return _detailModel;
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
