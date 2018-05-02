//
//  RecommendTableViewCell.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
@protocol RecommendTableViewCellDelegate <NSObject>

- (void)isSelectedOrNot:(UIButton *)button;

@end

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
@property (weak, nonatomic) IBOutlet UIButton *selected_btn;
@property (nonatomic, strong) ProductModel *model;
@property (nonatomic ,copy) NSNumber *isSuccessApp;
@property (nonatomic, weak) id<RecommendTableViewCellDelegate> delegate;
- (void)setDetailColor:(BOOL)type quotaSelect:(BOOL)quota dataSelect:(BOOL)data;
@end
