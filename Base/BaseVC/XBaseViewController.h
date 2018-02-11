//
//  XBaseViewController.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/2.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XControllerViewHelper.h"
#import "XResponse.h"
#import "UserInfo.h"
#import "XAlertView.h"
#import "ParamModel.h"

@interface XBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int requestCount;/*!<   标记同一个控制器中的多次网络请求 */
@property (nonatomic, copy)NSString *cmd;/*!< 用于标示网络请求的接口类型 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//创建一个全局变量数组
@property (nonatomic) NSDictionary *dict; /*!< 网络请求参数*/
@property (nonatomic ,copy) XBlock block;//返回数据


/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type;

/** 创建TabBar的类方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setAdultTabBar;
+(NSArray *)setAdultTabBar;
/** 创建点击手势
*  view:手势作用的视图  tapNumber:触发点击手势的次数
*/
-(void)setTapGuestureWithView:(UIView *)view andTapNumber:(int)tapNumber;
/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame;
/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh;

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh;
/** 点击手势的点击事件
 *  通过 guesture.view 获取点击手势添加的视图
 */
-(void)tapGuesture:(UITapGestureRecognizer *)guesture;
/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem;
/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button;
/**
 隐藏tabBar
 */
-(void)hideTabBar;

/**
 显示tabBar
 */
-(void)showTabBar;
/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams;

/**  准备网络请求的参数,供子类调用重写
 *  count:用于表示多次网络请求的标识(0:表示tableView的数据创建)
 */
-(void)prepareDataWithCount:(int)count;

/**
 网络操作成功
 
 @param response 成功之后的数据detail
 */
-(void)requestSuccessWithDictionary:(XResponse *)response;

/**
 网络操作失败
 
 @param response 失败之后的数据object
 */
-(void)requestFaildWithDictionary:(XResponse *)response;

-(void)prepareDataGetUrlWithModel:(id)model andparmeter:(NSDictionary *)dict;
//是否登录
/**
 返回登录口

 @param controller 当前控制器
 */
- (void)getBlackLogin:(UIViewController *)controller;


/**
 授权提示
 */
- (void)showAlertView;

@end
