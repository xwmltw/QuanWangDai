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
@end
//“query_param”:{
//    // 查询参数，请参考全局数据结构
//},
//“order_type”: xxx /// 列表排序 : 1贷款利率
//“loan_pro_type”: xxxx // 贷款产品类型：
//1低息贷款2分期借贷3小额速贷4一定能贷
//“loan_classify_id”: xxxx // 贷款类型id
//“loan_credit”: xxxx // 贷款产品额度

