//
//  ApplicantModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicantModel : NSObject
@property (nonatomic,copy) NSString *qualification_info_id;
@property (nonatomic,copy) NSString *loan_usage;
@property (nonatomic,copy) NSNumber *professional_identity;
@property (nonatomic,copy) NSNumber *payroll_type;
@property (nonatomic,copy) NSNumber *working_years;
@property (nonatomic,copy) NSNumber *has_accumulation_fund;
@property (nonatomic,copy) NSNumber *has_social_security;
@property (nonatomic,copy) NSNumber *has_house_property;
@property (nonatomic,copy) NSNumber *relatives_has_house_property;
@property (nonatomic,copy) NSNumber *has_car_property;
@property (nonatomic,copy) NSNumber *credit_info;
@end
//“qualification_info_id”:xxxx , // 信息id,上传该字段代表作修改操作
//“loan_usage”: “xxxx”, // 借款用途
//“professional_identity”: “xxxx”, // 职业身份
//“payroll_type”: “xxxx”, // 工资发放形式
//“working_years”: “xxxx”, // 工龄
//“has_accumulation_fund”: “xxxx”, // 是否拥有本地公积金：1是 0否
//“has_social_security”: “xxxx”, // 是否拥有本地社保：1是 0否
//“has_house_property”: “xxxx”, // 是否拥有房产：1是 0否
//“relatives_has_house_property”: “xxxx”, // 亲属是否拥有房产：1是 0否
//“has_car_property”: “xxxx”, // 名下是否有车：1是 0否
//“credit_info”: “xxxx”, // 信用情况

