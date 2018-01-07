//
//  OperatorModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatorModel : NSObject
@property (nonatomic, copy) NSString *operator_phone;
@property (nonatomic, copy) NSString *operator_password;
@property (nonatomic, copy) NSString *operator_website;
@property (nonatomic, copy) NSString *operator_token;
@property (nonatomic, copy) NSNumber *reset_pwd_method;
+ (instancetype)sharedInstance;
@end
//“content”: {
//    “operator_phone”: “xxxx”, // 手机号
//    “operator_password”: “xxxxxx”, // 服务密码
//    “operator_website”: “xxxxxx”, // website
//    “operator_token”: “xxxxxx”, // token
//    “reset_pwd_method”: “xxxxxx”, // 是否需要重置密码 1是 0否
//}

