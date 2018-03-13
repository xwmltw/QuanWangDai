//
//  ZMAuthenticationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ZMAuthenticationVC.h"
#import "ZMAuthorizeQryModel.h"
#import <ZMCreditSDK/ALCreditService.h>
typedef NS_ENUM(NSUInteger, ZMAdultIdentityVerifyRequest) {
    ZMAdultIdentityVerifyRequestZM,
    ZMAdultIdentityVerifyRequestZMBack,
};
@interface ZMAuthenticationVC ()
{
    NSDictionary *_zmDict;
}
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
        [self popToCenterController];
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
        self.dict = @{};
    }else if (self.requestCount == ZMAdultIdentityVerifyRequestZMBack) {
        self.cmd = XZhimaCallBack;
        NSString *paramsStr = _zmDict[@"params"];
        NSString *sign = _zmDict[@"sign"];
        sign = [sign stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.dict = @{@"params":[paramsStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]],
                      @"sign":[sign stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet punctuationCharacterSet]]};
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
        [self popToCenterController];
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
@end
