//
//  RecommendTableViewSecond.h
//  QuanWangDai
//
//  Created by yanqb on 2018/4/18.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface RecommendTableViewSecond : UITableViewCell
@property (nonatomic, strong) ProductModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellMoney;
@property (weak, nonatomic) IBOutlet UILabel *cellDetail;
@property (weak, nonatomic) IBOutlet UILabel *cellInfo;
@property (weak, nonatomic) IBOutlet UIView *cellInfobgView;

@end
