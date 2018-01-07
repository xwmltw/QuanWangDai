//
//  BaseInfoCellText.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/25.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "BaseInfoCellText.h"
@interface BaseInfoCellText()<UITextFieldDelegate>
@end
@implementation BaseInfoCellText
{
    UILabel *titleLab;
    UITextField *detailText;
    UIView *lineView;
    NSString * toBeString;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleLab = [[UILabel alloc]init];
        [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
        [self.contentView addSubview:titleLab];
        
        detailText = [[UITextField alloc]init];
        detailText.delegate = self;
        [detailText setTextColor:XColorWithRGB(34, 58, 80)];
        [detailText setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
        [self.contentView addSubview:detailText];
        
        lineView  = [[UIView alloc]init];
        lineView.backgroundColor = XColorWithRGB(233, 233, 235);
        [self.contentView addSubview:lineView];
    }
    return self;
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
    [detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [super updateConstraints];
}

- (void)setDataModel:(BaseInfoModel*)model with:(NSUInteger)row{
    detailText.tag = row;
    switch (row) {
        case BaseInfoTableViewCellMyAddress:
            detailText.text = model.home_address.length ? model.home_address : @"";
            detailText.placeholder = @"您现居地的详细地址";
            titleLab.text = @"详细住址";
            break;
        case BaseInfoTableViewCellRelativeAddress:
            if (model.contacts.count > 0) {
                detailText.text = model.contacts[0].ship_address.length ? model.contacts[0].ship_address :@"";
            }else{
                detailText.text = @"";
            }
            
            detailText.placeholder = @"亲属现居地的详细地址";
            titleLab.text = @"详细住址";
            break;
            
        default:
            break;
    }
}
#pragma mark - textField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textBtnOnClick:)]) {
        [self.delegate textBtnOnClick:textField];
    }
}
@end
