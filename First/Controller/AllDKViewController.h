//
//  AllDKViewController.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/10.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"

@interface AllDKViewController : XBaseViewController
@property (nonatomic ,assign) NSInteger typeIndex;
@property (nonatomic ,assign) NSInteger quotaIndex;
@property (nonatomic ,assign) NSInteger dataIndex;
@property (nonatomic ,assign) NSInteger sortIndex;
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic, copy) NSNumber *special_entry_id; //特色入口id
@property (nonatomic, copy) NSNumber *loan_product_type;// 产品分类：1,2,3,4,5(ABCDE)
@property (nonatomic, copy) NSString *loan_classify_ids_str;// 贷款类型id字串 (例如：11,12,13)
@end

