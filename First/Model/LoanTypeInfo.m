//
//  LoanTypeInfo.m
//  QuanWangDai
//
//  Created by yanqb on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "LoanTypeInfo.h"
#import "XCacheHelper.h"

static NSString *const loanTypeInfo = @"loanTypeInfo";
@implementation LoanTypeInfo
XSharedInstance(LoanTypeInfo);
MJCodingImplementation
- (void)saveLoanTypeInfo:(id)info{
    [XCacheHelper saveToFileWithModel:info fileName:loanTypeInfo isCanClear:NO];
}
- (LoanTypeInfo *)getLoanTypeInfo{
    return [XCacheHelper getModelWithFileName:loanTypeInfo withClass:[LoanTypeInfo class] isCanClear:NO];
}
@end
