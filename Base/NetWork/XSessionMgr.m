//
//  XSessionMgr.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XSessionMgr.h"

#define NSUSerDefaults_WdCacheMgr_latestSessionId @"NSUSerDefaults_WdCacheMgr_latestSessionId"
@interface XSessionMgr()
@property (nonatomic, copy) NSString *latestSessionId;
@end

@implementation XSessionMgr

XSharedInstance(XSessionMgr);

- (NSString *)getLatestSessionId{
    if (!_latestSessionId || _latestSessionId.length == 0) {
        _latestSessionId = [WDUserDefaults stringForKey:NSUSerDefaults_WdCacheMgr_latestSessionId];
    }
    return _latestSessionId;
}

- (void)setLatestSessionId:(NSString *)sessionId{
    _latestSessionId = sessionId;
    [WDUserDefaults setObject:_latestSessionId forKey:NSUSerDefaults_WdCacheMgr_latestSessionId];
    [WDUserDefaults synchronize];
}


@end
