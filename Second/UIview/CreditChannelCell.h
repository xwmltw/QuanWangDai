//
//  CreditChannelCell.h
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreditPassDelegate<NSObject>
- (void)pushAllDK;
@end
@interface CreditChannelCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UILabel *lab;
@property (nonatomic ,weak) id <CreditPassDelegate>delegate;
@end
