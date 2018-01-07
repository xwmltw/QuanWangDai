//
//  PlatformModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//
@class PlatformDetailModel;
#import <Foundation/Foundation.h>

@interface PlatformModel : NSObject
/** 模型数组 */
@property (nonatomic,strong) NSArray<PlatformDetailModel *> *loan_plat_list;

@end

@interface PlatformDetailModel : NSObject
@property (nonatomic,copy) NSString *plat_info_id;
@property (nonatomic,copy) NSString *plat_type;
@property (nonatomic,copy) NSString *plat_status;
@property (nonatomic,copy) NSString *plat_account;
@property (nonatomic,copy) NSString *plat_account_pwd;
@end

//“plat_info_id” :xxxx , // 平台信息id
//“plat_type: “xxxx”, // 平台类型：
//1借贷宝 2今借到 3无忧借条 4米房借条
//“plat_status: “xxxx”, // 信息填写状态 1已填写 0未填写
//“plat_account: “xxxx”, // 平台账号
//“plat_account_pwd: “xxxx”, // 平台账号密码
