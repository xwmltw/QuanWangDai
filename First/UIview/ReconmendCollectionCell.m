//
//  ReconmendCollectionCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/18.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ReconmendCollectionCell.h"

@implementation ReconmendCollectionCell
{
    UIImageView *image;
    UILabel *nameLab;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        image = [[UIImageView alloc]init];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 8;
        [self.contentView addSubview:image];
        
        nameLab = [[UILabel alloc]init];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.numberOfLines = 0;
//        nameLab.shadowColor = XColorWithRBBA(0, 0, 0, 0.16);
//        nameLab.shadowOffset = CGSizeMake(0, 1);
        [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [nameLab setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
        [self.contentView addSubview:nameLab];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(16));
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(AdaptationWidth(34));

    }];

    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(9));
        make.centerX.mas_equalTo(image.mas_centerX);
//        make.width.mas_equalTo(AdaptationWidth(48));
//        make.left.mas_equalTo(image).offset(AdaptationWidth(8));
//        make.right.mas_equalTo(image).offset(-AdaptationWidth(8));
    }];
    [super updateConstraints];
}
- (void)configureWith:(SpecialEntryModel *)model indexPath:(NSInteger)row {
//    image.backgroundColor = XColorWithRGB(168, 226, 225);
    [image sd_setImageWithURL:[NSURL URLWithString:model.special_entry_list[row][@"special_entry_icon"]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",model.special_entry_list[row][@"special_entry_title"]]];
}
- (void)SpecialconfigureWith:(NSMutableArray *)modelArr indexPath:(NSInteger)row {
    if (row >= modelArr.count) {
        return;
    }
//    image.backgroundColor = XColorWithRGB(168, 226, 225);
    [image sd_setImageWithURL:[NSURL URLWithString:modelArr[row][@"loan_classify_logo"]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",modelArr[row][@"loan_classify_name"]]];
}
@end
