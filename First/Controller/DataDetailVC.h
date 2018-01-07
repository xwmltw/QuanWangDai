//
//  DataDetailVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/11.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ProductModel.h"

@interface DataDetailVC : XBaseViewController
@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, copy) NSString *apply_loan_amount;//申请金额
@property (nonatomic, copy) NSString *apply_loan_days;//申请日期
@end
