//
//  UpdateView.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/30.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuideMaskAlertView;
/** GuideMaskAlertViewDelegate */
@protocol GuideMaskAlertViewDelegate <NSObject>
/** 按钮点击 */
- (void)guideMaskAlertView:(GuideMaskAlertView *)alertView actionIndex:(NSInteger)actionIndex;

@end

typedef NS_ENUM(NSInteger, showAnimationType) {
    showAnimationType_default,  //默认动画（无）
    showAnimationType_moveIn,   //移入
    showAnimationType_Push,     //push方式
    showAnimationType_Fade,     //淡入淡出
    showAnimationType_Reveal,   //渐入
};

#pragma mark - 底部视图
@interface UpdateView : UIView
/** 枚举 */
@property (nonatomic, assign) showAnimationType animationType;
/** 动画子类型 */
@property (nonatomic, copy) NSString *subType;
/** GuideMaskAlertView */
@property (nonatomic, weak) GuideMaskAlertView *alertView;

/** init */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imgUrlStr:(NSString *)imgUrlStr cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(XIntegerBlock)block;

/** 展示 */
- (void)show;

@end



#pragma mark - 弹窗视图
@interface GuideMaskAlertView : UIView
/** 代理 */
@property (nonatomic, weak) id<GuideMaskAlertViewDelegate> delegate;
/** 标题label */
@property (nonatomic, strong, readonly) UILabel *titleLab;
/** 详细信息label */
@property (nonatomic, strong, readonly) UILabel *labcontent;
/** 图片view */
@property (nonatomic, strong) UIImageView *imgView;

/** 描述信息 */
@property (nonatomic, copy) NSString *title;      // 标题
@property (nonatomic, copy) NSString *content;    // 内容
@property (nonatomic, copy) NSString *commitStr;  // 提交按钮文字
@property (nonatomic, copy) NSString *cancelStr;  // 取消按钮文字
@property (nonatomic, copy) NSString *imgUrlStr;  // 图片地址

@end


