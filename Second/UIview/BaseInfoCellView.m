//
//  BaseInfoCellView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/25.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "BaseInfoCellView.h"
@interface BaseInfoCellView()<UITextFieldDelegate>

@end
@implementation BaseInfoCellView
{
    UILabel *titleLab;
    UILabel *detailLab;
    UIButton *selectBtn;
    UIView *lineView;
    UITextField *textField;
    CGSize textSize;
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleLab = [[UILabel alloc]init];
        [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [self.contentView addSubview:titleLab];
        
        detailLab = [[UILabel alloc]init];
        [detailLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [detailLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
        [self.contentView addSubview:detailLab];
        
        textField  = [[UITextField alloc]init];
        textField.delegate  = self;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.textAlignment = NSTextAlignmentCenter;
        [textField setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
        [textField setTextColor:XColorWithRGB(7, 137, 133)];
        textField.backgroundColor = XColorWithRBBA(7, 137, 133, 0.1);
        [self.contentView addSubview:textField];
        
        
        selectBtn  = [[UIButton alloc]init];
        
        [selectBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectBtn];
        
        lineView  = [[UIView alloc]init];
        lineView.backgroundColor = XColorWithRGB(233, 233, 235);
        [self.contentView addSubview:lineView];
        
    }
    return self;
}
- (void)textFieldDidChange:(UITextField *)textField{
   textSize = [textField.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]}];
    [textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width);
    }];
    [detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(32)+textSize.width);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
        make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(24)));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ViewBtnOnClick:)]) {
        [self.delegate ViewBtnOnClick:textField];
    }
    
}
// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
    }];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
        make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(24)));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(25));
        make.width.mas_equalTo(AdaptationWidth(45));
    }];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(detailLab);
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

- (void)setDataModel:(BaseInfoModel*)model with:(NSUInteger)row{
    textField.hidden = YES;
    selectBtn.tag = row;
    textField.tag = row;
    switch (row) {
        case BaseInfoTableViewCellParentsPhone:
        {
            [selectBtn setImage:[UIImage imageNamed:@"credit_concat"] forState:UIControlStateNormal];
            titleLab.text =  @"亲属姓名及电话";
            if (model.contacts[0].ship_contact.length) {
                textField.hidden = NO;
                textField.text = model.contacts[0].ship_name;
                [detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(32)+textField.bounds.size.width);
                    make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
                    make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(24)));
                    make.height.mas_equalTo(AdaptationWidth(25));
                }];
                NSString *str = [NSString stringWithFormat:@"%@",model.contacts[0].ship_contact];
                detailLab.text = str.length ?  str :@"添加亲属的电话";
                if (str.length != 0) {
                    [detailLab setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
                }
            }else{
                detailLab.text = @"添加亲属的电话";
            }
        }
            
            break;
        case BaseInfoTableViewCellContactPhone:{
            [selectBtn setImage:[UIImage imageNamed:@"credit_concat"] forState:UIControlStateNormal];
            titleLab.text = @"联系人姓名及电话";
            if (model.contacts[1].ship_contact.length) {
                textField.hidden = NO;
                textField.text = model.contacts[1].ship_name;
                [detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(32)+textField.bounds.size.width);
                    make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
                    make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(24)));
                    make.height.mas_equalTo(AdaptationWidth(25));
                }];
                NSString *str = [NSString stringWithFormat:@"%@",model.contacts[1].ship_contact];
                detailLab.text = str.length ?  str :@"添加联系人及电话";
                if (str.length != 0) {
                    [detailLab setTextColor:XColorWithRBBA(34, 58, 80, 0.16)];
                }
            }else{
                detailLab.text = @"添加联系人及电话";
            }
            
        }
            break;
        case BaseInfoTableViewCellMarriage:
        {
            [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
            titleLab.text = @"婚姻状况";
            detailLab.text = model.is_marry.length ? model.is_marry : @"选择已婚或未婚";
            if (model.is_marry.length != 0) {
                [detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
                    make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
                    make.right.mas_equalTo(self.contentView).offset(-(AdaptationWidth(24)));
                    make.height.mas_equalTo(AdaptationWidth(25));
                }];
                [detailLab setTextColor:XColorWithRGB(7, 137, 133)];
            }
        }
            break;
        case BaseInfoTableViewCellCity:
        {
            [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
            titleLab.text = @"所在城市";
            NSString *str = [NSString stringWithFormat:@"%@ %@ ",model.home_province,model.home_city];
            if (model.home_town.length) {
                str = [str stringByAppendingString:model.home_town];
            }
            detailLab.text = model.home_province.length ? str : @"您现居的省市区";
            if (model.home_province.length != 0) {
                [detailLab setTextColor:XColorWithRGB(7, 137, 133)];
            }
            
        }
            break;
        case BaseInfoTableViewCellRelative:
        {
            [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
            titleLab.text = @"亲属关系";
            if (model.contacts.count > 0) {
                detailLab.text = model.contacts[0].relationship.length ? model.contacts[0].relationship :@"选择父母或配偶";
                if (model.contacts[0].relationship.length != 0 ) {
                    [detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
            }else{
                detailLab.text = @"选择父母或配偶";
            }
        }
            break;
        case BaseInfoTableViewCellRelativeCity:
        {
            [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
            titleLab.text = @"亲属所在城市";
            if (model.contacts.count > 0) {
                detailLab.text = model.contacts[0].ship_province_city_town.length ? model.contacts[0].ship_province_city_town : @"亲属现居的省市区";
                if (model.contacts[0].ship_province_city_town.length != 0 ) {
                    [detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
                
            }else{
                detailLab.text = @"亲属现居的省市区";
            }
        }
            break;
        case BaseInfoTableViewCellContactRelation:{
            [selectBtn setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
            titleLab.text = @"联系人关系";
            if (model.contacts.count > 1) {
                detailLab.text = model.contacts[1].relationship.length ? model.contacts[1].relationship :@"选择同事或朋友";
                if (model.contacts[1].relationship.length != 0) {
                    [detailLab setTextColor:XColorWithRGB(7, 137, 133)];
                }
                
            }else{
                detailLab.text = @"选择同事或朋友";
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
