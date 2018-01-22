//
//  ApplyProductModel.h
//  QuanWangDai
//
//  Created by yanqb on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyProductModel : NSObject
@property (nonatomic, copy) NSString *cooperation_url;
@property (nonatomic, copy) NSString *contact_qq;
@property (nonatomic, copy) NSString *contact_wechat_public;
@end
//“cooperation_url”: “xxx”, // 合作方提供的跳转链接[产品合作方式：1落地页 2注册信息对接]
//“contact_qq”: “xxx”, // 联系qq[商户后台合作方式有该字段]
//“contact_wechat_public”: “xxx”, // 微信公众号[商户后台合作方式有该字段]

