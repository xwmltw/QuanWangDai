//
//  ApplicantCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicantManVC.h"
#import "ApplicantModel.h"

@interface ApplicantCell : UITableViewCell
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *detailLab;
- (void)setDataModel:(ApplicantModel*)model with:(NSUInteger)row;
@end
