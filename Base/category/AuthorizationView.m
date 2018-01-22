//
//  AuthorizationView.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "AuthorizationView.h"

@implementation AuthorizationView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    UILabel *agreelab = [[UILabel alloc]init];
    [agreelab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    [agreelab setText:@"我已同意"];
    [agreelab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
    [self addSubview:agreelab];
    
    _AgreementBtn = [[UIButton alloc]init];
    _AgreementBtn.tag = AuthorizationBtnOnClickAgreement;
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@"《全网贷个人信息收集授权书》"];
    [aString addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(0, aString.length)];
    [aString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(15)] range:NSMakeRange(0, aString.length)];
    [aString addAttribute:NSForegroundColorAttributeName value:XColorWithRGB(7, 137, 133) range:NSMakeRange(0, aString.length)];
    [_AgreementBtn setAttributedTitle:aString forState:UIControlStateNormal];
    [self addSubview:_AgreementBtn];
    
    _TickBtn = [[UIButton alloc]init];
    _TickBtn.tag = AuthorizationBtnOnClickTick;
    [_TickBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_TickBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [self addSubview:_TickBtn];
    
    [_AgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptationWidth(24));
        make.left.mas_equalTo(agreelab.mas_right);
        make.bottom.mas_equalTo(self).offset(-AdaptationWidth(24));
    }];
    [_TickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-AdaptationWidth(24));
        make.height.width.mas_equalTo(AdaptationWidth(28));
    }];
    [agreelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(AdaptationWidth(24));
        make.left.mas_equalTo(self).offset(AdaptationWidth(24));
        make.bottom.mas_equalTo(self).offset(-AdaptationWidth(24));
    }];
}

@end
