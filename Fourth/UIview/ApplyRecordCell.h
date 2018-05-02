//
//  ApplyRecordCell.h
//  QuanWangDai
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyListModel.h"
@interface ApplyRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *headName;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UIView *statebgView;
@property (weak, nonatomic) IBOutlet UIButton *business;
@property (nonatomic, strong) ApplyListModel *model;
@end
