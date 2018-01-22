//
//  RecommendTableViewCell.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)setModel:(ProductModel *)model{
    [self.headImage setCornerValue:AdaptationWidth(20)];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.borderWidth = AdaptationWidth(0.5);
    self.headImage.layer.borderColor = XColorWithRBBA(233, 233, 235, 0.4).CGColor;
    if (model.loan_pro_logo_url.length) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.loan_pro_logo_url]];
    }else{
        [self.headImage setImage:[UIImage imageNamed:@"loadingPage"]];
    }
    self.labTitle.text = model.loan_pro_name;
    self.quota.text = [NSString stringWithFormat:@"可贷额度 (元): %@",model.loan_credit_str];
    switch ([model.loan_deadline_type integerValue]) {
        case 1:
            self.date_type.text = @"借款期限 (天): ";
            break;
        case 2:
            self.date_type.text = @"借款期限 (月): ";
            break;
        default:
            break;
    }
    self.date.text = [NSString stringWithFormat:@"%@",model.loan_deadline_str];
    switch ([model.loan_rate_type integerValue]) {
        case 1:
            self.typelabel.text = @"参考日利率: ";
            break;
        case 2:
            self.typelabel.text = @"参考月利率: ";
            break;
        case 3:
            self.typelabel.text = @"参考年利率: ";
            break;
            
        default:
            break;
    }
    if (model.loan_year_rate.intValue > 36) {
        [self.typelabel setText:[NSString stringWithFormat:@"浮动利率"]];
        self.interestRate.hidden = YES;
    }else{
        [self.interestRate setText:[NSString stringWithFormat:@"%@%%~%@%%",model.min_loan_rate,model.loan_rate]];
    }
//    self.interestRate.text = [NSString stringWithFormat:@"%@%%",model.loan_rate];
    self.labState.text = model.hot_label;
    self.labState.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)];
    [self.appState setCornerValue:AdaptationWidth(2)];
    
//    [self.appState mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.labState.mas_left).offset(-AdaptationWidth(8));
//        make.right.equalTo(self).offset(-AdaptationWidth(16));
//        make.top.equalTo(self).offset(AdaptationWidth(20));
//        make.height.equalTo(@(26));
//
//    }];
//
//    [self.labState mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.appState).offset(AdaptationWidth(8));
//        make.right.equalTo(self.appState).offset(-AdaptationWidth(8));
//        make.top.equalTo(self.appState).offset(AdaptationWidth(4));
//        make.bottom.equalTo(self.appState).offset(- AdaptationWidth(4));
//
//    }];
    
    
    if (model.apply_is_full.integerValue == 1) {
        UIImageView  *iamgeBg = [[UIImageView alloc]init];
        [iamgeBg setImage:[UIImage imageNamed:@"Product_full"]];
        [self.headImage addSubview:iamgeBg];
        
        [iamgeBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.headImage);
        }];
        
        self.headImage.alpha = 0.5;
        self.labTitle.alpha = 0.5;
        self.quota.alpha = 0.5;
        self.date.alpha = 0.5;
        self.interestRate.alpha = 0.5;
        self.labState.alpha = 0.5;
        self.typelabel.alpha = 0.5;
        self.date_type.alpha = 0.5;
    }
}
- (void)setDetailColor:(BOOL)type quotaSelect:(BOOL)quota dataSelect:(BOOL)data{
    
    if (type) {
        [self.typelabel setTextColor:XColorWithRGB(252, 93, 109)];
        [self.interestRate setTextColor:XColorWithRGB(252, 93, 109)];
    }
    if (quota) {
        [self.quota setTextColor:XColorWithRGB(252, 93, 109)];
    }
    if (data) {
        [self.date_type setTextColor:XColorWithRGB(252, 93, 109)];
        [self.date setTextColor:XColorWithRGB(252, 93, 109)];
    }
    
    
}

@end
