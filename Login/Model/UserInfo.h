//
//  UserInfo.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/15.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,copy)NSString *phoneName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSNumber *has_grant_authorization; /*!< 1： 代表已授权， 0代表未授权*/

+ (instancetype)sharedInstance;
//存储用户登录信息
- (void)savePhone:(NSString *)userPhone password:(NSString*)password userId:(NSString *)userId grantAuthorization:(NSNumber *)grantAuthorization;
- (UserInfo *)getUserInfo;
- (BOOL)isSignIn;
- (BOOL)isSignIn2;
@end
