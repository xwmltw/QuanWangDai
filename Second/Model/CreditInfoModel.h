//
//  CreditInfoModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditInfoModel : NSObject
@property (nonatomic, copy) NSString *credit_level;
@property (nonatomic, copy) NSString *complete_schedule;
@property (nonatomic, copy) NSNumber *identity_status;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *identity_card;
@property (nonatomic, copy) NSNumber *base_info_status;
@property (nonatomic, copy) NSNumber *zhima_status;
@property (nonatomic, copy) NSNumber *operator_status;
@property (nonatomic, copy) NSNumber *verify_yys_again;
@property (nonatomic, copy) NSNumber *bank_status;
@property (nonatomic, copy) NSNumber *loan_info_status;
@property (nonatomic, copy) NSNumber *company_status;
@property (nonatomic, copy) NSNumber *applicant_qualification_status;
+ (instancetype)sharedInstance;
- (void)saveCreditStateInfo:(id)info;
- (CreditInfoModel *)getCreditStateInfo;
@end
//“credit_level”: “xxxx”, // 信用等级 BCDE
//“complete_schedule”: “50%”, // 资料填写进度
//“identity_status”: “xxxxxxx”,  // 身份信息状态 1已认证 0未认证
//“true_name”:xxxx // 姓名(identity_status=1下发)
//“sex”:xxxx // 性别(identity_status=1下发)
//“identity_card”:xxxx // 身份证号(identity_status=1下发)
//“base_info_status”: “xxxxxxx”,  //基本信息填写状态 1已填写 0未填写
//“zhima_status”: “xxxxxxx”,  // 芝麻认证状态 1已认证 0未认证
//“operator_status”: “xxxxxxx”,  // 运营商认证状态 1已认证 0未认证
//“bank_status”: “xxxxxxx”,  // 银行卡认证状态 1已认证 0未认证
//“loan_info_status”: “xxxxxxx”,  //贷款信息填写状态 1已填写 0未填写
//“company_status”: “xxxxxxx”,  //工作信息填写状态 1已填写 0未填写
//“applicant_qualification_status”: “xxxxxxx”,  //申请人资质资料填写状态 1已填写 0未填写
//verify_yys_again”: “xxxx”,  // 是否需要重新运营商认证 1需要0不需要

