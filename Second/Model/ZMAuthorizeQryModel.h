//
//  ZMAuthorizeQryModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMAuthorizeQryModel : NSObject
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *params;
@property (nonatomic, copy) NSString *app_id;
+ (instancetype)sharedInstance;
@end
