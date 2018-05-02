//
//  ReportOrderModel.h
//  QuanWangDai
//
//  Created by yanqb on 2018/4/20.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportOrderModel : NSObject

@property (nonatomic,copy) NSString *recharge_amount;
@property (nonatomic,copy) NSNumber *pay_channel;
@property (nonatomic,copy) NSNumber *pay_channel_type;
@property (nonatomic,copy) NSString *client_time_millseconds;
@property (nonatomic,copy) NSString *report_order_id;
@end
//“recharge_amount” : // 支付金额，单位为分
//“pay_channel”: // 参考全局变量[支付渠道相关]
//“pay_channel_type”: // 参考全局变量[支付渠道相关]
//“client_time_millseconds”:xxx // 必填, 客户端请求时间戳
//“report_order_id”: xxx// 信用报告订单id

