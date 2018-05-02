//
//  ReconmendCollectionCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/18.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialEntryModel.h"
//#import "LoanTypeInfo.h"
@interface ReconmendCollectionCell : UICollectionViewCell
- (void)configureWith:(SpecialEntryModel *)model indexPath:(NSInteger)row ;
- (void)SpecialconfigureWith:(NSMutableArray *)modelArr indexPath:(NSInteger)row ;
@end
