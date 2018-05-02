//
//  PayView.m
//  LJPayViewDemo
//
//  Created by 罗金 on 16/4/1.
//  Copyright © 2016年 EasyFlower. All rights reserved.
//

#import "PayView.h"

typedef NS_ENUM(NSInteger ,ButtonClick) {
    ButtonClickClose,
    ButtonClickComfirm,
//    ButtonClickWechatPay,
    ButtonClickAliPay,
};
@interface PayView ()

@end

@implementation PayView

-(UIView *)initWithFrame:(CGRect )frame andNSString:(NSString *)title;{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /*!< 创建UI >*/
        [self layOutUIWith:title];
    }
    return self;
}
-(void)ButtonClick:(UIButton *)button{

    switch (button.tag) {
        case ButtonClickClose:{     // 关闭
            [self upDownSelf];
        }
            break;
        case ButtonClickComfirm:{   // 确认
            if (_walltBtn.selected == YES) {
                [self upDownSelf];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewOnlinePay:)]) {
                [self.delegate PayViewOnlinePay:button];
            }
        }
            break;
//        case ButtonClickWechatPay:{ // 微信
//            if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewIsCreditWith)]) {
//                [self.delegate PayViewIsCreditWith];
//            }
//        }
//            break;
        case ButtonClickAliPay:{    // 支付宝
            button.selected = !button.selected;
//            if (self.delegate && [self.delegate respondsToSelector:@selector(PayViewIsUseMoneyWith)]) {
//                [self.delegate PayViewIsUseMoneyWith];
//            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 一一一一一 <* 关闭弹窗 *> 一一一一一
- (void)upDownSelf {
    self.backgroundColor = [UIColor clearColor];
    __weak PayView *weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // 判断当前是否是空白处的高度范围，或是支付方式的视图，是则下移弹窗，不是则不作任何处理
    if (touch.view.frame.origin.y < AdaptationWidth(270)) {
        [self upDownSelf];
    }
}

#pragma mark - LayoutUIs
- (void)layOutUIWith:(NSString *)title {
    
    self.backgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - AdaptationWidth(210), ScreenWidth, AdaptationWidth(210))];
    _backgroungView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroungView];
    
    self.headTitleLabel = [[UILabel alloc]init];
    _headTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    _headTitleLabel.textColor = XColorWithRBBA(24, 58, 80, 0.32);
    _headTitleLabel.text = title;
    _headTitleLabel.textAlignment = NSTextAlignmentLeft;
    [_backgroungView addSubview:_headTitleLabel];
    
    /**
     分割线
     */
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = XColorWithRBBA(233, 233, 235, 1);
    [_backgroungView addSubview:line];
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = XColorWithRBBA(233, 233, 235, 1);
    [_backgroungView addSubview:line1];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"支付宝"]];
    [_backgroungView addSubview:imageView];


//    _creditBtn = [[UIButton alloc]init];
//    [_creditBtn setTitle:@"微信支付" forState:UIControlStateNormal];
//    [_creditBtn setTitleColor:CLColor(102, 102, 102) forState:UIControlStateNormal];
//    _creditBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [_creditBtn setImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateSelected];
//    [_creditBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//    [_creditBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
//    [_creditBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _creditBtn.tag = ButtonClickWechatPay;
//    _creditBtn.selected = YES;
//    [_backgroungView addSubview:_creditBtn];
    
    UILabel *zhifuLabel = [[UILabel alloc]init];
    zhifuLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    zhifuLabel.textColor = XColorWithRBBA(24, 58, 80, 0.8);
    zhifuLabel.text = @"支付宝";
    zhifuLabel.textAlignment = NSTextAlignmentLeft;
    [_backgroungView addSubview:zhifuLabel];
    

    _walltBtn = [[UIButton alloc]init];
    [_walltBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_walltBtn setTitle:@"支付宝" forState:UIControlStateNormal];
//    _walltBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    _walltBtn.selected = YES;
    _walltBtn.tag = ButtonClickAliPay;
//    _walltBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_walltBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [_walltBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//    [_walltBtn setTitleColor:XColorWithRBBA(24, 58, 80, 0.8) forState:UIControlStateNormal];
//    [_walltBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, AdaptationWidth(52), 0.0, -AdaptationWidth(51))];
//    [_walltBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -AdaptationWidth(230), 0.0, AdaptationWidth(230))];
    [_backgroungView addSubview:_walltBtn];
   
    
    // 确认支付
    self.online = [UIButton buttonWithType:UIButtonTypeCustom];
    _online.backgroundColor = XColorWithRBBA(252, 93, 109, 1);
    [self.online setCornerValue:4];
    self.online.tag = ButtonClickComfirm;
//    [_online setTitle:@"确认支付 ￥15.00" forState:UIControlStateNormal];
    [_online addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroungView addSubview:_online];
    

    /*
     *  X 号按钮
     */
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = ButtonClickClose;
    [closeBtn setImage:[UIImage imageNamed:@"XX"] forState:UIControlStateNormal];
    [_backgroungView addSubview:closeBtn];
    
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backgroungView).offset(AdaptationWidth(16));
        make.top.mas_equalTo(_backgroungView).offset(AdaptationWidth(16));
        make.width.mas_equalTo(AdaptationWidth(28));
        make.height.mas_equalTo(AdaptationWidth(28));
    }];
    
    [_headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_backgroungView).offset (AdaptationWidth(18));
        make.left.mas_equalTo (_backgroungView).offset (AdaptationWidth(77));
        make.width.mas_equalTo (AdaptationWidth(110));
        make.height.mas_equalTo (AdaptationWidth(24));
    }];
    
//    [_creditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo (_backgroungView.mas_left).offset(10);
//        make.width.mas_equalTo (140);
//        make.bottom.mas_equalTo (_walltBtn.mas_top).offset(-10);
//        make.height.mas_equalTo(15*BOUNDS.size.height/667);
//    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_walltBtn.mas_centerY);
        make.left.mas_equalTo (_backgroungView).offset(AdaptationWidth(24));
        make.width.mas_equalTo (AdaptationWidth(28));
        make.height.mas_equalTo (AdaptationWidth(28));
    }];
    
    [zhifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_walltBtn.mas_centerY);
        make.left.mas_equalTo (imageView.mas_right).offset(AdaptationWidth(16));
        make.right.mas_equalTo (_walltBtn.mas_left);
        make.height.mas_equalTo (AdaptationWidth(24));
    }];
    
    [_walltBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_headTitleLabel.mas_bottom).offset (AdaptationWidth(28));
        make.right.mas_equalTo (_backgroungView).offset(-AdaptationWidth(22));
        make.height.mas_equalTo (AdaptationWidth(40));
        make.width.mas_equalTo (AdaptationWidth(40));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_walltBtn.mas_bottom).offset(AdaptationWidth(10));
        make.width.mas_equalTo (AdaptationWidth(283));
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo (_backgroungView).offset(AdaptationWidth(68));
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (_backgroungView).offset(AdaptationWidth(22));
        make.width.mas_equalTo (0.5);
        make.height.mas_equalTo(AdaptationWidth(16));
        make.left.mas_equalTo (_backgroungView).offset(AdaptationWidth(60));
    }];
    
    [_online mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (line.mas_bottom).offset (AdaptationWidth(16));
        make.left.mas_equalTo (_backgroungView).offset(AdaptationWidth(24));
        make.right.mas_equalTo (_backgroungView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo (AdaptationWidth(48));
    }];
}

@end
