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


- (void)savePhone:(NSString *)userPhone password:(NSString*)password userId:(NSString *)userId{
    [self savePhone:userPhone password:password dynamicPassword:userId];
}
- (void)savePhone:(NSString *)userPhone password:(NSString*)password dynamicPassword:(NSString *)dynamicPassword{
    if (userPhone && userPhone.length > 0) {
        self.phoneName = userPhone;
    }
    self.password = password;
   
    self.userId = dynamicPassword;
    [XCacheHelper saveByNSKeyedUnarchiverWith:self fileName:userInfo isCanClear:NO];
    
}
- (UserInfo *)getUserInfo{
    userInfoModel = [XCacheHelper getByNSKeyedUnarchiver:userInfo withClass:[UserInfo class] isCanClear:NO];
    return userInfoModel;
}
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
