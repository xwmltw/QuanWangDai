//
//  CreditChannelCell.m
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import "CreditChannelCell.h"

@interface CreditChannelCell()
{
	UIView *horizontalLine;
	UIView *verticalLine;
}
@end

@implementation CreditChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
        _leftbtn = [[UIButton alloc]init];
		_leftbtn.tag = 1000;
        [_leftbtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftbtn setImage:[UIImage imageNamed:@"获取专属贷款"] forState:UIControlStateNormal];
        [_leftbtn setImage:[UIImage imageNamed:@"获取专属贷款"] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_leftbtn];
        
        _leftlab  = [[UILabel alloc]init];
        _leftlab.text = @"获取专属\n贷款";
		_leftlab.numberOfLines = 0;
        [_leftlab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
        [_leftlab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [_leftbtn addSubview:_leftlab];
		
		
		_rightbtn = [[UIButton alloc]init];
		_rightbtn.tag = 1001;
		[_rightbtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
		[_rightbtn setImage:[UIImage imageNamed:@"查看我的信用"] forState:UIControlStateNormal];
		[_rightbtn setImage:[UIImage imageNamed:@"查看我的信用"] forState:UIControlStateHighlighted];
		[self.contentView addSubview:_rightbtn];
		
		_rightlab  = [[UILabel alloc]init];
		_rightlab.text = @"查看我的\n信用";
		_rightlab.numberOfLines = 0;
		[_rightlab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
		[_rightlab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
		[_rightbtn addSubview:_rightlab];
		
		horizontalLine = [[UIView alloc]init];
		horizontalLine.backgroundColor = XColorWithRBBA(233,233 ,235,1);
		[self addSubview:horizontalLine];
		
		verticalLine = [[UIView alloc]init];
		verticalLine.backgroundColor = XColorWithRBBA(233,233 ,235,1);
		[self addSubview:verticalLine];
    }
    return self;
}
- (void)btnOnClick:(UIButton *)btn{
	if (self.delegate && [self.delegate respondsToSelector:@selector(pushAllDK:)]) {
		[self.delegate pushAllDK:btn];
    }
}
// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [_leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.height.mas_equalTo(AdaptationWidth(80));
		make.width.mas_equalTo(self.contentView.frame.size.width / 2);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [_leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftbtn).offset(AdaptationWidth(20));
        make.top.mas_equalTo(_leftbtn).offset(AdaptationWidth(20));
		make.height.mas_equalTo(AdaptationWidth(46));
		make.width.mas_equalTo(AdaptationWidth(65));
    }];
	
	[_rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(_leftbtn.mas_right).offset(-1);
		make.height.mas_equalTo(AdaptationWidth(80));
        make.right.mas_equalTo(self.contentView);
//        make.width.mas_equalTo(self.contentView.frame.size.width / 2);
		make.bottom.mas_equalTo(self.contentView);
	}];
	
	[_rightlab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(_rightbtn).offset(AdaptationWidth(20));
		make.top.mas_equalTo(_rightbtn).offset(AdaptationWidth(20));
		make.height.mas_equalTo(AdaptationWidth(46));
		make.width.mas_equalTo(AdaptationWidth(65));
	}];
	
	[horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.bottom.mas_equalTo(self);
		make.height.mas_equalTo(0.5);
	}];
	
	[verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
		make.bottom.mas_equalTo(self);
		make.height.mas_equalTo(AdaptationWidth(80));
		make.width.mas_equalTo(0.5);
	}];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}
@end
