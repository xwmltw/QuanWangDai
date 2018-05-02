//
//  RecommentTopBtn.m
//  QuanWangDai
//
//  Created by yanqb on 2018/4/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "RecommentTopBtn.h"

@implementation RecommentTopBtn

- (instancetype)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [self setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
//    [self setImage:self.btnImage.image forState:UIControlStateNormal];
    [self setTitle:self.btnTitle forState:UIControlStateNormal];
    CGFloat imageW = self.currentImage.size.width;
    CGFloat imageH = self.currentImage.size.height;
    CGFloat titleW = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleH = self.titleLabel.intrinsicContentSize.height;
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleH, 0, 5, -titleW);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, -imageH - AdaptationWidth(10),  0);
}


@end
