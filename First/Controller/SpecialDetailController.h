//
//  SpecialDetailController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/23.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ProductListModel.h"
@interface SpecialDetailController : XBaseViewController
@property (nonatomic ,copy) NSString *titleStr;
@property (nonatomic ,strong) ProductListModel *productListModel;
@end
