//
//  InformationModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject
@property (nonatomic, copy) NSString *strategy_url;
@property (nonatomic, copy) NSString *zixun_url;
@property (nonatomic, copy) NSArray *strategy_list;
@property (nonatomic, copy) NSArray *zixun_list;
@end
//“strategy_url”: xxxx // 贷款攻略页面url
//“zixun_url”: xxxx // 资讯中心页面url
//“strategy_list”: [ // 贷款攻略
//                  {
//                      “id” : xxx,//资讯id
//                      “artical_title”: xxx, // 资讯标题
//                      “cover_img_url”: xxx, // 资讯封面图片
//                      “zixun_detail_url”:xxxx // 文章详情页面url
//                  }
//                  ]
//
//“zixun_list”: [// 资讯中心
//               {
//                   “id” : xxx,//资讯id
//                   “artical_title”: xxx, // 资讯标题
//                   “artical_author”: xxx, // 资讯作者
//                   “cover_img_url”: xxx, // 资讯封面图片
//                   “artical_abstract”: xxx, // 资讯摘要
//                   “artical_keyword”: xxx, // 关键字
//                   “create_time”:xxx,// 创建时间
//                   “update_time”:xxx,// 更新时间
//                   “zixun_detail_url”:xxxx // 文章详情页面url
//               }
//               ]

