//
//  SpecialController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/23.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"

@interface SpecialController : XBaseViewController
@property (nonatomic ,assign) NSInteger typeIndex;
@property (nonatomic ,assign) NSInteger quotaIndex;
@property (nonatomic ,assign) NSInteger dataIndex;
@property (nonatomic ,assign) NSInteger sortIndex;
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic, copy) NSNumber *special_entry_id; //特色入口id
@property (nonatomic, copy) NSNumber *loan_product_type;// 产品分类：1,2,3,4,5(ABCDE)
@property (nonatomic, copy) NSString *loan_classify_ids_str;// 贷款类型id字串 (例如：11,12,13)
@property (nonatomic, copy) NSNumber *list_properties;
@end
