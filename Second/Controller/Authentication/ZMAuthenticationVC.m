//
//  ZMAuthenticationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ZMAuthenticationVC.h"
#import "ZMAuthorizeQryModel.h"
#import "CreditInfoModel.h"
#import <ZMCreditSDK/ALCreditService.h>
#import "PersonalTailorVC.h"
typedef NS_ENUM(NSUInteger, ZMAdultIdentityVerifyRequest) {
    ZMAdultIdentityVerifyRequestZM,
    ZMAdultIdentityVerifyRequestZMBack,
    CreditRequestDetailInfo,
    HalfWithAllProduct,
};
@interface ZMAuthenticationVC ()
{
    NSDictionary *_zmDict;
}
@property (nonatomic, strong)CreditInfoModel *creditInfoModel;
@property (nonatomic ,copy) NSNumber *isAllProduct;//1全流程 2流程
@end

@implementation ZMAuthenticationVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【芝麻信用认证】页"];
    [self prepareDataWithCount:ZMAdultIdentityVerifyRequestZM];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)launchSDK {
    // 商户需要从服务端获取
    NSString* appId = [ZMAuthorizeQryModel sharedInstance].app_id;
    [[ALCreditService sharedService] queryUserAuthReq:appId sign:[ZMAuthorizeQryModel sharedInstance].sign params:[ZMAuthorizeQryModel sharedInstance].params extParams:nil selector:@selector(result:) target:self];
}

- (void)result:(NSMutableDictionary *)dict
{
    MyLog(@"dict：%@", dict);
    NSString *str = dict[@"authResult"];
    if ([str isEqualToString:@""]) {
        [self setHudWithName:@"芝麻信用认证失败" Time:0.5 andType:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    _zmDict = dict;
    [self prepareDataWithCount:ZMAdultIdentityVerifyRequestZMBack];
}
- (void)popToCenterController
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 网络
-(void)setRequestParams
{
    if  (self.requestCount == ZMAdultIdentityVerifyRequestZM) {
        self.cmd = XAuthorizeQry;
        self.dict = [NSDictionary dictionary];
    }else if (self.requestCount == ZMAdultIdentityVerifyRequestZMBack) {
        self.cmd = XZhimaCallBack;
        NSString *paramsStr = _zmDict[@"params"];
        NSString *sign = _zmDict[@"sign"];
        sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[paramsStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]],@"params",[sign stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]],@"sign", nil];
    }else if (self.requestCount ==CreditRequestDetailInfo){
        self.cmd = XGetCreditInfo;
        self.dict = [NSDictionary dictionary];
    }else if(self.requestCount == HalfWithAllProduct){
        self.cmd  = XGetSpecialLoanProList;
        self.dict =@{@"query_type":self.isAllProduct};
    }
}

- (void)requestSuccessWithDictionary:(XResponse *)response
{
     if (self.requestCount == ZMAdultIdentityVerifyRequestZM) {
        //2.后去调用芝麻信用的SDK
        
        [[ZMAuthorizeQryModel sharedInstance] mj_setKeyValues:response.content];
        [self launchSDK];
    }else if (self.requestCount == ZMAdultIdentityVerifyRequestZMBack) {
        [self setHudWithName:response.errMsg Time:0.5 andType:0];
        if (self.isBlock.integerValue == 1) {
            [self prepareDataWithCount:CreditRequestDetailInfo];
            return;
        }
        [self popToCenterController];
    }else if (self.requestCount ==CreditRequestDetailInfo){
        [[CreditInfoModel sharedInstance]saveCreditStateInfo:[CreditInfoModel mj_objectWithKeyValues:response.content]];
        if ([CreditState creditStateWith:self.creditInfoModel]) {
            self.isAllProduct = @1;
        }else{
            self.isAllProduct = @2;
        }
        [self prepareDataWithCount:HalfWithAllProduct];
    }else if(self.requestCount == HalfWithAllProduct){
        NSNumber *row = response.content[@"loan_pro_list_count"];
        if(row.integerValue > 0){
            PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
            vc.isAllProduct = self.isAllProduct;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (self.isBlock.integerValue == 1) {
            [CreditState selectCreaditState:self with:self.creditInfoModel];
            return;
        }
    }
}

- (void)requestFaildWithDictionary:(XResponse *)response
{
    if (self.requestCount == ZMAdultIdentityVerifyRequestZM) {
        if ([response.errMsg isEqualToString:@"芝麻信用已经认证"]) {
            [self setHudWithName:@"芝麻信用已经认证" Time:0.5 andType:0];
            
        }else {
            [self setHudWithName:response.errMsg Time:0.5 andType:0];
            return;
        }
    }else {
        [super requestFaildWithDictionary:response];
        
    }
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
@end
