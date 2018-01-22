//
//  AuthorizationView.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,AuthorizationBtnOnClick) {
    AuthorizationBtnOnClickAgreement,
    AuthorizationBtnOnClickTick,
};
@interface AuthorizationView : UIView
@property (nonatomic,strong) UIButton *AgreementBtn;
@property (nonatomic,strong) UIButton *TickBtn;
@end
