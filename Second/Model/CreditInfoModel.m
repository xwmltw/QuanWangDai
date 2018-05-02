//
//  CreditInfoModel.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "CreditInfoModel.h"
#import "XCacheHelper.h"

static NSString *const creditStateInfo = @"creditStateInfo";
@implementation CreditInfoModel
XSharedInstance(CreditInfoModel);
MJCodingImplementation
- (void)saveCreditStateInfo:(id)info{
    [XCacheHelper saveToFileWithModel:info fileName:creditStateInfo isCanClear:NO];
}
- (CreditInfoModel *)getCreditStateInfo{
    return [XCacheHelper getModelWithFileName:creditStateInfo withClass:[CreditInfoModel class] isCanClear:NO];
}
@end
