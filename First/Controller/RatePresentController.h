//
//  RatePresentController.h
//  QuanWangDai
//
//  Created by mac on 2018/4/11.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ProductModel.h"
@interface RatePresentController : XBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *Interest_rates;
@property (weak, nonatomic) IBOutlet UILabel *service_fee;
@property (weak, nonatomic) IBOutlet UILabel *poundage;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateConstraint;
@property (weak, nonatomic) IBOutlet UILabel *server_lab;
@property (weak, nonatomic) IBOutlet UILabel *service_lab;
@property (nonatomic,copy) NSString *moneyStr;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic, strong) ProductModel *model;
@end
