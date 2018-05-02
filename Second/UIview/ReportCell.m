//
//  ReportCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell
-(void)setDetailModel:(ReportDetailModel *)detailModel{
    
    /*!< 支付按钮 >*/
    [self.pay_button setCornerValue:2];
    [self.pay_button setTitle:[NSString stringWithFormat:@"￥%.2f 查看",detailModel.report_price.floatValue /100] forState:UIControlStateNormal];
    
    if (detailModel.buy_report_status.integerValue == 0) {
        /*!< 未购买 >*/
        self.top_distance.constant = AdaptationWidth(48);
        self.report_state.hidden = YES;
    }else{
        /*!< 已购买 >*/
        self.top_distance.constant = AdaptationWidth(28);
        self.report_state.hidden = NO;
        self.report_state.text = @"已支付";
        switch (detailModel.get_report_status.integerValue) {
            case 0:{ // 报告获取中
                self.report_discrption.hidden = YES;
                self.pay_button.hidden = YES;
                self.report_example.hidden = YES;
                self.lineView.hidden = YES;
                self.reporting.hidden = NO;
            }
                break;
            case 1:{ // 获取成功
                self.lineView.hidden = YES;
                self.report_example.hidden = YES;
                self.report_discrption.hidden = YES;
                NSString *car = [detailModel.report_id_card_num stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"***********"];
                self.report_state.text = [NSString stringWithFormat:@"%@, %@",detailModel.report_true_name,car];
                [self.pay_button setTitle:@"查看报告" forState:UIControlStateNormal];
            }
                break;
            case 2:{ // 获取失败
                self.lineView.hidden = YES;
                self.report_example.hidden = YES;
                self.report_discrption.text = @"获取失败，点击免费重查 →";
                [self.pay_button setTitle:@"免费重查" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
    }
    /*!< 报告示例 >*/
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"报告示例"];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                  range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:XColorWithRBBA(255, 255, 255, 1) range:titleRange];
    [self.report_example setAttributedTitle:title forState:UIControlStateNormal];
    [self.report_example.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    /*!< 描述 >*/
    [self.report_discrption setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
    [self.reporting setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
    
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
