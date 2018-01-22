//
//  AuthorizationVC.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/15.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "AuthorizationVC.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AuthorizationVC ()
{
    UILabel *AuthorizationLab;
    UIImageView *imageView;
    UIImageView *imageViewIn;
    UIView *bgView;
    UIButton *switchBtn;
    
}
@property (nonatomic ,copy) NSNumber *optType; // 1授权 2取消授权

@end

@implementation AuthorizationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setText:@"授权设置"];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:titleLab];
    
    UILabel *subtitleLab = [[UILabel alloc]init];
    subtitleLab.numberOfLines = 0;
    [subtitleLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [subtitleLab setText:@"在使用过程中，全网贷会为您推荐相应的贷款产品，您部分必要的个人信息（包括但不限于手机号、工作信息等）可能会根据您的需求，匹配给对应的第三方机构。"];
    [subtitleLab setTextColor:XColorWithRGB(77, 96, 114)];
    [self.view addSubview:subtitleLab];
    
    bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    AuthorizationLab = [[UILabel alloc]init];
    [AuthorizationLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [AuthorizationLab setText:@"授权我们为您推荐"];
    [AuthorizationLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [bgView addSubview:AuthorizationLab];
    
    
    
    switchBtn = [[UIButton alloc]init];
    switchBtn.layer.masksToBounds = YES;
    switchBtn.layer.cornerRadius = 14;
    switchBtn.layer.borderWidth = 0.5;
    switchBtn.layer.borderColor = XColorWithRGB(184, 192, 199).CGColor;
    [switchBtn setBackgroundColor:XColorWithRGB(184, 192, 199)];
    [switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:switchBtn];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 48.5 -11 , 20, 25, 25)];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 13;
    imageView.userInteractionEnabled = NO;
    [bgView addSubview:imageView];
    
    imageViewIn = [[UIImageView alloc]init];
    imageViewIn.image = [UIImage imageNamed:@"deny"];
    imageViewIn.userInteractionEnabled = NO;
    [imageView addSubview:imageViewIn];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(233, 233, 235);
    [bgView addSubview:line];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
    }];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subtitleLab.mas_bottom).offset(AdaptationWidth(32));
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(65);
    }];
    
    [AuthorizationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView).offset(AdaptationWidth(20));
        make.left.mas_equalTo(bgView).offset(AdaptationWidth(24));
        make.bottom.mas_equalTo(bgView).offset(-AdaptationWidth(20));
    }];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView);
        make.right.mas_equalTo(bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(40);
    }];
    [imageViewIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.height.width.mas_equalTo(16);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(bgView);
    }];
    
    MyLog(@"%@",[[UserInfo sharedInstance]getUserInfo].has_grant_authorization);
    MyLog(@"%@",[UserInfo sharedInstance].has_grant_authorization);
    if([UserInfo sharedInstance].has_grant_authorization.integerValue == 1){
        switchBtn.selected = YES;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame =CGRectMake(ScreenWidth - 25 - AdaptationWidth(24) - 1.5, 20, 25, 25);
            [imageViewIn setImage:[UIImage imageNamed:@"accept"]];
            [switchBtn setBackgroundColor:XColorWithRGB(7, 137, 133)];
            [AuthorizationLab setTextColor:XColorWithRGB(7, 137, 133)];
        }];
    }else{
        switchBtn.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(ScreenWidth - 25 - AdaptationWidth(24) - 13.5, 20, 25, 25);
            [imageViewIn setImage:[UIImage imageNamed:@"deny"]];
            [switchBtn setBackgroundColor:XColorWithRGB(184, 192, 199)];
            [AuthorizationLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        }];
    }
}

#pragma mark - 一一一一一 <* 开关 *> 一一一一一
-(void)switchAction:(UIButton *)btn{
    AudioServicesPlaySystemSound(1519);
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame =CGRectMake(ScreenWidth - 25 - AdaptationWidth(24) - 1.5 , 20, 25, 25);
            [imageViewIn setImage:[UIImage imageNamed:@"accept"]];
            [switchBtn setBackgroundColor:XColorWithRGB(7, 137, 133)];
            [AuthorizationLab setTextColor:XColorWithRGB(7, 137, 133)];
        }];
        self.optType = @(1);
        [self prepareDataWithCount:1];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = CGRectMake(ScreenWidth - 25 - AdaptationWidth(24) - 13.5, 20, 25, 25);
            [imageViewIn setImage:[UIImage imageNamed:@"deny"]];
            [switchBtn setBackgroundColor:XColorWithRGB(184, 192, 199)];
            [AuthorizationLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        }];
        self.optType = @(2);
        [self prepareDataWithCount:1];
    }
}

#pragma mark - 一一一一一 <* 网络请求 *> 一一一一一
-(void)setRequestParams{
    self.cmd = XGrantAuthorization;
    self.dict = @{@"opt_type":self.optType};
}
-(void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.optType.integerValue == 1) {
        self.optType = @(1);
    }else{
        self.optType = @(0);
    }
    [[UserInfo sharedInstance]savePhone:nil password:nil userId:nil grantAuthorization:self.optType];
//    [self setHudWithName:@"授权成功" Time:1 andType:0];
}
@end
