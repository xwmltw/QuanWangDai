//
//  ContactUsController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ContactUsController.h"
#import "ParamModel.h"

typedef NS_ENUM(NSInteger , ContactRequest) {
    ContactRequestInfo,
};
@interface ContactUsController ()<UIGestureRecognizerDelegate>
{
    UIImageView *bottomImageView;
    UIButton *copyButton;
    UIImageView *QR_code;
    CGPoint point;
}
@property (nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic ,strong) ClientGlobalInfoRM *clientGlobalModel;
@end

@implementation ContactUsController
-(ClientGlobalInfoRM *)clientGlobalModel{
    if (!_clientGlobalModel) {
        _clientGlobalModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalModel;
}
-(UIDynamicAnimator*)animator{
    if (_animator == nil){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"联系我们" forState:UIControlStateNormal];
    [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(28), 0, -AdaptationWidth(28));
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIView *lineview  = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
    lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
    [button addSubview:lineview];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self prepareDataWithCount:ContactRequestInfo];
    
    [self createMianUI];
    [self createbottomView];
    
    //3.平移
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:panGesture];
}

-(void)createbottomView{
    bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, AdaptationWidth(419), self.view.frame.size.width, self.view.frame.size.height)];
    bottomImageView.image = [UIImage imageNamed:@"bg_card"];
    [self.view addSubview:bottomImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDetailViewController:)];
    tap.delegate = self;
    bottomImageView.userInteractionEnabled = YES;
    [bottomImageView addGestureRecognizer:tap];
    
    UIView *doubleline = [[UIView alloc]init];
    doubleline.backgroundColor = XColorWithRBBA(34, 58, 80, 0.16);
    [bottomImageView addSubview:doubleline];
    
    UILabel *TitleLabel = [[UILabel alloc]init];
    TitleLabel.numberOfLines = 2;
    [TitleLabel setText:@"加入全网贷官方Q群。入群红包大派送，数万老铁分享成功下款秘籍！"];
    [TitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [TitleLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [bottomImageView addSubview:TitleLabel];
    
    UIView *singleline = [[UIView alloc]init];
    singleline.backgroundColor = XColorWithRBBA(233, 233, 235, 1);
    [bottomImageView addSubview:singleline];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    [nameLabel setText:@"官方Q群"];
    [nameLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [nameLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [bottomImageView addSubview:nameLabel];
    
    UILabel *numberLabel = [[UILabel alloc]init];
    [numberLabel setText:self.clientGlobalModel.qq_group_numbr];
    [numberLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
    [numberLabel setTextColor:XColorWithRGB(252, 93, 109)];
    [bottomImageView addSubview:numberLabel];
    
    copyButton = [[UIButton alloc]init];
    [copyButton setTitle:@"复制Q群" forState:UIControlStateNormal];
    [copyButton setCornerValue:2];
    copyButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
    [copyButton setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [copyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyButton  setTitleColor:XColorWithRBBA(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [copyButton addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:copyButton];

    
    [doubleline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomImageView);
        make.height.mas_equalTo(4);
        make.width.mas_equalTo(48);
        make.top.mas_equalTo(bottomImageView).offset(AdaptationWidth(24));
    }];
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomImageView).offset(AdaptationWidth(32));
        make.top.mas_equalTo(doubleline.mas_bottom).offset(AdaptationWidth(16));
        make.right.mas_equalTo(bottomImageView).offset(-AdaptationWidth(32));
    }];
    [singleline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomImageView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(bottomImageView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(TitleLabel.mas_bottom).offset(AdaptationWidth(16));
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomImageView).offset(AdaptationWidth(32));
        make.top.mas_equalTo(singleline.mas_bottom).offset(AdaptationWidth(16));
        make.right.mas_equalTo(bottomImageView).offset(-AdaptationWidth(32));
    }];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomImageView).offset(AdaptationWidth(32));
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(AdaptationWidth(4));
        make.right.mas_equalTo(copyButton.mas_left).offset(-AdaptationWidth(10));
        make.height.mas_equalTo(AdaptationWidth(25));
    }];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bottomImageView).offset(-AdaptationWidth(40));
        make.top.mas_equalTo(singleline.mas_bottom).offset(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(69));
        make.height.mas_equalTo(AdaptationWidth(28));
    }];
}

-(void)createMianUI{
    UILabel *contactTitleLabel = [[UILabel alloc]init];
    contactTitleLabel.numberOfLines = 2;
    [contactTitleLabel setText:@"关注官方微信公众号，新口子、新活动、独家提额秘籍每日享不停！"];
    [contactTitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
    [contactTitleLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:contactTitleLabel];
    
    QR_code = [[UIImageView alloc]init];
    QR_code.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.clientGlobalModel.wechat_public_logo]]];
    [self.view addSubview:QR_code];
    //  添加手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
    QR_code.userInteractionEnabled = YES; // 打开交互
    [QR_code addGestureRecognizer:longPress];

    
    UILabel *contactTip = [[UILabel alloc]init];
    contactTip.numberOfLines = 2;
    contactTip.textAlignment = NSTextAlignmentCenter;
    [contactTip setText:@"长按上方图片保存二维码\n打开微信扫一扫选择图片"];
    [contactTip setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
    [contactTip setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
    [self.view addSubview:contactTip];
    
    [contactTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
    }];
    [QR_code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(contactTitleLabel.mas_bottom).offset(AdaptationWidth(16));
        make.height.width.mas_equalTo(AdaptationWidth(200));
    }];
    [contactTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(QR_code.mas_bottom).offset(AdaptationWidth(12));
        make.height.mas_equalTo(AdaptationWidth(40));
        make.width.mas_equalTo(AdaptationWidth(200));
    }];
}

-(void)copyClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyButton.titleLabel.text;
    [self setHudWithName:@"复制成功，去QQ内添加" Time:1 andType:3];
}
- (void)longPressAction{
    
    UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存图片" preferredStyle:1];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(QR_code.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),NULL); // 写入相册
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    [con addAction:action];
    [con addAction:action1];
    [self presentViewController:con animated:YES completion:nil];
}
// 完善回调
-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if(!error){
        UIAlertController *con = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片保存成功！" preferredStyle:1];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:1 handler:nil];
        [con addAction:action];
        [self presentViewController:con animated:YES completion:nil];
    }else{
        NSLog(@"savefailed");
    }
}

#pragma mark - 一一一一一 <* UITapGestureRecognizer *> 一一一一一
-(void)showDetailViewController:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        if (CGRectGetMinY(bottomImageView.frame) == AdaptationWidth(8)) {
            bottomImageView.frame = CGRectMake(0, AdaptationWidth(419), self.view.frame.size.width, self.view.frame.size.height);
        }else{
            bottomImageView.frame = CGRectMake(0, AdaptationWidth(8), self.view.frame.size.width, self.view.frame.size.height);
        }
    }];
}
-(void)panAction:(UIPanGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        point = [gesture locationInView:self.view];
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point2 = [gesture locationInView:self.view];
        CGFloat p = point2.y - point.y;
        [UIView animateWithDuration:0.2 animations:^{
            if (p > 0) {
                if (CGRectGetMinY(bottomImageView.frame) == AdaptationWidth(419)) {
                    bottomImageView.frame = CGRectMake(0, AdaptationWidth(419), self.view.frame.size.width, self.view.frame.size.height);
                    return ;
                }
                bottomImageView.frame = CGRectMake(0, point.y + p, self.view.frame.size.width, self.view.frame.size.height);       
                if (CGRectGetMinY(bottomImageView.frame) == AdaptationWidth(8)) {
                    bottomImageView.frame = CGRectMake(0, AdaptationWidth(8), self.view.frame.size.width, self.view.frame.size.height);
                }
            }else{
                if (CGRectGetMinY(bottomImageView.frame) == AdaptationWidth(8)) {
                    bottomImageView.frame = CGRectMake(0, AdaptationWidth(8), self.view.frame.size.width, self.view.frame.size.height);
                    return;
                }
                bottomImageView.frame = CGRectMake(0, point.y + p, self.view.frame.size.width, self.view.frame.size.height);
                if (CGRectGetMinY(bottomImageView.frame) == AdaptationWidth(419)) {
                    bottomImageView.frame = CGRectMake(0, AdaptationWidth(419), self.view.frame.size.width, self.view.frame.size.height);
                }
            }
        }];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (CGRectGetMinY(bottomImageView.frame) < AdaptationWidth(419)/2) {
            [UIView animateWithDuration:0.5 animations:^{
                bottomImageView.frame = CGRectMake(0, AdaptationWidth(8), self.view.frame.size.width, self.view.frame.size.height);
            }];
        }else if(CGRectGetMinY(bottomImageView.frame) > AdaptationWidth(419)/2){
            [UIView animateWithDuration:0.5 animations:^{
                bottomImageView.frame = CGRectMake(0, AdaptationWidth(419), self.view.frame.size.width, self.view.frame.size.height);
            }];
        }
    }
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case ContactRequestInfo:{
            self.cmd = XClientGlobalInfo;
            self.dict = [NSDictionary new];
            
            };
            break;
    
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ContactRequestInfo:{
            _clientGlobalModel = [ClientGlobalInfoRM mj_objectWithKeyValues:response.content];
        }
            break;
            
        default:
            break;
            
    }
}
@end
