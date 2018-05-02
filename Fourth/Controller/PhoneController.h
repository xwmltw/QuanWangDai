//
//  PhoneController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/13.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ApplyListModel.h"
@interface PhoneController : XBaseViewController
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (nonatomic, strong) ApplyListModel *model;
@end
