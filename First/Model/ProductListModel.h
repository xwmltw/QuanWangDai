//
//  ProductListModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamModel.h"
@interface ProductListModel : NSObject
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, copy) NSNumber *order_type;
@property (nonatomic, copy) NSNumber *loan_pro_type;
@property (nonatomic, copy) NSNumber *loan_credit;
@property (nonatomic, copy) NSNumber *loan_deadline;
@property (nonatomic, copy) NSString *loan_classify_id;
@property (nonatomic, copy) NSNumber *special_entry_id;
@property (nonatomic ,copy) NSNumber *query_entry_type;
@property (nonatomic ,copy) NSNumber *cooperation_type;
@property (nonatomic ,copy) NSNumber *pre_loan_visit;
@property (nonatomic ,copy) NSNumber *shop_visit;

@end
//“query_param”:{
//    // 查询参数，请参考全局数据结构
//},
//“order_type”: xxx /// 列表排序 : 1贷款利率
//“loan_pro_type”: xxxx // 贷款产品类型：
//1低息贷款2分期借贷3小额速贷4一定能贷
//loan_deadline、、期限
//“loan_classify_id”: xxxx // 贷款类型id
//“loan_credit”: xxxx // 贷款产品额度
//special_entry_id 特色入口id
//query_entry_type查询入口：0申请推荐列表(报名后的页面) 1私人订制列表 2查询是否有推荐数据
//“cooperation_type”: “xxx”, // 产品合作方式：1落地页 2注册信息对接 3商户后台
//“pre_loan_visit”: “xxxxx” 是否需要贷前回访：1需要 0不需要
//“shop_visit”: “xxxxx” 是否需要到店回访：1需要 0不需要

