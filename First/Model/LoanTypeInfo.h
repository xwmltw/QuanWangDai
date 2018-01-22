//
//  LoanTypeInfo.h
//  QuanWangDai
//
//  Created by yanqb on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanTypeInfo : NSObject
@property (nonatomic, copy) NSString *md5_hash;
@property (nonatomic, strong) NSArray *loan_classify_list;
+ (instancetype)sharedInstance;
- (void)saveLoanTypeInfo:(id)info;
- (LoanTypeInfo *)getLoanTypeInfo;
@end
//“md5_hash”: “xxxxx”, // 列表的MD5
//“loan_classify_list”:[  // 如果列表的 hash未改变，则传递空的数组
//                      {
//                          “loan_product_type”: xxx // 产品分类：1,2,3,4,5(ABCDE)
//                          “loan_classify_id”: xxx, // 贷款类型id
//                          “loan_classify_name”: “xxx”, // 贷款类型名称
//                      }
//                      ],

