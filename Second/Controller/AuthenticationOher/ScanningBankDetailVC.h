//
//  ScanningBankDetailVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ScanningBankVC.h"
#import "BankInfoModel.h"

typedef void(^ScannngBankDetail)(NSString *bankName,NSString *bankNumer);
@interface ScanningBankDetailVC : ScanningBankVC
@property (nonatomic, strong) BankInfoModel *model;
@property (nonatomic, strong) UIImage *bankImage;
@property (nonatomic, copy) ScannngBankDetail block;
@end
