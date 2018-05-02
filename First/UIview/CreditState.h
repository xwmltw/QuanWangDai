//
//  CreditState.h
//  QuanWangDai
//
//  Created by yanqb on 2018/3/30.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditInfoModel.h"
@interface CreditState : NSObject

+ (void)selectCreaditState:(UIViewController *)controller with:(CreditInfoModel *)model;
+ (BOOL)creditStateWith:(CreditInfoModel *)model;
+ (void)selectOperatorCreaditState:(UIViewController *)controller;
+ (void)selectIdentityCreaditState:(UIViewController *)controller;
@end
