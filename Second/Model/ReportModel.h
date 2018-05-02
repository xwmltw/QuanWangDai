//
//  ReportModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/19.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReportDetailModel;
@interface ReportModel : NSObject
@property (nonatomic,strong) ReportDetailModel *td_report;
@property (nonatomic,strong) ReportDetailModel *yys_report;
@end

@interface ReportDetailModel : ReportModel
@property (nonatomic,copy) NSNumber *report_price;
@property (nonatomic,copy) NSString *report_example_url;
@property (nonatomic,copy) NSNumber *buy_report_status;
@property (nonatomic,copy) NSNumber *get_report_status;
@property (nonatomic,copy) NSString *report_url;
@property (nonatomic,copy) NSString *report_true_name;
@property (nonatomic,copy) NSString *report_id_card_num;
@end
//“yys_report”:{ // 运营商报告
//    “report_price”: “xxxx”, // 报告价格：单位为分
//    “report_example_url”: “xxxx”, // 报告示例地址
//    “buy_report_status”: “xxxx”, 报告购买状态// 0未购买1已购买
//    “get_report_status”: “xxxx”, // 0 获取中1获取成功 2获取失败
//    “report_url”: “xxxx”, // 获取报告详情地址
//    “report_true_name”: “xxxx”, // 姓名
//    “report_id_card_num”: “xxxx”, // 身份证号码
//}
//“td_report”:{ // 信贷预测报告
//    　　“report_price”: “xxxx”, // 报告价格：单位为分
//    “report_example_url”: “xxxx”, // 报告示例地址
//    “buy_report_status”: “xxxx”, 报告购买状态// 0未购买1已购买
//    “get_report_status”: “xxxx”, // 0 获取中1获取成功 2获取失败
//    “report_url”: “xxxx”, // 获取报告详情地址
//    “report_true_name”: “xxxx”, // 姓名
//    “report_id_card_num”: “xxxx”, // 身份证号码
//}

