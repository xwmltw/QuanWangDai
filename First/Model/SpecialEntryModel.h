//
//  SpecialEntryModel.h
//  QuanWangDai
//
//  Created by yanqb on 2018/1/19.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialEntryModel : NSObject

@property (nonatomic, copy) NSString *md5_hash;
@property (nonatomic, strong) NSArray *special_entry_list;

+ (instancetype)sharedInstance;
- (void)saveSpecialEntryModel:(id)info;
- (SpecialEntryModel *)getSpecialEntryModel;
@end
//“special_entry_list”:
//{
// is_need_login 1是0否 ，默认0
//    “special_entry_id” : <long>特色入口id
//    “special_entry_title”: <string> 特色入口标题
//    “special_entry_type”:<int>特色入口类型
//    “special_entry_url”:<string>特色入口url
//    “special_entry_icon”:<string>特色入口图标url
//
//    special_entry_type=3时下发下面字段：
//    “loan_product_type”: xxx // 产品分类：1,2,3,4,5(ABCDE)
//    “loan_classify_ids_str”: xxx, // 贷款类型id字串 (例如：11,12,13)
//    (说明：
//     loan_product_type为空时代表全部分类(即贷款大全)
//     loan_product_type不为空，loan_classify_ids_str为空代表
//     loan_product_type对应的分类)
//    },
//    “md5_hash”: <string> 特色入口信息的MD5摘要，如果客户端上传的与服务端一致，则无需再次下发

