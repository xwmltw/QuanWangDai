//
//  WorkInfoModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkInfoModel : NSObject
@property (nonatomic ,copy) NSString *company_name;
@property (nonatomic ,copy) NSString *company_province;
@property (nonatomic ,copy) NSString *company_city;
@property (nonatomic ,copy) NSString *company_town;
@property (nonatomic ,copy) NSString *company_address;
@property (nonatomic ,copy) NSString *company_phone;
@property (nonatomic ,copy) NSString *job_name;
@property (nonatomic ,copy) NSString *job_salary;
@property (nonatomic ,copy) NSString *job_pay_salary_day;
@end
//“company_name: “xxxx”, // 公司名称
//“company_province: “xxxx”, // 公司所在省份名称
//“company_city: “xxxx”, // 公司所在城市名称
//“company_town: “xxxx”, // 公司所在区县名称
//“company_address: “xxxx”, // 公司所在地详细地址
//“company_phone: “xxxx”, // 公司电话
//“job_name: “xxxx”, // 工作岗位
//“job_salary: “xxxx”, // 月收入
//“job_pay_salary_day: “xxxx”, // 发薪日

