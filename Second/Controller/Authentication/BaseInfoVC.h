//
//  BaseInfoVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "CreditInfoModel.h"
typedef NS_ENUM(NSInteger , BaseInfoTableViewCell) {
    BaseInfoTableViewCellMarriage,
    BaseInfoTableViewCellCity,
    BaseInfoTableViewCellMyAddress,
    BaseInfoTableViewCellRelative,
    BaseInfoTableViewCellParentsPhone,
    BaseInfoTableViewCellRelativeCity,
    BaseInfoTableViewCellRelativeAddress,
    BaseInfoTableViewCellContactRelation,
    BaseInfoTableViewCellContactPhone,
    
};
@interface BaseInfoVC : XBaseViewController
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end
