//
//  BaseInfoCellText.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/25.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfoVC.h"
#import "BaseInfoModel.h"

@protocol BaseInfoCellTextDelegate<NSObject>
- (void)textBtnOnClick:(UITextField *)textField;
@end

@interface BaseInfoCellText : UITableViewCell
@property (nonatomic ,weak) id <BaseInfoCellTextDelegate>delegate;

- (void)setDataModel:(BaseInfoModel*)model with:(NSUInteger)row;
@end
