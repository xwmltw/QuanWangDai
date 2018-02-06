//
//  ProductModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
@property (nonatomic, copy) NSString *loan_pro_id;
@property (nonatomic, copy) NSString *loan_pro_name;
@property (nonatomic, copy) NSString *loan_pro_logo_url;
@property (nonatomic, copy) NSString *loan_min_credit;
@property (nonatomic, copy) NSString *loan_max_credit;
@property (nonatomic, copy) NSString *loan_credit_str;
@property (nonatomic, copy) NSString *loan_min_deadline;
@property (nonatomic, copy) NSString *loan_max_deadline;
@property (nonatomic, copy) NSString *loan_deadline_str;
@property (nonatomic, copy) NSNumber *loan_deadline_type;
@property (nonatomic, copy) NSNumber *loan_rate_type;
@property (nonatomic, copy) NSString *min_loan_rate;
@property (nonatomic, copy) NSString *loan_rate;
@property (nonatomic, copy) NSString *loan_year_rate;
@property (nonatomic, copy) NSString *run_address_name;
@property (nonatomic, copy) NSString *hot_label;
@property (nonatomic, copy) NSNumber *apply_is_full;
@property (nonatomic, copy) NSString *apply_required_data;
@property (nonatomic, copy) NSString *loan_pro_slogan;
@property (nonatomic, copy) NSNumber *be_staged;
@property (nonatomic, copy) NSArray *loan_need_data;
@property (nonatomic, copy) NSArray *loan_condition;
@property (nonatomic, copy) NSArray *loan_process;
@property (nonatomic, copy) NSNumber *cooperation_type;
@property (nonatomic, copy) NSString *cooperation_url;
@property (nonatomic, copy) NSString *recommend_desc;
@end
//“loan_pro_id”: xxx // 贷款产品uuid
//“loan_pro_name”: “xxx”, // 产品名称
//“loan_pro_logo_url”: “xxx”, // 产品图标
//“loan_min_credit”:xxxx // 最小额度
//“loan_max_credit”:xxxx // 最大额度
//“loan_credit_str”: “xxx”, // 产品可贷额度描述 1000-5000
//“loan_min_deadline”:xxxx // 最小借款期限
//“loan_max_deadline”:xxxx // 最大借款期限
//“loan_deadline_str”: “xxx”, // 用户借款期限描述 7-14
//“loan_deadline_type”: “xxx”, // 用户借款期限类型 1天 2月
//“loan_rate_type”: xxx // 利率类型1日利率 2月利率 3年利率
//“min_loan_rate”: xxx // 最小利率
//“loan_rate”: xxx // 最大利率
//“loan_year_rate” : xxxx //年利率
//“run_address_name”: xxxx // 经营区域名称，为空代表全国
//“recommend_desc”: “xxx”, // 推荐描述

//“hot_label”: xxx // 热门标签
//“apply_is_full”: xxx // 申请人数已满: 1是 0否
//“apply_required_data”:xxx // 产品申请必填资料,字符串类型,  1,2,3,4，详见枚举定义
//
//IDENTITYCARD(1,"身份证"),
//BASICINFO(2,"基本信息认证"),
//ZMXY(3,"芝麻信用认证"),
//JXLINFO(4,"运营商认证"),
//CREDITINFO(5,"银行卡信息"),
//LOANINFO(6,"借贷平台"),
//BUSINESSINFO(7,"工作信息");

//“loan_pro_slogan”: “xxx”, // 产品slogan
//“be_staged”:xxxx // 是否可以分期 1是 0否
//“loan_need_data”:xxxx // 借款所需材料，json数组[“111”,”2222”]
//“loan_condition”:xxxx // 借款申请条件,json数组字符串[“111”,”2222”]
//“loan_process”:xxxx // 借款申请流程, json数组[“111”,”2222”]
//“cooperation_type”: “xxx”, // 产品合作方式：1落地页 2注册信息对接 3商户后台
//“cooperation_url”: “xxx”, // 合作方提供的跳转链接

