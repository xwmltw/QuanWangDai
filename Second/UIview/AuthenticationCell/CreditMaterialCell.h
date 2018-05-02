//
//  CreditMaterialCell.h
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditInfoModel.h"

@interface CreditMaterialCell : UICollectionViewCell
- (void)configureWithFirst:(id)dic indexPath:(NSInteger)row model:(CreditInfoModel*)model;
- (void)configureWith:(id)dic indexPath:(NSInteger)row model:(CreditInfoModel*)model;
@end
