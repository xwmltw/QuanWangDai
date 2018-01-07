//
//  CreditMaterialCell.m
//  test
//
//  Created by Leelen-iMac2 on 2017/11/20.
//  Copyright © 2017年 Leelen-iMac2. All rights reserved.
//

#import "CreditMaterialCell.h"
#import "UserInfo.h"
#import "ParamModel.h"
@interface CreditMaterialCell ()
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoRM;

@end
@implementation CreditMaterialCell

{
    UIImageView *image;
    UILabel *nameLab;
    UIImageView *authImage;
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        image = [[UIImageView alloc]init];
        [self.contentView addSubview:image];
        
        authImage = [[UIImageView alloc]init];
        [self.contentView addSubview:authImage];
        
        nameLab = [[UILabel alloc]init];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [nameLab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        [self.contentView addSubview:nameLab];
        
       
    }
    return self;
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints {
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(8));
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_offset(AdaptationWidth(56));
//        make.bottom.mas_equalTo(nameLab.mas_top).offset(-AdaptationWidth(2));
    }];
    [authImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(image);
        make.center.mas_equalTo(image);
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(2));
        make.left.right.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(@(17));
//        make.bottom.mas_equalTo(self.contentView).offset(-AdaptationWidth(13));
    }];
    //according to apple super should be called at end of method
    [super updateConstraints];
}
- (void)configureWith:(id)dic indexPath:(NSInteger)row model:(CreditInfoModel*)model{
   
    authImage.hidden = YES;
    switch (row) {
        case 0:
        {
            if (model.bank_status.integerValue == 1) {
                authImage.hidden = NO;
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
            }
        }
            break;
        case 1:
        {
            if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1)
            {
                if (model.company_status.integerValue == 1) {
                    authImage.hidden = NO;
                    [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                }
            }else{
                if (model.loan_info_status.integerValue == 1) {
                    authImage.hidden = NO;
                    [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                }
            }
            
        }
            break;
        case 2:
        {
            if (model.company_status.integerValue == 1) {
                authImage.hidden = NO;
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
            }
        }
            break;
            
        default:
            break;
    }
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"image"][row]]]];
    [image setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"selectedimage"][row]]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",dic[@"name"][row]]];
    if(![[UserInfo sharedInstance]isSignIn]){
        authImage.hidden = YES;
        return;
    }
}
- (void)configureWithFirst:(id)dic indexPath:(NSInteger)row model:(CreditInfoModel*)model{
    authImage.hidden = YES;
    switch (row) {
        case 0:
        {
            if (model.identity_status.integerValue == 1) {
                authImage.hidden = NO;
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
            }
        }
            break;
        case 1:
        {
            if (model.zhima_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_authorization"]];
                authImage.hidden = NO;
            }
        }
            break;
        case 2:
        {
            if (model.base_info_status.integerValue == 1) {
                authImage.hidden = NO;
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
            }
        }
            break;
        case 3:
        {
            if (model.operator_status.integerValue == 1) {
                authImage.hidden = NO;
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
            }
        }
            break;
            
        default:
            break;
    }
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"image"][row]]]];
    [image setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"selectedimage"][row]]]];
    [nameLab setText:[NSString stringWithFormat:@"%@",dic[@"name"][row]]];
    if(![[UserInfo sharedInstance]isSignIn]){
        authImage.hidden = YES;
        return;
    }
}





@end
