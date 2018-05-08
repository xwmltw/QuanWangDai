//
//  ImformationDetailModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImformationDetailModel : NSObject
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *artical_title;
@property (nonatomic, copy) NSString *artical_author;
@property (nonatomic, copy) NSString *cover_img_url;
@property (nonatomic, copy) NSString *artical_abstract;
@property (nonatomic, copy) NSString *artical_keyword;
@property (nonatomic, copy) NSString *artical_main_text;
@property (nonatomic, copy) NSNumber *create_time;
@property (nonatomic, copy) NSNumber *update_time;
@property (nonatomic, copy) NSString *read_num;
@end
//“article_id” : xxx,//资讯id
//“artical_title”: xxx, // 资讯标题
//“artical_author”: xxx, // 资讯作者
//“cover_img_url”: xxx, // 资讯封面图片
//“artical_abstract”: xxx, // 资讯摘要
//“artical_keyword”: xxx, // 关键字
//“artical_main_text”: xxx, // 资讯正文
//“create_time”:xxx,// 创建时间
//“update_time”:xxx,// 更新时间
//“read_num”: xxx // 阅读量

