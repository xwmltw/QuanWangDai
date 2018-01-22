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
        nameLab.textAlignment = NSTextAlignmentLeft;
        nameLab.numberOfLines = 0;
        nameLab.shadowColor = XColorWithRBBA(0, 0, 0, 0.16);
        nameLab.shadowOffset = CGSizeMake(0, 1);
        [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(13)]];
        [nameLab setTextColor:XColorWithRGB(255, 255, 255)];
        [image addSubview:nameLab];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(6));
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(5));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(5));
        make.bottom.mas_equalTo(self.contentView).offset(-AdaptationWidth(6));
    }];

    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image).offset(AdaptationWidth(10));
        make.left.mas_equalTo(image).offset(AdaptationWidth(8));
        make.right.mas_equalTo(image).offset(-AdaptationWidth(8));
    }];
    [super updateConstraints];
}
- (void)configureWith:(SpecialEntryModel *)model indexPath:(NSInteger)row {
    image.backgroundColor = XColorWithRGB(168, 226, 225);
    [image sd_setImageWithURL:[NSURL URLWithString:model.special_entry_list[row][@"special_entry_icon"]]];
//    [image setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"selectedimage"][row]]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",model.special_entry_list[row][@"special_entry_title"]]];
}
@end
