//
//  CreditInfoCell.m
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import "CreditInfoCell.h"
#import "UserInfo.h"

#if __has_include(<Masonry/Masonry.h>)
    #import <Masonry/Masonry.h>
#else
    #import "Masonry.h"
#endif /* __has_include */

@interface CreditInfoCell ()

//@property (nonatomic, strong) UILabel *degreeLabel; // 完成度
@property (nonatomic, strong) UILabel *gradeLabe;   // 等级
@property (nonatomic, strong) UILabel *rateLabe;    // 通过率

@property (nonatomic, strong) UILabel *abcd;
@end

@implementation CreditInfoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
//        _degreeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//        [_degreeLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)]];
//        [_degreeLabel setTextColor:[UIColor whiteColor]];
		
        _gradeLabe = [[UILabel alloc]initWithFrame:CGRectZero];

        [_gradeLabe setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
        [_gradeLabe setTextColor:[UIColor whiteColor]];
        
        _rateLabe = [[UILabel alloc]initWithFrame:CGRectZero];
        [_rateLabe setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
        [_rateLabe setTextColor:[UIColor whiteColor]];
        
        _abcd = [[UILabel alloc]initWithFrame:CGRectZero];
        [_abcd setFont:[UIFont fontWithName:@"iconfont" size:AdaptationWidth(26)]];
        [_abcd setTextColor:[UIColor whiteColor]];
        
//        [self.contentView addSubview:_degreeLabel];
        [self.contentView addSubview:_gradeLabe];
        [self.contentView addSubview:_rateLabe];
        [self.contentView addSubview:_abcd];
        
    }
    return self;
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    
    // --- remake/update constraints here
//    [self.degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
//        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
//    }];
    [self.gradeLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(66));
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
    }];
    [self.rateLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gradeLabe.mas_bottom).offset(AdaptationWidth(4));
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
    }];
    
    [_abcd mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_gradeLabe);
        make.left.mas_equalTo(_gradeLabe.mas_right).offset(AdaptationWidth(8));
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)configureWith:(CreditInfoModel *)model {

    if (![[UserInfo sharedInstance]isSignIn])
    {
        _gradeLabe.text = @"您还未登录";
//        _degreeLabel.hidden = YES;
        _rateLabe.hidden = YES;
        _abcd.hidden = YES;
        return;
    }else{
        _gradeLabe.text = [NSString stringWithFormat:@"我的信用等级:"];
//        _degreeLabel.hidden = NO;
        _rateLabe.hidden = NO;
        _abcd.hidden = NO;
        
//        _degreeLabel.text = [NSString stringWithFormat:@"资料完成度 %@%%", model.complete_schedule];
		
        if ([model.credit_level isEqualToString:@"E"]) {
            _rateLabe.text = [NSString stringWithFormat:@"贷款通过率 %@", @"低"];
            _abcd.text =  @"\U0000e60c";
        }
        if ([model.credit_level isEqualToString:@"D"]) {
            _rateLabe.text = [NSString stringWithFormat:@"贷款通过率 %@", @"较低"];
            _abcd.text =@"\U0000e60f";
        }
        if ([model.credit_level isEqualToString:@"C"]) {
            _rateLabe.text = [NSString stringWithFormat:@"贷款通过率 %@", @"较高"];
            _abcd.text =@"\U0000e60e";
        }
        if ([model.credit_level isEqualToString:@"B"]) {
            _rateLabe.text = [NSString stringWithFormat:@"贷款通过率 %@", @"高"];
            _abcd.text =@"\U0000e60d";
        }
    }


    
}

@end
