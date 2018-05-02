//
//  PaySuccessController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/17.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "PaySuccessController.h"
#import "LookReportController.h"
@interface PaySuccessController ()

@end

@implementation PaySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【支付结果】页"];
    [self setupUI];
}

-(void)setupUI{
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setText:@"支付成功"];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:titleLab];
    
    UILabel *subtitleLab = [[UILabel alloc]init];
    subtitleLab.numberOfLines = 0;
    [subtitleLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [subtitleLab setText:@"报告数据来源于权威机构，为保证信息准确有效查看前您需进行相关信息认证。如已完成无需另行认证。"];
    [subtitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:subtitleLab];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"notData"];
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"查看报告" forState:UIControlStateNormal];
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
    if (self.reportType.integerValue == 1) {
        [CreditState selectOperatorCreaditState:self];
    }else{
        [CreditState selectIdentityCreaditState:self];
    }
}

@end
