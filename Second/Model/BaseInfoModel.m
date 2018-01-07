//
//  BaseInfoModel.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "BaseInfoModel.h"

@implementation BaseInfoModel
- (instancetype)init{
    if (self = [super init]) {
        [BaseInfoModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"is_marry":@"",
                     @"home_province":@"",
                     @"home_city":@"",
                     @"home_town":@"",
                     @"home_address":@"",
                     @"contacts":[ShipModel class],
                     @"phone_name_list":@"",
                     };
        }];
    }
    return self;
}
@end

@implementation ShipModel
@end
