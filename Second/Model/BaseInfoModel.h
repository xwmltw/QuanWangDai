//
//  BaseInfoModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ShipModel;

@interface BaseInfoModel : NSObject
@property (nonatomic, copy) NSString *is_marry;
@property (nonatomic, copy) NSString *home_province;
@property (nonatomic, copy) NSString *home_city;
@property (nonatomic, copy) NSString *home_town;
@property (nonatomic, copy) NSString *home_address;
@property (nonatomic, strong) NSArray <ShipModel *> *contacts;
@property (nonatomic, strong) NSArray *phone_name_list;
@end

@interface ShipModel : NSObject
@property (nonatomic, copy) NSNumber *ship_type;
@property (nonatomic, copy) NSString *ship_name;
@property (nonatomic, copy) NSString *ship_contact;
@property (nonatomic, copy) NSString *ship_province_city_town;
@property (nonatomic, copy) NSString *ship_address;
@property (nonatomic, copy) NSString *relationship;
@end
//“is_marry: “xxxx”, // 婚姻状况：未婚，已婚，其他
//“home_province”: “xxxx”, // 居住地所在省份名称
//“home_city”: “xxxx”, // 居住地所在城市名称
//“home_town”: “xxxx”, // 居住地所在区县名称
//“home_address”: “xxxx”, // 居住地所在地详细地址
//“contacts”:[
//            {
//                “ship_type: “xxxx”, // 联系人关系类型
//                “ship_name: “xxxx”, // 联系人姓名
//                “ship_contact: “xxxx”, // 联系人联系方式
//                “ship_province_city_town”: “xxxx”, // 联系人地址(省市区)
//                “ship_address”: “xxxx”, // 联系人详细地址
//                “relationship”: “xxxx”, // 联系人类型描述
//            }
//            ]
//“phone_name_list”:[ // 通信录内容

