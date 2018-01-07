//
//  UpdateView.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/30.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "UpdateView.h"

 @interface UpdateView()<GuideMaskAlertViewDelegate>
/** UIWindow */
@property (nonatomic, strong) UIWindow *window;
/** XIntegerBlock */
@property (nonatomic, copy) XIntegerBlock block;

@end

@implementation UpdateView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = XColorWithRBBA(0, 0, 0, 0.4);
    }
    return self;
}

/** init */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imgUrlStr:(NSString *)imgUrlStr cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(XIntegerBlock)block
{
    /** 描述信息设置 */
    UpdateView *maskView = [[UpdateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.alertView.title = title;
    maskView.alertView.content = content;
    maskView.alertView.commitStr = commitStr;
    maskView.alertView.cancelStr = cancelStr;
    maskView.alertView.imgUrlStr = imgUrlStr;
    maskView.alertView.delegate = maskView;
    [maskView.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(maskView).offset(-AdaptationWidth(174));
        make.left.equalTo(maskView).offset((AdaptationWidth(52)));
        make.right.equalTo(maskView).offset(-AdaptationWidth(51));
        make.top.equalTo(maskView).offset(AdaptationWidth(125));
    }];
    maskView.block = block;
    return maskView;
}

/** 展示 */
- (void)show
{
    /** 新建窗口 */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevelAlert;
    [self.window addSubview:self];
    self.window.hidden = NO;

    
    /** 枚举动画类型 */
    NSString *type =nil;
    switch (self.animationType)
    {
        case showAnimationType_moveIn:{
            type = kCATransitionMoveIn;
        }
            break;
        case showAnimationType_Fade:{
            type = kCATransitionFade;
        }
            break;
        case showAnimationType_Push:{
            type = kCATransitionPush;
        }
            break;
        case showAnimationType_Reveal:{
            type = kCATransitionReveal;
        }
            break;
            
        default:
            break;
    }
    /** 动画效果 */
    if (self.animationType) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = type;
        transition.subtype = self.subType;
        [self.alertView.layer addAnimation:transition forKey:@"animationKey"];
    }
    
}

#pragma mark - GuideMaskAlertViewDelegate
- (void)guideMaskAlertView:(GuideMaskAlertView *)alertView actionIndex:(NSInteger)actionIndex
{
    [self dismiss];
    /** 判断block是否实现,返回actionIndex */
    XBlockExec(self.block, actionIndex);
}

/** 消失 */
- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 懒加载
- (GuideMaskAlertView *)alertView{
    if (!_alertView) {
        GuideMaskAlertView *view = [[GuideMaskAlertView alloc] init];
        [view setCornerValue:8.0f];
        view.backgroundColor = XColorWithRGB(255, 255, 255);
        _alertView = view;
        [self addSubview:_alertView];
    }
    return _alertView;
}

/** 内存管理 */
- (void)dealloc
{
    NSLog(@"GuideMaskView dealloc");
}

@end



@interface GuideMaskAlertView ()
/** 提交按钮 */
@property (nonatomic, strong) UIButton *commitBtn;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 副标题 */
@property (nonatomic, strong) UILabel *labSubTitle;
@end

@implementation GuideMaskAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

/** 创建UI */
- (void)setupViews{
    
    _titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = XColorWithRGB(34, 58, 80);
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)];
    self.titleLab.numberOfLines = 0;
    
    _labcontent = [[UILabel alloc] init];
    self.labcontent.textColor = XColorWithRBBA(34, 58, 80, 0.32);
    self.labcontent.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
    self.labcontent.numberOfLines = 0;
    
    /** 分割线 */
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
    
    [self addSubview:self.titleLab];
    [self addSubview:self.labcontent];
    [self addSubview:lineView];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-24);
        make.bottom.equalTo(self.labcontent.mas_top).offset(-9);
    }];
    
    [self.labcontent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(-63);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(AdaptationWidth(0));
        make.right.mas_equalTo(self).offset(-AdaptationWidth(1));
        make.bottom.mas_equalTo(self).offset(-AdaptationWidth(52));
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - 懒加载

/** 图片 */
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_imgUrlStr]];
        [self.superview addSubview:_imgView];

        /** 本地图片 */
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLab.mas_top).offset(-16);
            make.top.equalTo(self).offset(-AdaptationWidth(69));
            make.left.equalTo(self).offset(-AdaptationWidth(31));
            make.right.equalTo(self).offset(AdaptationWidth(31));
        }];
    }
    return _imgView;
}
/** 更新 */
- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [self createBtn];
        [self addSubview:_commitBtn];
        _commitBtn.tag = 1;
        [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-8);
            make.centerX.equalTo(self);
            make.width.greaterThanOrEqualTo(@75);
            make.height.equalTo(@36);
        }];
    }
    return _commitBtn;
}
/** 取消 */
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [self createBtn];
        _cancelBtn.tag = 0;
        [self.superview addSubview:_cancelBtn];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.greaterThanOrEqualTo(@28);
            make.height.equalTo(@28);
            make.bottom.equalTo(self).offset(AdaptationWidth(64));
        }];
    }
    return _cancelBtn;
}

/** 创建按钮 */
- (UIButton *)createBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)];
    [button setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/** 按钮点击方法 */
- (void)btnOnClick:(UIButton *)sender{
    /** 响应方法 */
    if ([self.delegate respondsToSelector:@selector(guideMaskAlertView:actionIndex:)])
    {
        [self.delegate guideMaskAlertView:self actionIndex:sender.tag];
    }
}

#pragma mark - 数据加载
/** title */
- (void)setTitle:(NSString *)title{
    if (!title) {
        return;
    }
    _title = title;
    self.titleLab.text = title;
}
/** content */
- (void)setContent:(NSString *)content{
    if (!content) {
        return;
    }
    _content = content;
    self.labcontent.text = content;
}

/** commitStr */
- (void)setCommitStr:(NSString *)commitStr{
    if (!commitStr) {
        return;
    }
    _commitStr = commitStr;
    [self.commitBtn setTitle:commitStr forState:UIControlStateNormal];
}
/** cancelStr */
- (void)setCancelStr:(NSString *)cancelStr{
    if (!cancelStr) {
        return;
    }
    _cancelStr = cancelStr;
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:cancelStr] forState:UIControlStateNormal];
}

/** imgUrlStr */
- (void)setImgUrlStr:(NSString *)imgUrlStr{
    if (!imgUrlStr) {
        return;
    }
    _imgUrlStr = imgUrlStr;
    self.imgView.hidden = NO;
}

@end

