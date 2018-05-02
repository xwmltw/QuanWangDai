//
//  BaseInfoCellView.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/25.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfoVC.h"
#import "BaseInfoModel.h"

@protocol BaseInfoCellViewDelegate<NSObject>

- (void)ViewBtnOnClick:(UITextField *)tag;
@end

@interface BaseInfoCellView : UITableViewCell
@property (nonatomic ,weak) id <BaseInfoCellViewDelegate>delegate;

- (void)setDataModel:(BaseInfoModel*)model with:(NSUInteger)row;
@end
