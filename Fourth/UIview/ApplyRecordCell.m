//
//  ApplyRecordCell.m
//  QuanWangDai
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ApplyRecordCell.h"
#import "DateHelper.h"
@implementation ApplyRecordCell


-(void)setModel:(ApplyListModel *)model{
	[self.headImage sd_setImageWithURL:[NSURL URLWithString:model.loan_pro_logo_url]];
    [self.headImage setCornerValue:4];
	self.headName.text = model.loan_pro_name;
    self.money.text = [NSString stringWithFormat:@"· 借款金额 (元)：%ld",model.apply_loan_amount.integerValue /100];
    switch ([model.loan_deadline_type integerValue]) {
        case 1:
            self.date.text = [NSString stringWithFormat:@"· 借款期限 (天)：%@",model.apply_loan_days];
            break;
        case 2:
            self.date.text = [NSString stringWithFormat:@"· 借款期限 (月)：%@",model.apply_loan_days];
            break;
        default:
            break;
    }
    
	[self.statebgView setCornerValue:2];
    
    self.time.text = [NSString stringWithFormat:@"%@",[DateHelper getDateFromTimeNumber:model.apply_time withFormat:@"yyyy/M/d, HH:mm:ss"]];
    switch (model.apply_status.integerValue) {
        case 0:
            self.state.text = @"待审核";
            break;
        case 1:
            self.state.text = @"审核中";
            break;
        case 2:
            self.state.text = @"审核不通过";
            break;
        case 3:
            self.state.text = @"审核通过";
            break;
        case 4:
            self.state.text = @"成功放款";
            break;
        case 5:
            self.state.text = @"已结束";
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
