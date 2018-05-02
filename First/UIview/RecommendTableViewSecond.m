//
//  RecommendTableViewSecond.m
//  QuanWangDai
//
//  Created by yanqb on 2018/4/18.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "RecommendTableViewSecond.h"

@implementation RecommendTableViewSecond
- (void)setModel:(ProductModel *)model{
    
    [self.cellMoney setFont:[UIFont fontWithName:@"WenYue-HouXianDaiTi-NC-W4-75" size:AdaptationWidth(24)]];
    [self.cellTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    
    [self.cellImage setCornerValue:AdaptationWidth(14)];
    self.cellImage.layer.masksToBounds = YES;
    self.cellImage.layer.borderWidth = AdaptationWidth(0.5);
    self.cellImage.layer.borderColor = XColorWithRBBA(233, 233, 235, 0.4).CGColor;
    [self.cellImage sd_setImageWithURL:[NSURL URLWithString:model.loan_pro_logo_url]];
    self.cellTitle.text = model.loan_pro_name;;
    self.cellMoney.text = model.loan_credit_str;
    self.cellInfobgView.layer.masksToBounds = YES;
    [self.cellInfobgView setCornerValue:2];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
