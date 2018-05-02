//
//  FailApplicantionController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/17.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ApplyProductModel.h"
@interface FailApplicantionController : XBaseViewController
@property (nonatomic, strong) ApplyProductModel *applyProductModel;
@property (nonatomic, copy) NSNumber *errCode; //33 用户资质不符合产品要求 35 30天重复申请
@end
