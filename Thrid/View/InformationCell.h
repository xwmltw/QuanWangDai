//
//  InformationCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImformationDetailModel.h"
@interface InformationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mian_title;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *read_number;
@property (nonatomic,strong) ImformationDetailModel *model;
@end
