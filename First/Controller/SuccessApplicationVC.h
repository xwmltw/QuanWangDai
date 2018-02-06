//
//  SuccessApplicationVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ApplyProductModel.h"
@interface SuccessApplicationVC : XBaseViewController
@property (nonatomic, strong) ApplyProductModel *applyProductModel;
@property (nonatomic, copy) NSNumber *errCode; //33用户资质不符合产品要求
@end
