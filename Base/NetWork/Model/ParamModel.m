//
//  ParamModel.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ParamModel.h"
#import "XDeviceHelper.h"
#import "XCacheHelper.h"
#import "UserLocation.h"

@implementation ParamModel
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (NSString*)getContent{
    if (self) {
        NSDictionary* dic = [self mj_keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
        NSUInteger strLength = [str length];
        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return param;
    }
    return nil;
}
@end

@implementation BaseInfoPM
- (instancetype)init{
    self = [super init];
    if (self) {
        self.product_type = @2;
        self.client_type = @2;
        self.app_version_code = [NSString stringWithFormat:@"%d",[XDeviceHelper getAppIntVersion]] ;
        self.package_name = @"全网贷";
        self.access_channel_code = @"AppStore";
        self.uid = [XDeviceHelper getUUID];
        self.ad_code = [[UserLocation sharedInstance]getAdCode];
        self.city_code = [[UserLocation sharedInstance]getCityCode];
    }
    return self;
}
@end

@implementation QueryParamModel
- (instancetype)init{
    self = [super init];
    if (self) {
        self.page_size = @30;
        self.page_num = @1;
    }
    return self;
}
@end

@implementation ClientGlobalInfoRM
MJCodingImplementation
- (void)setClientGlobalInfoModel{
    
    [XCacheHelper saveToFileWithModel:self fileName:@"ClientGlobalInfoModel" isCanClear:NO];
}
+ (ClientGlobalInfoRM *)getClientGlobalInfoModel{
   return  [XCacheHelper getModelWithFileName:@"ClientGlobalInfoModel" withClass:[ClientGlobalInfoRM class] isCanClear:NO];
}
@end

@implementation ClientVersionModel
MJCodingImplementation
@end
@implementation WapUrlList

@end







