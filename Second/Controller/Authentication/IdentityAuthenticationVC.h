//
//  IdentityAuthenticationVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/21.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "CreditInfoModel.h"
@interface IdentityAuthenticationVC : XBaseViewController
@property (nonatomic, strong)CreditInfoModel *creditInfoModel;
@property (nonatomic ,copy) NSNumber *isBlock;//1专属认证流程 2运营商报告流程 3信贷预测
@end
