//
//  WorkInfoTableViewCell.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkInfoModel.h"
@interface WorkInfoTableViewCell : UITableViewCell
- (void)setCellWith:(WorkInfoModel *)model indexPath:(NSInteger)row;
@property (nonatomic ,copy)XBlock block;
@end
