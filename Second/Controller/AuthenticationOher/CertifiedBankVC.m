//
//  CertifiedBankVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "CertifiedBankVC.h"
#import "BankInfoModel.h"
#import "AuthenticationBankVC.h"

@interface CertifiedBankVC ()
@property (nonatomic ,strong) BankInfoModel *bankInfoModel;
@end

@implementation CertifiedBankVC
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self prepareDataWithCount:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *problemBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, AdaptationWidth(65), AdaptationWidth(30))];
    problemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [problemBtn setTitle:@"更换" forState:UIControlStateNormal];
    [problemBtn setTitleColor:XColorWithRGB(34, 58, 80) forState:UIControlStateNormal];
    [problemBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
    [problemBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:problemBtn];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = -20;
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer,self.navigationItem.rightBarButtonItem];
}
- (void)setUI{
    UILabel *nameLab = [UILabel new];
    nameLab.text = @"银行卡信息";
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
    nameLab.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    [self.view addSubview:nameLab];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"MyData_Certifiedbank"]];
    [self.view addSubview:imageView];
    
    UIImageView *bankLogo = [[UIImageView alloc]init];
//    [bankLogo setImage:[UIImage imageNamed:@"MyData_Certifiedbank"]];
    [bankLogo sd_setImageWithURL:[NSURL URLWithString:_bankInfoModel.bank_logo]];
    [self.view addSubview:bankLogo];
    
    UILabel *bankName = [UILabel new];
    bankName.text = _bankInfoModel.bank_name;
    bankName.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
    bankName.textColor = XColorWithRGB(255,255,255);
    [self.view addSubview:bankName];
    
    NSString *car = [_bankInfoModel.bank_card_no stringByReplacingCharactersInRange:NSMakeRange(4, 8) withString:@" ****  **** "];
    UILabel *bankNumer = [UILabel new];
    bankNumer.text = car;
    bankNumer.font = [UIFont fontWithName:@"SciFly-Sans" size:AdaptationWidth(28)];
    bankNumer.textColor = XColorWithRGB(255,255,255);
    [self.view addSubview:bankNumer];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(nameLab.mas_bottom).offset(AdaptationWidth(32));
        make.height.mas_equalTo(AdaptationWidth(202));
    }];
    
    [bankLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView).offset(AdaptationWidth(20));
        make.top.mas_equalTo(imageView).offset(AdaptationWidth(20));
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankLogo.mas_right).offset(AdaptationWidth(8));
        make.top.mas_equalTo(imageView).offset(AdaptationWidth(24));
    }];
    [bankNumer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView).offset(AdaptationWidth(20));
        make.centerY.mas_equalTo(imageView);
    }];
}
- (void)btnOnClick:(UIButton *)btn{
    AuthenticationBankVC *vc = [[AuthenticationBankVC alloc]init];
    vc.bankInfoModel =_bankInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setRequestParams{
    self.cmd = XGetBankCardCheckInfo;
    self.dict = @{};
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.bankInfoModel = [BankInfoModel mj_objectWithKeyValues:response.content];
    [self setUI];
}
- (BankInfoModel *)bankInfoModel{
    if (!_bankInfoModel) {
        _bankInfoModel = [[BankInfoModel alloc]init];
    }
    return _bankInfoModel;
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
