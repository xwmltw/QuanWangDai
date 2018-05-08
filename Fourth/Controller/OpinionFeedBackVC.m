//
//  OpinionFeedBackVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/17.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "OpinionFeedBackVC.h"
#import "XPlaceHolderTextView.h"
#import "ParamModel.h"
#import "XRootWebVC.h"
#import "ContactAlertViewController.h"

@interface OpinionFeedBackVC ()
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@end

@implementation OpinionFeedBackVC
{
    XPlaceHolderTextView *textView;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"意见反馈"];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [self.view addSubview:lab];
    
    textView = [[XPlaceHolderTextView alloc]init];
    textView.placeholder = @"留下宝贵的建议，我们会积极采纳哒~";
    textView.placeholderColor = XColorWithRBBA(34, 58, 80, 0.32);
    textView.backgroundColor = XColorWithRGB(245, 245, 250);
    textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    [self.view addSubview:textView];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = 100;
    [btn setCornerValue:5];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(17)]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel *helpLab = [[UILabel alloc]init];
    [helpLab setText:@"也可以拨打客服热线："];
    [helpLab setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [helpLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [self.view addSubview:helpLab];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.clientGlobalInfoModel.customer_contact attributes:@{NSForegroundColorAttributeName:XColorWithRGB(7, 137, 143),NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    UIButton *callBtn = [[UIButton alloc]init];
    callBtn.tag = 101;
    [callBtn setAttributedTitle:attStr forState:UIControlStateNormal];
    [callBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [callBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
    }];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(32));
        make.height.mas_equalTo(AdaptationWidth(218));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(textView.mas_bottom).offset(AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    [helpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(86));
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(24));
    }];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(helpLab.mas_right).offset(AdaptationWidth(1));
        make.centerY.mas_equalTo(helpLab);
    }];
    
}
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 100:{
            if (!textView.text.length) {
                [self setHudWithName:@"请写下您的宝贵意见" Time:2 andType:1];
                return;
            }
            ContactAlertViewController *rate = [[ContactAlertViewController alloc]init];
            rate.textstr = textView.text;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rate];
            nav.navigationBar.hidden = YES;
            nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 101:{
            NSString *tel = [NSString stringWithFormat:@"tel://4001689788"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)BarbuttonClick:(UIButton *)button{
    [self check:^(id result) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)check:(XBlock)block{
    if (textView.text.length != 0) {
       
        [XAlertView alertWithTitle:@"温馨提示" message:@"您输入的意见尚未保存,确认退出?" cancelButtonTitle:@"取消" confirmButtonTitle:@"退出" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 1:
                    XBlockExec(block,nil);
                    break;
            
                default:
                    break;
            }
        }];
    }
    XBlockExec(block,nil);
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
