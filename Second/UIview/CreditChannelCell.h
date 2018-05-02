//
//  CreditChannelCell.h
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreditPassDelegate<NSObject>
- (void)pushAllDK:(UIButton *)button;
@end
@interface CreditChannelCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *leftbtn;
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic,strong) UIButton *rightbtn;
@property (nonatomic,strong) UILabel *rightlab;
@property (nonatomic ,weak) id <CreditPassDelegate>delegate;
@end
