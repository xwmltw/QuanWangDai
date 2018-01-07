//
//  InterfaceDefine.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/15.
//  Copyright © 2017年 kizy. All rights reserved.
//

#ifndef InterfaceDefine_h
#define InterfaceDefine_h

/** TalkingData */
#ifdef DEBUG
static NSString *const TalkingData_AppID =   @"";
static NSString *const TD_AdTrackingID =     @"";
#else
static NSString *const TalkingData_AppID =   @"0840A8EB6BC34C9B9A36403D7123D176";
static NSString *const TD_AdTrackingID =     @"";
#endif

/** 芝麻信用 */
#ifdef DEBUG
static NSString *const XZMAPPID =   @"300000041";

#else
static NSString *const XZMAPPID =   @"300000041";

#endif

/** 网络环境*/
#ifdef DEBUG
#define SERVICEURL @"http://192.168.5.151:8080/qwd-server/openapi/1"//测试环境
#else

#define SERVICEURL @"http://api.91qwd.com/openapi/1" //正式环境

#endif

#define XClientGlobalInfo @"qwd_getClientGlobalInfo"            /*!< 全局配置*/
#define XPostIosDevInfo @"qwd_postIosDevInfo"                   /*!< 提交ios设备信息*/
#define XUserLogin @"qwd_userLogin"                             /*!< 登录*/
#define XUserLogout @"qwd_userLogout"                           /*!< 退出登录*/
#define XRegistUserByPhoneNum @"qwd_registUserByPhoneNum"       /*!< 注册*/
#define XSmsAuthenticationCode @"qwd_getSmsAuthenticationCode"  /*!< 短信验证码*/
#define XModifyPassword @"qwd_modifyPassword"                   /*!< 修改密码*/
#define XResetPasswordByPhoneNum  @"qwd_resetPasswordByPhoneNum"/*!< 找回密码*/
#define XPostFeedback @"qwd_postFeedback"                       /*!< 提交建议和反馈*/
#define XGetHelpCenterList @"qwd_getHelpCenterList"             /*!< 获取帮助中心列表*/

#define XGetCreditInfo @"qwd_getCreditInfo"                     /*!< 1.1.1获取信用总体信息*/
#define XGetIdCardVerifyParams @"qwd_getIdCardVerifyParams"     /*!< 获取认证参数信息*/
#define XPostIdCardInfo @"qwd_postIdCardInfo"                   /*!< 提交身份相关信息*/
#define XAuthorizeQry @"qwd_authorizeQry"                       /*!< 芝麻信用授权*/
#define XZhimaCallBack @"qwd_zhimaCallBack"                     /*!< 芝麻信用回调*/
#define XGetOperatorInfo @"qwd_getOperatorInfo"                 /*!< 下发运营商认证所需参数*/
#define XPostOperatorVerify @"qwd_postOperatorVerify"           /*!< 上传运营商认证信息*/
#define XResetOperatorPwd @"qwd_resetOperatorPwd"               /*!< 忘记运营商密码*/
#define XPostContactInfo @"qwd_postContactInfo"                 /*!< 上传基本信息*/
#define XGetContactInfo @"qwd_getContactInfo"                   /*!< 获取基本信息*/
#define XGetSupportedBankList @"qwd_getSupportedBankList"       /*!< 查询支持的银行卡列表*/
#define XGetBankIsSupported @"qwd_getBankIsSupported"           /*!< 查询银行卡系统是否支持*/
#define XBankCardCheck @"qwd_bankCardCheck"                     /*!< 上传银行卡信息*/
#define XGetBankCardCheckInfo @"qwd_getBankCardCheckInfo"       /*!< 获取银行卡信息*/
#define XPostWorkInfo @"qwd_postWorkInfo"                       /*!< 上传工作信息*/
#define XGetWorkInfo @"qwd_getWorkInfo"                         /*!< 获取工作信息*/
#define XPostLoanPlatInfo @"qwd_postLoanPlatInfo"               /*!< 上传借贷平台信息*/
#define XGetLoanPlatInfo @"qwd_getLoanPlatInfo"                 /*!< 查询借贷平台信息*/
#define XApplyLoan @"qwd_applyLoan"                             /*!< 用户申请贷款产品*/

#define XGetHotLoanProList @"qwd_getHotLoanProList"             /*!< 查询热门贷款推荐列表*/
#define XGetLoanProDetail @"qwd_getLoanProDetail"               /*!< 查询贷款产品详情*/
#define XGetLoanProList @"qwd_getLoanProList"                   /*!< 查询贷款产品列表*/
#define XAdClickLogRecord @"qwd_adClickLogRecord"               /*!< 记录广告点击日志*/
#define XArticleClickRecord @"qwd_articleClickRecord"           /*!< 记录文章详情点击日志*/
#define XGetZiXunCenter @"qwd_getZiXunCenter"                   /*!< 获取资讯中心内容*/



#endif /* InterfaceDefine_h */
