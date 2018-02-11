//
//  ApplicantCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ApplicantCell.h"

@implementation ApplicantCell
{
    UIButton *selectBtn;
    UIView *lineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLab = [[UILabel alloc]init];
        [_titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [_titleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [self.contentView addSubview:_titleLab];
        
        _detailLab = [[UILabel alloc]init];
        [_detailLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [_detailLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
        [self.contentView addSubview:_detailLab];
        
        selectBtn  = [[UIButton alloc]init];
        [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectBtn];
        
        lineView  = [[UIView alloc]init];
        lineView.backgroundColor = XColorWithRGB(233, 233, 235);
        [self.contentView addSubview:lineView];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
    }];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(AdaptationWidth(4));
        make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(77)));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(_detailLab);
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [super updateConstraints];
}

-(void)btnOnClick:(UIButton *)btn{
    
}

- (void)setDataModel:(ApplicantModel*)model with:(NSUInteger)row{
    selectBtn.tag = row;
    BOOL yes = [model.professional_identity.description isEqualToString:@"1"];
    switch (row) {
        case ApplicantCellCellUse:
        {
            _detailLab.text =  model.loan_usage.length ? model.loan_usage : @"选择您的借款用途";
            if (model.loan_usage.length != 0) {
                [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
            }
        }
            break;
        case ApplicantCellCellProfession:
        {
            NSString *str = @"";
            if ([model.professional_identity.description isEqualToString:@"1"]) {
                str = @"上班族";
            }else if([model.professional_identity.description isEqualToString:@"2"]){
                str = @"个体户";
            }else if([model.professional_identity.description isEqualToString:@"3"]){
                str = @"无固定职业";
            }else if([model.professional_identity.description isEqualToString:@"4"]){
                str = @"企业主";
            }else if([model.professional_identity.description isEqualToString:@"5"]){
                str = @"学生";
            }
            _detailLab.text =  str.length ? str : @"选择您的职业身份";
            if (str.length != 0) {
                [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
            }
        }
            break;
        case ApplicantCellCellSalary:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.payroll_type.description isEqualToString:@"1"]) {
                    str = @"银行卡发放";
                }else if([model.payroll_type.description isEqualToString:@"2"]){
                    str = @"现金发放";
                }else if([model.payroll_type.description isEqualToString:@"3"]){
                    str = @"部分银行卡,部分现金";
                }
                    _detailLab.text = str.length ? str : @"选择工资发放形式";
                    if (str.length != 0) {
                        [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                    }
              }else{
                  NSString *str = @"";
                  if ([model.has_accumulation_fund.description isEqualToString:@"0"]) {
                      str = @"无";
                  }else if([model.has_accumulation_fund.description isEqualToString:@"1"]){
                      str = @"有";
                  }
                    _detailLab.text =  str.length ? str : @"有无本地公积金";
                    if (str.length != 0) {
                        [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                    }
                 }
        }
            break;
        case ApplicantCellCellWorking_years:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.working_years.description isEqualToString:@"1"]) {
                    str = @"不足3个月";
                }else if([model.working_years.description isEqualToString:@"2"]){
                    str = @"3-5个月";
                }else if([model.working_years.description isEqualToString:@"3"]){
                    str = @"6-11个月";
                }else if([model.working_years.description isEqualToString:@"4"]){
                    str = @"1-3年";
                }else if([model.working_years.description isEqualToString:@"5"]){
                    str = @"4-7年";
                }else if([model.working_years.description isEqualToString:@"6"]){
                    str = @"7年以上";
                }
                _detailLab.text =  str.length ? str : @"选择当前单位的工龄";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                NSString *str = @"";
                if ([model.has_social_security.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_social_security.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str : @"有无本地社保";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
                }
        }
            break;
        case ApplicantCellCellreserved_funds:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.has_accumulation_fund.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_accumulation_fund.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str : @"有无本地公积金";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                NSString *str = @"";
                if ([model.has_house_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_house_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"名下有无房产";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
            
        }
            break;
        case ApplicantCellCellSocial_security:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.has_social_security.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_social_security.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str : @"有无本地社保";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                NSString *str = @"";
                if ([model.relatives_has_house_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.relatives_has_house_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"亲属名下有无房产";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
            
        }
            break;
        case ApplicantCellCellHouse:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.has_house_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_house_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"名下有无房产";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                NSString *str = @"";
                if ([model.has_car_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_car_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"名下有无车辆";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
        }
            break;
        case ApplicantCellCellRelativeHouse:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.relatives_has_house_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.relatives_has_house_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"亲属名下有无房产";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                NSString *str = @"";
                if ([model.credit_info.description isEqualToString:@"1"]) {
                    str = @"1年内逾期超过3次或超过90天";
                }else if([model.credit_info.description isEqualToString:@"2"]){
                    str = @"1年内逾期少3次且少于90天";
                }else if([model.credit_info.description isEqualToString:@"3"]){
                    str = @"无信用卡或贷款";
                }else if([model.credit_info.description isEqualToString:@"4"]){
                    str = @"信用良好";
                }else if([model.credit_info.description isEqualToString:@"5"]){
                    str = @"无逾期";
                }
                _detailLab.text =  str.length ? str : @"选择您的信用情况";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
        }
            break;
        case ApplicantCellCellCar:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.has_car_property.description isEqualToString:@"0"]) {
                    str = @"无";
                }else if([model.has_car_property.description isEqualToString:@"1"]){
                    str = @"有";
                }
                _detailLab.text =  str.length ? str  : @"名下有无车辆";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
        }
            break;
            
        case ApplicantCellCellCredit:
        {
            if (yes) {
                NSString *str = @"";
                if ([model.credit_info.description isEqualToString:@"1"]) {
                    str = @"1年内逾期超过3次或超过90天";
                }else if([model.credit_info.description isEqualToString:@"2"]){
                    str = @"1年内逾期少3次且少于90天";
                }else if([model.credit_info.description isEqualToString:@"3"]){
                    str = @"无信用卡或贷款";
                }else if([model.credit_info.description isEqualToString:@"4"]){
                    str = @"信用良好";
                }else if([model.credit_info.description isEqualToString:@"5"]){
                    str = @"无逾期";
                }
                _detailLab.text =  str.length ? str : @"选择您的信用情况";
                if (str.length != 0) {
                    [_detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }
        }
            break;
            
        default:
            break;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
