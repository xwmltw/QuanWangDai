//
//  CreditSectionHeaderView.m
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import "CreditSectionHeaderView.h"

@implementation CreditSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//         self.backgroundColor = [UIColor yellowColor];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        
        
        _titleLabe = [[UILabel alloc]initWithFrame:CGRectZero];
        [_titleLabe setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
        [_titleLabe setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
		
		_subtitleLabe = [[UILabel alloc]initWithFrame:CGRectZero];
		[_subtitleLabe setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
		[_subtitleLabe setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        
        [self addSubview:_imageView];
        [_imageView addSubview:_titleLabe];
		[_imageView addSubview:_subtitleLabe];
    }
    return self;
}
// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [_titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.imageView).offset(AdaptationWidth(28));
        make.height.mas_equalTo(AdaptationWidth(28));
    }];
	[_subtitleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self.imageView).offset(AdaptationWidth(24));
		make.top.mas_equalTo(_titleLabe.mas_bottom).offset(AdaptationWidth(4));
		make.height.mas_equalTo(AdaptationWidth(17));
	}];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    [super updateConstraints];
}
@end
