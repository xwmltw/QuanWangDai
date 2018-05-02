//
//  LookReportController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/17.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "LookReportController.h"
#import "AllDKViewController.h"
#import "PersonalTailorVC.h"

@interface LookReportController ()
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic ,copy) NSNumber *isAll;
@end

@implementation LookReportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
-(void)BarbuttonClick:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)setupUI{
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setText:@"获取报告中…"];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:titleLab];
    
    UILabel *subtitleLab = [[UILabel alloc]init];
    subtitleLab.numberOfLines = 0;
    [subtitleLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [subtitleLab setText:@"3分钟后，再来查看最新报告"];
    [subtitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:subtitleLab];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"allDK_notData"];
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"先去借款" forState:UIControlStateNormal];
    [button setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(32));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subtitleLab.mas_bottom).offset(AdaptationWidth(24));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
}

-(void)btnOnClick{
    
  
    [self prepareDataWithCount:0];
    
    
}
- (void)setRequestParams{
    self.cmd = XGetSpecialLoanProList;
    if ([CreditState creditStateWith:self.creditInfoModel]) {
        self.isAll = @1;
    }else{
        self.isAll = @2;
    }
    self.dict =@{@"query_type":self.isAll};
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    NSArray *arr = response.content[@"loan_pro_list"];
    if (arr.count>3) {
        PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
        vc.isAllProduct = self.isAll;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AllDKViewController *vc = [[AllDKViewController alloc]init];
        vc.loan_product_type = @0;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
@end
