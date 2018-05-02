//
//  WorkInfoTableViewCell.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "WorkInfoTableViewCell.h"
@interface WorkInfoTableViewCell()<UITextFieldDelegate>
@end

@implementation WorkInfoTableViewCell
{
    UILabel *title;
    UILabel *rightLab;
    UITextField *textField;
    UIImageView *rightImage;
    UIView *line;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        title = [[UILabel alloc]init];
        
        [title setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
        [title setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [self.contentView addSubview:title];
        
        rightLab = [[UILabel alloc]init];
       
        [rightLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18]];
        [rightLab setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
        [self.contentView addSubview:rightLab];
        
        textField  = [[UITextField alloc]init];
        textField.delegate = self;
        [textField setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        textField.keyboardType = UIKeyboardTypeDefault;
        [self.contentView addSubview:textField];
        
        rightImage  = [[UIImageView alloc]init];
        [rightImage setImage:[UIImage imageNamed:@"credit_expand"]];
        [self.contentView addSubview:rightImage];
        
        line  = [[UIView alloc]init];
        line.backgroundColor  = XColorWithRGB(233, 233, 235);
        [self.contentView addSubview:line];
    }
    return self;
}
+ (BOOL)requiresConstraintBasedLayout{
    
    return YES;
}
- (void)updateConstraints{
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
    }];
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(textField);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(textField);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}
- (void)setCellWith:(WorkInfoModel *)model indexPath:(NSInteger)row{
    rightLab.hidden = YES;
    rightImage.hidden = YES;
    textField.enabled  = YES;
    switch (row) {
        case 0:
        {
            textField.text = model.company_name.length ? model.company_name : @"";
            title.text = @"公司名称 (必填)";
            textField.placeholder = @"您所在公司的名称";
        }
            break;
        case 1:
        {
            rightImage.hidden = NO;
            title.text = @"工作城市 (必填)";
            textField.placeholder = @"您公司所在的省市区";
            textField.enabled = NO;
            [textField setTextColor:XColorWithRGB(7, 137, 133)];
//            textField.text = model.company_province.length ? [NSString stringWithFormat:@"%@%@",model.company_province,model.company_city] : @"";
            NSString *str = [NSString stringWithFormat:@"%@ %@ ",model.company_province,model.company_city];
            if (model.company_town.length) {
                str = [str stringByAppendingString:model.company_town];
            }
            textField.text = model.company_province.length ? str : @"";
        }
            break;
        case 2:
        {
            title.text = @"公司地址 (必填)";
            textField.placeholder = @"您公司的详细地址";
            textField.text = model.company_address.length ? model.company_address : @"";
        }
            break;
        case 3:
        {
            title.text = @"公司电话";
            textField.placeholder = @"区号+号码+(分机号)";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = model.company_phone.length ? model.company_phone : @"";

        }
            break;
        case 4:
        {
            title.text = @"工作岗位";
            textField.placeholder = @"您的岗位名称";
            textField.text = model.job_name.length ? model.job_name : @"";
        }
            break;
        case 5:
        {
            rightLab.hidden = NO;
            rightLab.text  = @"元";
            title.text = @"工资收入 (月)";
            textField.placeholder = @"您的薪资金额";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = model.job_salary.length ? model.job_salary : @"";
        }
            break;
        case 6:
        {
            rightLab.hidden = NO;
            rightLab.text  = @"日";
            title.text = @"发薪日期 (必填)";
            textField.placeholder = @"您发工资的日期，1~31";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = model.job_pay_salary_day.length ? model.job_pay_salary_day : @"";

        }
            break;
            
            
        default:
            break;
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    XBlockExec(self.block, textField.text);
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
