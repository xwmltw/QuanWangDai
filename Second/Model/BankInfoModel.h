//
//  BankInfoModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankInfoModel : NSObject
@property (nonatomic, copy) NSString *bank_card_no;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *bank_logo;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *true_name;
@property (nonatomic, copy) NSString *sms_authentication_code;
@end
//“bank_card_no”: “xxxx”, // 银行卡卡号
//“bank_name”: “中国光大银行”, // 银行名称
//“bank_logo”: “”, // 银行图标
//“phone”: “xxxxxx”, // 银行卡绑定的手机号
//“true_name”: “xxxxxx”, // 银行卡持卡人姓名
//sms_authentication_code //短信

