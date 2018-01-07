//
//  SuccessApplicationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "SuccessApplicationVC.h"
#import "DataDetailVC.h"
#import "RecommendViewController.h"
#import "AllDKViewController.h"

@interface SuccessApplicationVC ()

@end

@implementation SuccessApplicationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"申请成功页面"];
    [self setUI];
}
- (void)setUI{
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"notData"]];
    [self.view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:@"恭喜, 申请成功！"];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    [labDetail setText:@"请保持手机通畅，稍后工作人员会与您联系。"];
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [self.view addSubview:labDetail];
    
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    [btnContinue setTitle:@"继续申请" forState:UIControlStateNormal];
    [btnContinue setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContinue];
    
    UIButton *btnBack = [[UIButton alloc]init];
    btnBack.tag = 101;
    [btnBack setTitle:@"返回首页" forState:UIControlStateNormal];
    [btnBack setBackgroundColor:XColorWithRGB(255, 255, 255)];
    [btnBack setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [btnBack  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(64));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    }];
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(4));
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(32));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    
    [btnContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(48));
        make.width.mas_equalTo(AdaptationWidth(155));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(48));
        make.width.mas_equalTo(AdaptationWidth(155));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    
}
- (void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        AllDKViewController *vc = [[AllDKViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
