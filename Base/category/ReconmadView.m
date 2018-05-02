//
//  ReconmadView.m
//  QuanWangDai
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ReconmadView.h"

@interface ReconmadView()<MaskAlertViewDelegate>
/** UIWindow */
@property (nonatomic, strong) UIWindow *window;
/** XIntegerBlock */
@property (nonatomic, copy) XIntegerBlock block;

@end
@implementation ReconmadView
- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {

        /*!< 毛玻璃 >*/
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.subviews[1].backgroundColor = XColorWithRBBA(0, 0, 0, 0.6);
        visualView.frame = self.frame;
        [self addSubview:visualView];
	}
	return self;
}

/** init */
- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imgUrlStr:(NSString *)imgUrlStr cancel:(NSString *)cancelStr commit:(NSString *)commitStr block:(XIntegerBlock)block
{
	/** 描述信息设置 */
	ReconmadView *maskView = [[ReconmadView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	maskView.alertView.title = title;
	maskView.alertView.content = content;
	maskView.alertView.commitStr = commitStr;
	maskView.alertView.cancelStr = cancelStr;
	maskView.alertView.imgUrlStr = imgUrlStr;
	maskView.alertView.remindStr = @"不再提醒";
	maskView.alertView.delegate = maskView;
	[maskView.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(maskView).offset(-AdaptationWidth(184));
		make.left.mas_equalTo(maskView).offset((AdaptationWidth(62)));
		make.right.mas_equalTo(maskView).offset(-AdaptationWidth(61));
		make.top.mas_equalTo(maskView).offset(AdaptationWidth(184));
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
- (void)guideMaskAlertView:(MaskAlertView *)alertView actionIndex:(NSInteger)actionIndex
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
- (MaskAlertView *)alertView{
	if (!_alertView) {
		MaskAlertView *view = [[MaskAlertView alloc] init];
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



@interface MaskAlertView ()
{
	CGSize labelSize;
}
/** 提交按钮 */
@property (nonatomic, strong) UIButton *commitBtn;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancelBtn;
/** 不再提醒 */
@property (nonatomic, strong) UIButton *Dont_remind_Btn;
/** 副标题 */
@property (nonatomic, strong) UILabel *labSubTitle;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation MaskAlertView

- (instancetype)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupViews];
	}
	return self;
}

/** 创建UI */
- (void)setupViews{
	
	self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
	self.bgView.backgroundColor = [UIColor clearColor];
	[self.scrollView addSubview:self.bgView];
	
	_titleLab = [[UILabel alloc] init];
	self.titleLab.textColor = XColorWithRGB(34, 58, 80);
	self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)];
	[self addSubview:self.titleLab];
	
	_labcontent =  [[UILabel alloc] initWithFrame:CGRectMake(AdaptationWidth(16), 0, AdaptationWidth(220), AdaptationWidth(63))];
	self.labcontent.textColor = XColorWithRBBA(34, 58, 80, 0.48);
	self.labcontent.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
	self.labcontent.numberOfLines = 0;
	[self.bgView addSubview:self.labcontent];
	
	/** 分割线 */
	self.lineView = [[UIView alloc]init];
	[self.lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
	[self addSubview:self.lineView];
	
	
	[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self);
		make.right.mas_equalTo(self);
		make.height.mas_equalTo(AdaptationWidth(63));
		make.bottom.mas_equalTo(self.lineView.mas_top);
	}];
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(self).offset(AdaptationWidth(16));
		make.right.mas_equalTo(self).offset(-AdaptationWidth(16));
		make.bottom.mas_equalTo(self.scrollView.mas_top).offset(-AdaptationWidth(8));
		make.height.mas_equalTo(AdaptationWidth(25));
	}];
	//    [self.labcontent mas_makeConstraints:^(MASConstraintMaker *make) {
	//        make.left.mas_equalTo(self.bgView).offset(AdaptationWidth(24));
	//        make.right.mas_equalTo(self.bgView).offset(-AdaptationWidth(24));
	//        make.top.mas_equalTo(self.bgView);
	////        make.height.mas_equalTo(AdaptationWidth(20));
	//    }];
	[self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
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
			make.bottom.mas_equalTo(self.titleLab.mas_top).offset(-AdaptationWidth(16));
			make.top.mas_equalTo(self).offset(-AdaptationWidth(33));
			make.left.mas_equalTo(self);
			make.right.mas_equalTo(self);
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
			make.bottom.mas_equalTo(self).offset(-AdaptationWidth(8));
			make.centerX.mas_equalTo(self);
			make.width.greaterThanOrEqualTo(@75);
			make.height.mas_equalTo(AdaptationWidth(36));
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
			make.centerX.mas_equalTo(self);
			make.width.mas_equalTo(AdaptationWidth(28));
			make.height.mas_equalTo(AdaptationWidth(28));
			make.bottom.mas_equalTo(self).offset(AdaptationWidth(145));
		}];
	}
	return _cancelBtn;
}
/** 不再提醒 */
- (UIButton *)Dont_remind_Btn{
	if (!_Dont_remind_Btn) {
		_Dont_remind_Btn = [self createBtn1];
		[self.superview addSubview:_Dont_remind_Btn];
		
		[_Dont_remind_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self).offset(AdaptationWidth(45));
			make.width.mas_equalTo(AdaptationWidth(70));
			make.height.mas_equalTo(AdaptationWidth(22));
			make.top.mas_equalTo(self).offset(-AdaptationWidth(140));
		}];
	}
	return _Dont_remind_Btn;
}

/** 创建按钮 */
- (UIButton *)createBtn{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)];
	[button setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
	[button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}
/** 创建按钮 */
- (UIButton *)createBtn1{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
	[button setTitleColor:XColorWithRGB(255, 255, 255) forState:UIControlStateNormal];
	[button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = 2;
	return button;
}

/** 按钮点击方法 */
- (void)btnOnClick:(UIButton *)sender{
	/** 响应方法 */
	if ([self.delegate respondsToSelector:@selector(guideMaskAlertView:actionIndex:)]){
		[self.delegate guideMaskAlertView:self actionIndex:sender.tag];
	}
}
-(UIScrollView *)scrollView{
	if (!_scrollView) {
		self.scrollView = [[UIScrollView alloc]init];
		self.scrollView.backgroundColor = [UIColor clearColor];
		self.scrollView.directionalLockEnabled  = YES;
		self.scrollView.bounces = YES;
		self.scrollView.showsVerticalScrollIndicator = NO;
		[self addSubview:self.scrollView];
	}
	return _scrollView;
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
//	CGSize size = CGSizeMake(AdaptationWidth(220), MAXFLOAT);
//	CGFloat fontSize = 14.0;
//	NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
//	labelSize = [self.labcontent.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
//	self.labcontent.frame = CGRectMake(self.labcontent.frame.origin.x, self.labcontent.frame.origin.y, labelSize.width, labelSize.height);
//	self.scrollView.contentSize = CGSizeMake(AdaptationWidth(252), labelSize.height);
	self.scrollView.contentSize = CGSizeMake(ScreenWidth - AdaptationWidth(124), AdaptationWidth(63));

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
-(void)setRemindStr:(NSString *)remindStr{
	if (!remindStr) {
		return;
	}
	_remindStr = remindStr;
	[self.Dont_remind_Btn setTitle:remindStr forState:UIControlStateNormal];
}
@end


