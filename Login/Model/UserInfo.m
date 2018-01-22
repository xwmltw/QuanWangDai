//
//  UserInfo.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/15.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "UserInfo.h"
#import "XCacheHelper.h"

static  NSString * const userInfo = @"UserInfo";
static  UserInfo * userInfoModel = nil;   /*!< 用户信息 */
@implementation UserInfo

XSharedInstance(UserInfo);
MJCodingImplementation

#pragma mark - ***** 存取 账号密码 ******


- (void)savePhone:(NSString *)userPhone password:(NSString*)password userId:(NSString *)userId grantAuthorization:(NSNumber *)grantAuthorization{
    [self savePhone:userPhone password:password dynamicPassword:userId grantAuthorization:grantAuthorization];
}
- (void)savePhone:(NSString *)userPhone password:(NSString*)password dynamicPassword:(NSString *)dynamicPassword grantAuthorization:(NSNumber *)grantAuthorization{
    if (userPhone && userPhone.length > 0) {
        self.phoneName = userPhone;
    }
    if(password && password.length > 0){
        self.password = password;
    }
    if (dynamicPassword && dynamicPassword.length > 0) {
        self.userId = dynamicPassword;
    }
    
    self.has_grant_authorization = grantAuthorization;
    
    [XCacheHelper saveByNSKeyedUnarchiverWith:self fileName:userInfo isCanClear:YES];
    
}
- (UserInfo *)getUserInfo{
    userInfoModel = [XCacheHelper getByNSKeyedUnarchiver:userInfo withClass:[UserInfo class] isCanClear:YES];
    return userInfoModel;
}
- (void)clearCacheFolder{
//    [XCacheHelper clearCache:[XCacheHelper ]]
}
#pragma mark - ***** 是否登录 ******
- (BOOL)isSignIn{
    userInfoModel  = [self getUserInfo];
    if (userInfoModel.userId && userInfoModel.userId.length > 0) {
        return YES;
    }
    return NO;
}
- (BOOL)isSignIn2{
    userInfoModel  = [self getUserInfo];
    if (userInfoModel.userId && userInfoModel.userId.length > 0 && userInfoModel.password.length) {
        return YES;
    }
    return NO;
}
@end
