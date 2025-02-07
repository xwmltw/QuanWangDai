//
//  ParamModel.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClientVersionModel,WapUrlList;

@interface ParamModel : NSObject
- (NSString *)getContent;
@end
//通用参数
@interface BaseInfoPM: ParamModel
@property (nonatomic ,copy) NSNumber *product_type;
@property (nonatomic ,copy) NSNumber *client_type;
@property (nonatomic ,copy) NSString *app_version_code;
@property (nonatomic ,copy) NSString *package_name;
@property (nonatomic ,copy) NSString *access_channel_code;
@property (nonatomic ,copy) NSString *uid;
@property (nonatomic ,copy) NSString *ad_code;//区域行政代号
@property (nonatomic ,copy) NSString *city_code;//城市行政区号
@end
//分页查询
@interface QueryParamModel : ParamModel
@property (nonatomic, copy) NSNumber* timestamp;        // 毫秒数
@property (nonatomic, copy) NSNumber* page_size;        // 页大小
@property (nonatomic, copy) NSNumber* page_num;         // 页号
@end
//全局配置
@interface ClientGlobalInfoRM : ParamModel
@property (nonatomic, copy) NSNumber *current_time_millis;          /*!< 时间毫秒<整形数字> */
@property (nonatomic, copy) NSArray *banner_ad_list;                /*!< 客户端banner广告 */
@property (nonatomic, copy) NSArray *open_screen_ad_list;          /*!< 客户端开屏广告 >*/
@property (nonatomic, copy) NSString *wechat_public_logo;           /*!< 微信公众号logo地址 >*/
@property (nonatomic, copy) NSString *qq_group_numbr;               /*!< QQ群号码 >*/
@property (nonatomic, strong) ClientVersionModel *version_info;     /*!< 版本更新信息 */
@property (nonatomic, strong) WapUrlList *wap_url_list; /*!< 链接 */
@property (nonatomic, copy) NSString* customer_contact; /*!< 客服电话 */
@property (nonatomic, copy) NSNumber *recomment_entry_hide; /*!< 是否显示隐藏 1隐藏 其他不隐藏 */
@property (nonatomic, strong) NSArray *notice_manage_list;  /*!< 公告 >*/

 - (void)setClientGlobalInfoModel;
+ (ClientGlobalInfoRM *)getClientGlobalInfoModel;

@end
//全局配置-版本配置
@interface ClientVersionModel : NSObject
@property (nonatomic, copy) NSString* version;  //版本号
@property (nonatomic, copy) NSString* url;      //升级地址
@property (nonatomic, copy) NSString* need_force_update;    //是否强制升级 1是 0否
@property (nonatomic, copy) NSString* version_desc;
@end
//全局配置-链接
@interface WapUrlList : ParamModel
@property (nonatomic, copy) NSString* zcxy_url;
@property (nonatomic, copy) NSString* about_qwd_url;
@property (nonatomic, copy) NSString* credit_url;
@property (nonatomic, copy) NSString* question_url;
@property (nonatomic, copy) NSString* strategy_url;
@property (nonatomic, copy) NSString* zixun_url;
@property (nonatomic, copy) NSString* collect_info_grant_authorization_url;
//collect_info_grant_authorization_url 信息收集授权页面url
@end

//全局配置-广告数据结构
@interface BannerListModel :ParamModel
@property (nonatomic, copy) NSString* ad_id;
@property (nonatomic, copy) NSString* ad_type;
@property (nonatomic, copy) NSString* ad_detail_url;
@property (nonatomic, copy) NSString* ad_name;
@property (nonatomic, copy) NSString* ad_content;
@property (nonatomic, copy) NSString* img_url;
@property (nonatomic, copy) NSNumber* is_need_login;

//“ad_id”: “xxx”, // 广告id
//“ad_type”: “xxx”, // 广告类型: 1应用内打开 2浏览器打开
//“ad_detail_url”: “xxx”, // 广告链接
//“ad_name”: “xxx”, // 广告名称
//“ad_content”: “xxx”, // 广告内容
//“img_url”: “xxx”, // 广告图片链接地址
//广告列表相关接口和特色入口列表接口增加下发字段：　是否需要登录： is_need_login 1是0否 ，默认0
@end
//会话
@interface CreatSessionModel : NSObject
@property (nonatomic, copy) NSString *challenge;
@property (nonatomic, copy) NSString *pub_key_base64;
@property (nonatomic, copy) NSString *pub_key_modulus;
@property (nonatomic, copy) NSString *pub_key_exp;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userToken;

@end















