//
//  IdCardModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdCardModel : NSObject
@property (nonatomic, copy) NSString *id_name;
@property (nonatomic, copy) NSNumber *id_no;
@property (nonatomic, copy) NSString *flag_sex;
+ (instancetype)sharedInstance;
@end
