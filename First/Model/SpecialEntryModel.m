//
//  SpecialEntryModel.m
//  QuanWangDai
//
//  Created by yanqb on 2018/1/19.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "SpecialEntryModel.h"
#import "XCacheHelper.h"

@implementation SpecialEntryModel
XSharedInstance(SpecialEntryModel)
MJCodingImplementation
- (void)saveSpecialEntryModel:(id)info{
    [XCacheHelper saveToFileWithModel:info fileName:@"SpecialEntryModel" isCanClear:NO];
}
- (SpecialEntryModel *)getSpecialEntryModel{
    
    return [XCacheHelper getModelWithFileName:@"SpecialEntryModel" withClass:[SpecialEntryModel class] isCanClear:NO];
}
@end
