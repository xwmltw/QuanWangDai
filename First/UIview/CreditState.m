//
//  CreditState.m
//  QuanWangDai
//
//  Created by yanqb on 2018/3/30.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "CreditState.h"
#import "IdentityAuthenticationVC.h"
#import "ZMAuthenticationVC.h"
#import "BaseInfoVC.h"
#import "OperatorAuthenticationVC.h"
#import "ApplicantManVC.h"

#import "PersonalTailorVC.h"
#import "LookReportController.h"

@interface CreditState ()
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;

@end
@implementation CreditState
//运营商查询流程
+ (void)selectOperatorCreaditState:(UIViewController *)controller{
    CreditState *credit = [[CreditState alloc]init];
    [credit selectOperatorCreaditState:controller];
}
- (void)selectOperatorCreaditState:(UIViewController *)controller {
    if (self.creditInfoModel.identity_status.integerValue == 0) {
        IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
        vc.isBlock = @(1);
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.base_info_status.integerValue == 0) {
        BaseInfoVC *vc = [[BaseInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(1);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.operator_status.integerValue == 0 || self.creditInfoModel.verify_yys_again.integerValue == 1) {
        OperatorAuthenticationVC *vc = [[OperatorAuthenticationVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(2);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    LookReportController *vc = [[LookReportController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:vc animated:YES];
}
//信贷预测查询流程
+ (void)selectIdentityCreaditState:(UIViewController *)controller{
    CreditState *credit = [[CreditState alloc]init];
    [credit selectIdentityCreaditState:controller];
}
- (void)selectIdentityCreaditState:(UIViewController *)controller{
    
    if (self.creditInfoModel.identity_status.integerValue == 0) {
        IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
        vc.isBlock = @(3);
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    LookReportController *vc = [[LookReportController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:vc animated:YES];
}


+ (void)selectCreaditState:(UIViewController *)controller with:(CreditInfoModel *)model{
    
    CreditState *credit = [[CreditState alloc]init];
    [credit selectCreaditState:controller];
   
}
- (void)selectCreaditState:(UIViewController *)controller {
    if (self.creditInfoModel.applicant_qualification_status.integerValue == 0) {
        ApplicantManVC *vc = [[ApplicantManVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(1);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.identity_status.integerValue == 0) {
        IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
        vc.isBlock = @(1);
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.zhima_status.integerValue == 0) {
        ZMAuthenticationVC *vc = [[ZMAuthenticationVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(1);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.base_info_status.integerValue == 0) {
        BaseInfoVC *vc = [[BaseInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(1);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (self.creditInfoModel.operator_status.integerValue == 0) {
        OperatorAuthenticationVC *vc = [[OperatorAuthenticationVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isBlock = @(1);
        [controller.navigationController pushViewController:vc animated:YES];
        return;
    }
    PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
    vc.isAllProduct = @1;
    vc.hidesBottomBarWhenPushed = YES;
    [controller.navigationController pushViewController:vc animated:YES];
}
+ (BOOL)creditStateWith:(CreditInfoModel *)model{
    
    if( model.identity_status.integerValue == 0){
        return NO;
    }
    
    if( model.zhima_status.integerValue == 0){
        return NO;
        
    }
    
    if( model.base_info_status.integerValue == 0){
       
        return NO;
    }
    
    if( model.operator_status.integerValue == 0){
       
        return NO;
    }
    
    if( model.applicant_qualification_status.integerValue == 0){
       return NO;
        
    }
    return YES;
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
@end
