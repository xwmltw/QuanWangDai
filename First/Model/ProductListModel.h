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
@end
