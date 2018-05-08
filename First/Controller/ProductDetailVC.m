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
#import "RatePresentController.h"
#import "SYVerticalAutoScrollView.h"
#import "FailApplicantionController.h"
typedef NS_ENUM(NSInteger ,ProductDetailModule){
    ProductDetailCondition,
    ProductDetailMaterial,
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
@property (nonatomic, strong) UILabel *cellLabel;
@property (nonatomic, strong) SYVerticalAutoScrollView *customView;
@property (nonatomic, strong) NSMutableArray *custArr;
@property (nonatomic,strong) XTextField *tfMoney;
@property (nonatomic,strong) XTextField *tfDate;;
@property (nonatomic,strong) UILabel *expenses_money;
@property (nonatomic,strong) UILabel *Reimbursement_amount_moneny;
@end

@implementation ProductDetailVC
{
    NSMutableArray *moduleArry;
    NSMutableArray *materialArry, *conditionArry, *flowArry;
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

-(void)setBackNavigationBarItem{
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	view.userInteractionEnabled = YES;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, 44, 44);
	button.tag = 9999;
	[button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
	[button setImageEdgeInsets:UIEdgeInsetsMake(0, -AdaptationWidth(8), 0, AdaptationWidth(8))];
	[button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	
	UIView *lineview  = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
	lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
	[button addSubview:lineview];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
	self.navigationItem.leftBarButtonItem = item;
}
- (void)getData{
    
    moduleArry = [NSMutableArray array];
    
    if (self.detailModel.loan_condition.count) {
        conditionArry = [NSMutableArray arrayWithArray:self.detailModel.loan_condition];
        [moduleArry addObject:@(ProductDetailCondition)];
    }
 
    if (self.detailModel.loan_need_data.count) {
        materialArry = [NSMutableArray arrayWithArray:self.detailModel.loan_need_data];
        [moduleArry addObject:@(ProductDetailMaterial)];
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
    
//    if (self.detailModel.cooperation_type.integerValue == 3) {//商户后台显示
//        self.tableView.tableFooterView = [self creatFooterView];
//    }
	
}
#pragma mark- tableView
- (UIView *)creatHeadView{
	
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(242))];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"card-1"]];
    [view addSubview:image];
	
    if (self.detailModel.cooperation_type.integerValue == 3) {
        UILabel *labDescribe = [[UILabel alloc]init];
        [labDescribe setText:@"额度 (元)："];
        [labDescribe setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [labDescribe setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe];
        
        UILabel *labDescribeStr = [[UILabel alloc]init];
        [labDescribeStr setText:[NSString stringWithFormat:@"%@",self.detailModel.loan_credit_str]];
        [labDescribeStr setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(14)]];
        [labDescribeStr setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribeStr];
        
        _tfMoney = [[XTextField alloc]init];
        _tfMoney.tag = 100;
        [_tfMoney setCornerValue:AdaptationWidth(2)];
        _tfMoney.backgroundColor = XColorWithRBBA(0, 0, 0, 0.18);
        [_tfMoney setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(28)]];
        _tfMoney.borderStyle = UITextBorderStyleNone;
//        _tfMoney.placeholder = self.detailModel.loan_credit_str;
        [_tfMoney setTextColor:XColorWithRBBA(255, 255, 255, 1)];
//        _tfMoney.clearsOnBeginEditing = YES;
        _tfMoney.keyboardType = UIKeyboardTypeDecimalPad;
        _tfMoney.delegate = self;
        _tfMoney.text = [NSString stringWithFormat:@"%.f",(self.detailModel.loan_max_credit.integerValue * 0.01)];
        [view addSubview:_tfMoney];
        
        UILabel *labDescribe2 = [[UILabel alloc]init];
        if (_detailModel.loan_deadline_type.integerValue == 1) {
            [labDescribe2 setText:@"期限 (天)："];
        }else{
            [labDescribe2 setText:@"期限 (月)："];
        }
        [labDescribe2 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [labDescribe2 setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe2];
        
        UILabel *labDescribe2Str = [[UILabel alloc]init];
        [labDescribe2Str setText:[NSString stringWithFormat:@"%@",self.detailModel.loan_deadline_str]];
        [labDescribe2Str setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(14)]];
        [labDescribe2Str setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe2Str];
        
        _tfDate = [[XTextField alloc]init];
        _tfDate.text  = self.detailModel.loan_max_deadline;
        _tfDate.tag = 101;
        [_tfDate setCornerValue:AdaptationWidth(2)];
        _tfDate.backgroundColor = XColorWithRBBA(0, 0, 0, 0.18);
        [_tfDate setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(28)]];
        _tfDate.borderStyle = UITextBorderStyleNone;
//        _tfDate.placeholder = self.detailModel.loan_deadline_str;
        [_tfDate setTextColor:XColorWithRBBA(255, 255, 255, 1)];
//        _tfDate.clearsOnBeginEditing = YES; 
        _tfDate.keyboardType = UIKeyboardTypeDecimalPad;
        _tfDate.delegate = self;
        [view addSubview:_tfDate];
        
        [labDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image).offset(AdaptationWidth(28));
            make.top.mas_equalTo(image).offset(AdaptationWidth(28));
        }];
        [labDescribeStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(labDescribe.mas_right);
            make.top.mas_equalTo(image).offset(AdaptationWidth(27));
        }];
        [self.tfMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(AdaptationWidth(32));
            make.top.mas_equalTo(labDescribe.mas_bottom).offset(AdaptationWidth(8));
            make.width.mas_equalTo(AdaptationWidth(137));
            make.height.mas_equalTo(AdaptationWidth(51));
        }];
        [labDescribe2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tfMoney.mas_right).offset(AdaptationWidth(37));
            make.top.mas_equalTo(image).offset(AdaptationWidth(28));
        }];
        [labDescribe2Str mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(labDescribe2.mas_right);
            make.top.mas_equalTo(image).offset(AdaptationWidth(27));
        }];
        [self.tfDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tfMoney.mas_right).offset(AdaptationWidth(37));
            make.top.mas_equalTo(labDescribe2.mas_bottom).offset(AdaptationWidth(8));
            make.width.height.mas_equalTo(self.tfMoney);
        }];
        
    }else if (self.detailModel.cooperation_type.integerValue == 1){
        UILabel *labDescribe1 = [[UILabel alloc]init];
        [labDescribe1 setText:@"额度 (元)"];
        [labDescribe1 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [labDescribe1 setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe1];
        
        UILabel *labDescribeStr = [[UILabel alloc]init];
        [labDescribeStr setText:[NSString stringWithFormat:@"%@",self.detailModel.loan_credit_str]];
        [labDescribeStr setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(34)]];
        [labDescribeStr setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribeStr];
        
        UILabel *labDescribe3 = [[UILabel alloc]init];
        if (_detailModel.loan_deadline_type.integerValue == 1) {
            [labDescribe3 setText:@"期限 (天)"];
        }else{
            [labDescribe3 setText:@"期限 (月)"];
        }
        [labDescribe3 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [labDescribe3 setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe3];
        
        UILabel *labDescribe2Str = [[UILabel alloc]init];
        [labDescribe2Str setText:[NSString stringWithFormat:@"%@",self.detailModel.loan_deadline_str]];
        [labDescribe2Str setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(34)]];
        [labDescribe2Str setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [image addSubview:labDescribe2Str];
        
        [labDescribe1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image).offset(AdaptationWidth(28));
            make.top.mas_equalTo(image).offset(AdaptationWidth(32));
            make.width.mas_equalTo(AdaptationWidth(190));
            make.height.mas_equalTo(AdaptationWidth(17));
        }];
        [labDescribeStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image).offset(AdaptationWidth(28));
            make.top.mas_equalTo(labDescribe1.mas_bottom).offset(AdaptationWidth(8));
            make.width.mas_equalTo(labDescribe1);
            make.height.mas_equalTo(AdaptationWidth(42));
        }];
        [labDescribe3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(labDescribe1.mas_right).offset(AdaptationWidth(16));
            make.top.mas_equalTo(image).offset(AdaptationWidth(32));
            make.width.mas_equalTo(AdaptationWidth(105));
            make.height.mas_equalTo(AdaptationWidth(17));
        }];
        [labDescribe2Str mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(labDescribeStr.mas_right).offset(AdaptationWidth(16));
            make.top.mas_equalTo(labDescribe3.mas_bottom).offset(AdaptationWidth(8));
            make.width.mas_equalTo(labDescribe3);
            make.height.mas_equalTo(AdaptationWidth(42));
        }];
    }

	UIView *line = [[UIView alloc]init];
	line.backgroundColor = XColorWithRBBA(34, 58, 80, 0.24);
	[image addSubview:line];
	
	UILabel *Reimbursement_amount = [[UILabel alloc]init];
    if (self.detailModel.cooperation_type.integerValue == 3) {
        [Reimbursement_amount setText:@"还款金额 (元)"];
    }else if (self.detailModel.cooperation_type.integerValue == 1){
        switch ([self.detailModel.loan_rate_type integerValue]) {
            case 1:
                [Reimbursement_amount setText:@"参考日利率"];
                break;
            case 2:
                [Reimbursement_amount setText:@"参考月利率"];
                break;
            case 3:
                [Reimbursement_amount setText:@"参考年利率"];
                break;
                
            default:
                break;
        }
    }
	[Reimbursement_amount setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(12)]];
	[Reimbursement_amount setTextColor:XColorWithRBBA(255, 255, 255, 1)];
	[image addSubview:Reimbursement_amount];

	UILabel *expenses = [[UILabel alloc]init];
	[expenses setText:@"利息及费用 (元)"];
	[expenses setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(12)]];
	[expenses setTextColor:XColorWithRBBA(255, 255, 255, 1)];
	[image addSubview:expenses];
	
	UILabel *loan_review = [[UILabel alloc]init];
	[loan_review setText:@"贷前回访"];
	[loan_review setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
	[loan_review setTextColor:XColorWithRBBA(255, 255, 255, 1)];
	[image addSubview:loan_review];
	
	_expenses_money = [[UILabel alloc]init];
    if (self.detailModel.agency_fee.integerValue == -1 || self.detailModel.service_fee_rate.integerValue == -1 || self.detailModel.loan_year_rate.integerValue >= 36 || (![self.detailModel.loan_min_credit isEqualToString:self.detailModel.loan_max_credit] && self.detailModel.cooperation_type.integerValue == 1) || ![self.detailModel.min_loan_rate isEqualToString:self.detailModel.loan_rate]) {
        [_expenses_money setText:@"浮动"];
        [_expenses_money setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(20)]];
    }else{
        switch ([self.detailModel.loan_deadline_type integerValue]) {
            case 1:{  // 借款期限 天
                switch ([self.detailModel.loan_rate_type integerValue]) {
                    case 1:{
                        float sum = self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 2:{
                        float sum = (self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue/30) + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 3:{
                        float sum = self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue/360 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.integerValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:{ // 借款期限 月
                switch ([self.detailModel.loan_rate_type integerValue]) {
                    case 1:{
                        float sum = self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue*30 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum /100];
                    }
                        break;
                    case 2:{
                        float sum = self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 3:{
                        float sum = self.tfMoney.text.doubleValue * self.tfDate.text.doubleValue * self.detailModel.loan_rate.doubleValue/12 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.doubleValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            default:
                break;
        }
        [_expenses_money setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(20)]];
    }
	[_expenses_money setTextColor:XColorWithRBBA(255, 255, 255, 1)];
	[image addSubview:_expenses_money];
    
    _Reimbursement_amount_moneny = [[UILabel alloc]init];
    if (  self.detailModel.loan_year_rate.integerValue >= 36) {
      
        [_Reimbursement_amount_moneny setText:@"浮动"];
        [_Reimbursement_amount_moneny setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(20)]];
    }else{
        if (self.detailModel.cooperation_type.integerValue == 3) {
            [_Reimbursement_amount_moneny setText:[NSString stringWithFormat:@"%.2f",self.expenses_money.text.doubleValue + self.tfMoney.text.integerValue]];
        }else if (self.detailModel.cooperation_type.integerValue == 1){
            if ([self.detailModel.min_loan_rate isEqualToString:self.detailModel.loan_rate]) {
                [_Reimbursement_amount_moneny setText:[NSString stringWithFormat:@"%@%%",self.detailModel.loan_rate]];
            }else{
                [_Reimbursement_amount_moneny setText:[NSString stringWithFormat:@"%@%%~%@%%",self.detailModel.min_loan_rate,self.detailModel.loan_rate]];
            }
        }
        [_Reimbursement_amount_moneny setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(20)]];
    }
    [_Reimbursement_amount_moneny setTextColor:XColorWithRBBA(255, 255, 255, 1)];
    [image addSubview:_Reimbursement_amount_moneny];
    
    UIView *line_vertical1 = [[UIView alloc]init];
    line_vertical1.backgroundColor = XColorWithRBBA(34, 58, 80, 0.24);
    [image addSubview:line_vertical1];
	
	UIButton *rateButton = [[UIButton alloc]init];
	[rateButton setImage:[UIImage imageNamed:@"icon_clean"] forState:UIControlStateNormal];
	[rateButton addTarget:self action:@selector(rateAction) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:rateButton];
	
	UIView *line_vertical2 = [[UIView alloc]init];
	line_vertical2.backgroundColor = XColorWithRBBA(34, 58, 80, 0.24);
	[image addSubview:line_vertical2];
	
	UILabel *loan_review_label = [[UILabel alloc]init];
    if (self.detailModel.pre_loan_visit.integerValue == 1 ) {
        [loan_review_label setText:@"有"];
    }else{
        [loan_review_label setText:@"无"];
    }
	[loan_review_label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(20)]];
	[loan_review_label setTextColor:XColorWithRBBA(255, 255, 255, 1)];
	[image addSubview:loan_review_label];
	
	UILabel *tip_label = [[UILabel alloc]init];
    if (self.detailModel.cooperation_type.integerValue == 3) {
        [tip_label setText:@"简单、快速、高额、低息"];
    }else if (self.detailModel.cooperation_type.integerValue == 1){
        [tip_label setText:@"持卡专享，尊享利率，效率审，批分期随心"];
    }
	tip_label.textAlignment = NSTextAlignmentRight;
	[tip_label setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
	[tip_label setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
	[view addSubview:tip_label];
	
	
	[image mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(view).offset(AdaptationWidth(4));
		make.right.mas_equalTo(view).offset(-AdaptationWidth(4));
		make.top.mas_equalTo(view).offset(AdaptationWidth(8));
		make.height.mas_equalTo(AdaptationWidth(214));
	}];
	[line mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(image).offset(AdaptationWidth(12));
		make.right.mas_equalTo(image).offset(-AdaptationWidth(12));
		make.top.mas_equalTo(image).offset(AdaptationWidth(121));
		make.height.mas_equalTo(0.5);
	}];

	[Reimbursement_amount mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(image).offset(AdaptationWidth(36));
		make.right.mas_equalTo(line_vertical1.mas_left);
		make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(16));
		make.height.mas_equalTo(AdaptationWidth(17));
	}];
	[expenses mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(line_vertical1.mas_right).offset(AdaptationWidth(17));
		make.right.mas_equalTo(line_vertical2.mas_left);
		make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(16));
		make.height.mas_equalTo(AdaptationWidth(17));
	}];
	[loan_review mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(line_vertical2.mas_right).offset(AdaptationWidth(28));
		make.right.mas_equalTo(image).offset(-AdaptationWidth(12));
		make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(16));
		make.height.mas_equalTo(AdaptationWidth(17));
	}];
	[_Reimbursement_amount_moneny mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(image).offset(AdaptationWidth(36));
		make.right.mas_equalTo(line_vertical1.mas_left);
		make.top.mas_equalTo(Reimbursement_amount.mas_bottom).offset(AdaptationWidth(2));
		make.height.mas_equalTo(AdaptationWidth(25));
	}];
	[_expenses_money mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(line_vertical1.mas_right).offset(AdaptationWidth(17));
		make.right.mas_equalTo(rateButton.mas_left);
		make.top.mas_equalTo(expenses.mas_bottom).offset(AdaptationWidth(2));
		make.height.mas_equalTo(AdaptationWidth(25));
	}];
	[loan_review_label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(line_vertical2.mas_right).offset(AdaptationWidth(28));
		make.right.mas_equalTo(image).offset(-AdaptationWidth(12));
		make.top.mas_equalTo(loan_review.mas_bottom).offset(AdaptationWidth(2));
		make.height.mas_equalTo(AdaptationWidth(25));
	}];
	[line_vertical1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(image).offset(AdaptationWidth(124));
		make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(40));
		make.height.mas_equalTo(16);
		make.width.mas_equalTo(0.5);
	}];
	[line_vertical2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(image).offset(AdaptationWidth(242));
		make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(40));
		make.height.mas_equalTo(16);
		make.width.mas_equalTo(0.5);
	}];
	[rateButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(line_vertical2.mas_left).offset(-AdaptationWidth(16));
		make.top.mas_equalTo(expenses.mas_bottom).offset(AdaptationWidth(5));
		make.height.width.mas_equalTo(AdaptationWidth(20));
	}];
	[tip_label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(view).offset(AdaptationWidth(24));
		make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
		make.top.mas_equalTo(image.mas_bottom);
		make.height.mas_equalTo(AdaptationWidth(20));
	}];
	
    
    return view;
}
-(void)createTopCirculationView{
    // customView_1
    UIView *customView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:self.detailModel.loan_pro_name];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [customView_1 addSubview:labTitle];
    
    UIView *hotView = [[UIView alloc]init];
    [hotView setCornerValue:AdaptationWidth(2)];
    hotView.backgroundColor = XColorWithRGB(253, 244, 232);
    [customView_1 addSubview:hotView];
    
    UILabel *hotLab = [[UILabel alloc]init];
    if (self.detailModel.be_staged.integerValue == 1) {
        [hotLab setText:@"分期还款"];
    }else{
        [hotLab setText:@"到期还款"];
    }
    [hotLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [hotLab setTextColor:XColorWithRGB(255, 176, 53)];
    [customView_1 addSubview:hotLab];
    
    
    // customView_2
    UIView *customView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    UILabel *cityLab = [[UILabel alloc]init];
    if (self.detailModel.run_address_name.length > 0) {
        [cityLab setText:[NSString stringWithFormat:@"经营区域: %@",self.detailModel.run_address_name]];
    }else{
        [cityLab setText:[NSString stringWithFormat:@""]];
    }
    [cityLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
    [cityLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
    [customView_2 addSubview:cityLab];
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(customView_1);
        make.height.mas_equalTo(AdaptationWidth(24));
        make.centerY.mas_equalTo(customView_1.mas_centerY);
    }];
    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView_1.mas_centerY);
        make.left.mas_equalTo(labTitle.mas_right).offset(AdaptationWidth(8));
        make.width.mas_equalTo(AdaptationWidth(69));
        make.height.mas_equalTo(AdaptationWidth(26));
    }];
    [hotLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(hotView);
    }];
    [cityLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(customView_2);
        make.centerY.mas_equalTo(customView_2.mas_centerY);
        make.height.mas_equalTo(AdaptationWidth(24));
    }];
    
    _custArr = [[NSMutableArray alloc]init];
    [_custArr addObject:customView_1];
    if (self.detailModel.run_address_name.length > 0) {
        [_custArr addObject:customView_2];
    }else{
        _customView.isRunning = NO;
    }
    CGRect custRect = CGRectMake(0, 0, ScreenWidth, 44);
    float animationInterval = 2;
    float animationDuration = 1;
    _customView = [SYVerticalAutoScrollView viewWithFrame:custRect customVies:_custArr animationInterval:animationInterval animationDuration:animationDuration dataSource:nil updator:^(id sender, NSMutableArray *data, int index) {
        
    }];
    self.navigationItem.titleView = _customView;
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
    [_headTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [view addSubview:_headTitle];
    
    NSInteger row = [moduleArry[section]integerValue];
    switch (row) {
        case ProductDetailCondition:{
            [self.headTitle setText:@"申请条件"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.top.mas_equalTo(view).offset(AdaptationWidth(32));
            }];
        }
            break;
        case ProductDetailMaterial:{
            [self.headTitle setText:@"借款所需材料"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.top.mas_equalTo(view).offset(AdaptationWidth(32));
            }];
        }
            break;
        case ProductDetailFlow:{
            [self.headTitle setText:@"申请流程"];
            [_headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.top.mas_equalTo(view).offset(AdaptationWidth(32));
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
	if (indexPath.section == 2) {
		return cell.frame.size.height + 20;
	}
    return cell.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger row = [moduleArry[section]integerValue];
    switch (row) {
        case ProductDetailMaterial:{
             return AdaptationWidth(73);
        }
            break;
        case ProductDetailCondition:{
             return AdaptationWidth(73);
        }
            break;
        case ProductDetailFlow:{
             return AdaptationWidth(73);
        }
            break;
        default:
            break;
    }
    return AdaptationWidth(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"detailCell";
    ProductDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductDetailTableViewCell alloc] initWithReuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = [moduleArry[indexPath.section]integerValue];
    switch (row) {
        case ProductDetailCondition:{
            NSString *cellstring = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,conditionArry[indexPath.row]];
            [cell setIntroductionText:cellstring];
        }
            break;
        case ProductDetailMaterial:{
            NSString *cellstring = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,materialArry[indexPath.row]];
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

    if (!([textField.text rangeOfString:@"."].location == NSNotFound)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"仅能输入整数" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] ;
        [alert show];
        textField.text = @"";
        
        return;
    }
    if ( textField.tag == 100)
    {
        [TalkingData trackEvent:@"【贷款详情】-想借多少"];
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
        [TalkingData trackEvent:@"【贷款详情】-想借多久"];
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
    [self changeTheMoney];
}
-(void)changeTheMoney{
    if (![self.detailModel.min_loan_rate isEqualToString:self.detailModel.loan_rate] || self.detailModel.agency_fee.integerValue == -1 || self.detailModel.service_fee_rate.integerValue == -1) {
        [_expenses_money setText:@"浮动"];
        [_expenses_money setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(20)]];
    }else{
        switch ([self.detailModel.loan_deadline_type integerValue]) {
            case 1:{  // 借款期限 天
                switch ([self.detailModel.loan_rate_type integerValue]) {
                    case 1:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 2:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue/30 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 3:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue/360 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:{ // 借款期限 月
                switch ([self.detailModel.loan_rate_type integerValue]) {
                    case 1:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue*30 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum /100];
                    }
                        break;
                    case 2:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                    case 3:{
                        float sum = self.tfMoney.text.integerValue * self.tfDate.text.integerValue * self.detailModel.loan_rate.doubleValue/12 + self.detailModel.agency_fee.doubleValue + (self.tfMoney.text.integerValue * self.detailModel.service_fee_rate.doubleValue);
                        _expenses_money.text = [NSString stringWithFormat:@"%.2f",sum/100];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            default:
                break;
        }
        [_expenses_money setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(20)]];
    }
    if (![self.detailModel.min_loan_rate isEqualToString:self.detailModel.loan_rate]) {
        [_Reimbursement_amount_moneny setText:@"浮动"];
        [_Reimbursement_amount_moneny setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(20)]];
    }else{
        [_Reimbursement_amount_moneny setText:[NSString stringWithFormat:@"%.2f",self.expenses_money.text.doubleValue + self.tfMoney.text.integerValue]];
        [_Reimbursement_amount_moneny setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(20)]];
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
-(void)rateAction{
    [TalkingData trackEvent:@"【贷款详情】-帮助"];
	RatePresentController *rate = [[RatePresentController alloc]init];
    rate.moneyStr = self.tfMoney.text;
    rate.dateStr = self.tfDate.text;
	rate.model = self.detailModel;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rate];
	nav.navigationBar.hidden = YES;
	nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:nav animated:YES completion:^{
        
	}];
}
- (void)btnOnClick:(UIButton *)btn{
    
    //点击按钮后先取消之前的操作，再进行需要进行的操作
    btnLoan.enabled =NO;
    [self performSelector:@selector(changeButtonStatus:)withObject:nil afterDelay:2.0f];//防止重复点击
    
    if (self.detailModel.cooperation_type.integerValue == 3) {//商户后台显示
        if (!self.tfDate.text.length || !self.tfMoney.text.length) {
            [self setHudWithName:@"请输入想借金额和想借期限" Time:0.5 andType:1];
            return;
        }
    }
    
    //talkingdata
    [TalkingData trackEvent:@"【贷款详情】-申请借款"];
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
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.loan_pro_id,@"loan_pro_id", nil];
            break;
        case ProductDetailRequestStaticInfo:{
            self.cmd = XGetCreditInfo;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case ProductDetailRequestApplyLoan:{
            self.cmd = XApplyLoan;
            if(self.detailModel.cooperation_type.integerValue == 3){
                
                self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.detailModel.loan_pro_id,@"loan_pro_id",
                             [NSString stringWithFormat:@"%ld",(self.tfMoney.text.integerValue*100)],@"apply_loan_amount",
                             self.tfDate.text,@"apply_loan_days",nil];
            }else{
                self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.detailModel.loan_pro_id,@"loan_pro_id", nil];
  
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
            [self createTopCirculationView];
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
            vc.apply_loan_amount = self.tfMoney.text;
            vc.apply_loan_days = self.tfDate.text;
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
    if (response.errCode.integerValue == 33 || response.errCode.integerValue == 35) {
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
                FailApplicantionController *vc  =[[FailApplicantionController alloc]init];
                vc.errCode = response.errCode;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
                break;
                
            default:
                break;
        }
        
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

@end
