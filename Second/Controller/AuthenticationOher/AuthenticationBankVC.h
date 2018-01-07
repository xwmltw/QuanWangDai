//
//  AuthenticationBankVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ScanningBankVC.h"
#import "BankInfoModel.h"

@interface AuthenticationBankVC : ScanningBankVC
@property (nonatomic, assign) BOOL isScanBan;
@property (nonatomic, strong) BankInfoModel *bankInfoModel;
@end
