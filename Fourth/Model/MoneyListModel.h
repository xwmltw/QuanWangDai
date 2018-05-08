//
//  MoneyListModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/19.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyListModel : NSObject
@property (nonatomic, copy) NSString *money_detail_title;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, copy) NSString *actual_amount;
@end
//“money_detail_title”: <string>流水标题
//“create_time”: <long>创建时间 从1970年1月1日至今的毫秒数
//“actual_amount”: <int>明细产生的金额，单位为分

