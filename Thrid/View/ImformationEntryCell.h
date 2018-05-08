//
//  ImformationEntryCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialEntryModel.h"
@interface ImformationEntryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *entry_image;
@property (weak, nonatomic) IBOutlet UILabel *miantitle;
@property (weak, nonatomic) IBOutlet UILabel *subdiscrition;
@property (nonatomic,strong) SpecialEntryModel *model;
-(void)setupmodel:(SpecialEntryModel *)model indexpath:(NSInteger)row;
@end
