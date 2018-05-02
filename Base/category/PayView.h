//
//  PayView.h
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewDelegate <NSObject>

////- (void)PayViewIsUseMoneyWith;
////- (void)PayViewIsCreditWith;
- (void)PayViewOnlinePay:(UIButton *)button;

@end


@interface PayView : UIView

@property (nonatomic, weak) id<PayViewDelegate> delegate;
/*
 * 支付弹窗展示控件
 */
@property (nonatomic, strong) UIView *backgroungView;
@property (nonatomic, strong) UILabel *headTitleLabel;  // 标题
//@property (nonatomic, strong) UIButton *creditBtn;      // 信用额度按钮
@property (nonatomic, strong) UIButton *walltBtn;       // 钱包按钮
@property (nonatomic, strong) UIButton *online;         // 在线支付按钮

-(UIView *)initWithFrame:(CGRect )frame andNSString:(NSString *)title;

@end
