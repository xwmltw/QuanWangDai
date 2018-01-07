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

+ (instancetype)sharedInstance;
//存储用户登录信息
- (void)savePhone:(NSString *)userPhone password:(NSString*)password userId:(NSString *)userId;
- (UserInfo *)getUserInfo;
- (BOOL)isSignIn;
- (BOOL)isSignIn2;
@end
