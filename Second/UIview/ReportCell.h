//
//  ReportCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportModel.h"

@interface ReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_distance;
@property (weak, nonatomic) IBOutlet UIImageView *card_view;     // 背景图片
@property (weak, nonatomic) IBOutlet UILabel *report_name;       // 报告名称
@property (weak, nonatomic) IBOutlet UILabel *report_state;      // 支付状态
@property (weak, nonatomic) IBOutlet UIButton *report_example;   // 报告示例按钮
@property (weak, nonatomic) IBOutlet UILabel *report_discrption; // 描述
@property (weak, nonatomic) IBOutlet UIButton *pay_button;       // 支付按钮
@property (weak, nonatomic) IBOutlet UILabel *reporting;         // 报告获取中
@property (weak, nonatomic) IBOutlet UIView *lineView;           // 垂直分割线
@property (nonatomic,strong) ReportDetailModel *detailModel;

@end
