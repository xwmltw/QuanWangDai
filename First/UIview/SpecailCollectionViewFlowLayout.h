//
//  SpecailCollectionViewFlowLayout.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/23.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecailCollectionViewFlowLayout : UICollectionViewFlowLayout
// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@end
