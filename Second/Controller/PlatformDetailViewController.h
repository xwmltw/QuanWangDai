//
//  PlatformDetailViewController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//
@class PlatformDetailModel;
#import "XBaseViewController.h"

@interface PlatformDetailViewController : XBaseViewController
/** 标题 */
@property (nonatomic,copy) NSString *name;
/** 模型 */
@property (nonatomic,strong) PlatformDetailModel *model;
@end
