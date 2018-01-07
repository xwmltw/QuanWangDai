//
//  XSessionMgr.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSessionMgr : NSObject
@property (nonatomic, copy) NSString *challenge;
@property (nonatomic, copy) NSString *pub_key_base64;
@property (nonatomic, copy) NSString *pub_key_modulus;
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userToken;
+ (instancetype)sharedInstance;
- (NSString *)getLatestSessionId;
- (void)setLatestSessionId:(NSString *)sessionId;

@end
