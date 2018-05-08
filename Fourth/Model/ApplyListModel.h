//
//  ApplyListModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/19.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyListModel : NSObject
@property (nonatomic, copy) NSString *loan_pro_id;
@property (nonatomic, copy) NSString *loan_pro_name;
@property (nonatomic, copy) NSString *loan_pro_logo_url;
@property (nonatomic, copy) NSNumber *loan_pro_status;
@property (nonatomic, copy) NSString *apply_loan_amount;
@property (nonatomic, copy) NSString *apply_loan_days;
@property (nonatomic, copy) NSNumber *loan_deadline_type;
@property (nonatomic, copy) NSNumber *apply_time;
@property (nonatomic, copy) NSNumber *apply_status;
@property (nonatomic, copy) NSString *contact_wechat_number;
@property (nonatomic, copy) NSString *contact_wechat_public;
@property (nonatomic, copy) NSString *contact_qq;
@property (nonatomic, copy) NSString *contact_telephone;
@end
//“loan_pro_id”: xxx // 贷款产品uuid
//“loan_pro_name”: “xxx”, // 产品名称
//“loan_pro_logo_url”: “xxx”, // 产品图标
//“loan_pro_status”: “xxx”, // 产品状态： 1上架中 2已下架
//“apply_loan_amount”: //申请金额(单位为分)
//“apply_loan_days”: //申请借款天数
//“loan_deadline_type”: “xxx”, // 用户借款期限类型 1天 2月
//“apply_time”: //申请时间
//“apply_status”: //申请状态: 0待审核 1审核中 2审核不通过 3审核通过
//4成功放款 5已结束
//“contact_wechat_number”: “xxx”, // 微信号
//“contact_wechat_public”: “xxx”, // 微信公众号
//“contact_qq”: “xxx”, // 联系qq
//“contact_telephone”: “xxx”, // 联系手机号
