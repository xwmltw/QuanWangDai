//
//  RecommendTableViewCell.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface RecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *quota;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *date_type;
@property (weak, nonatomic) IBOutlet UILabel *interestRate;
@property (weak, nonatomic) IBOutlet UILabel *typelabel;
@property (weak, nonatomic) IBOutlet UIView *appState;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (nonatomic, strong) ProductModel *model;
- (void)setDetailColor:(BOOL)type quotaSelect:(BOOL)quota dataSelect:(BOOL)data;
@end
