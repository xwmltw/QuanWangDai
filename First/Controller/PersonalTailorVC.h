//
//  PersonalTailorVC.h
//  QuanWangDai
//
//  Created by yanqb on 2018/1/31.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"

@interface PersonalTailorVC : XBaseViewController
@property (nonatomic ,assign) NSInteger typeIndex;
@property (nonatomic ,assign) NSInteger quotaIndex;
@property (nonatomic ,assign) NSInteger dataIndex;
@property (nonatomic ,assign) NSInteger sortIndex;
@property (nonatomic ,copy) NSNumber *isAllProduct;//1全流程 2半流程
@end
