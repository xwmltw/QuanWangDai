//
//  InformationCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "InformationCell.h"
#import "DateHelper.h"
@implementation InformationCell
-(void)setModel:(ImformationDetailModel *)model{
    self.mian_title.text = model.artical_title;
    self.mian_title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    [self.ImageView setCornerValue:2.0];
    if (model.cover_img_url.length) {
        [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_img_url]];
    }else{
        self.ImageView.image = [UIImage imageNamed:@"loading_page"];
    }
    
    self.time_label.text = [DateHelper getDateFromTimeNumber:model.update_time withFormat:@"yyyy/MM/dd"];
    self.time_label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
    if (model.read_num.length) {
        if (model.read_num.integerValue > 10000) {
            self.read_number.text = [NSString stringWithFormat:@"%.1f万 阅读",model.read_num.floatValue/10000];
        }else if (model.read_num.integerValue > 1000000){
            self.read_number.text = @"100万+ 阅读";
        }else{
            self.read_number.text = [NSString stringWithFormat:@"%@ 阅读",model.read_num];
        }
    }else{
        self.read_number.hidden = YES;
    }
    self.read_number.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
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
