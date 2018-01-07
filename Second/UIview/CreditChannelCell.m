//
//  CreditChannelCell.m
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import "CreditChannelCell.h"

@implementation CreditChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _btn = [[UIButton alloc]init];
        [_btn setCornerValue:4];
        [_btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn.backgroundColor = XColorWithRBBA(255,255, 255, 0.88);
        _btn.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(15)];
        [_btn setTitle:@"我的专属贷款通道" forState:UIControlStateNormal];
        [_btn setTitleColor:XColorWithRGB(251, 125, 92) forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"credit_btn"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"credit_btn"] forState:UIControlStateHighlighted];
        _btn.titleEdgeInsets = UIEdgeInsetsMake(0,-AdaptationWidth(200) , 0, 0);
        _btn.imageEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(300), 0, 0);
        
       
        [self.contentView addSubview:_btn];
        
        _lab  = [[UILabel alloc]init];
        _lab.text = @"完成信用评测，获取专属贷款通道，通过率高";
        [_lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [_lab setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_lab];
        
    }
    return self;
}
- (void)btnOnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushAllDK)]) {
        [self.delegate pushAllDK];
    }
}
// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(16));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(45));
        make.centerY.mas_equalTo(self.contentView).offset( -AdaptationWidth(10));
    }];
    
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(_btn.mas_bottom).offset(AdaptationWidth(8));
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}
@end
