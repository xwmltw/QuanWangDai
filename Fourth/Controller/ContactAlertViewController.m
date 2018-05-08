//
//  ContactAlertViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ContactAlertViewController.h"
#import "OpinionFeedBackVC.h"
typedef NS_ENUM(NSInteger , OpinionFeedBackRequest) {
    OpinionFeedBackRequestPostInfo,
};
@interface ContactAlertViewController ()

@end

@implementation ContactAlertViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ContactAlertViewController" owner:self options:nil];
        self.title_label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
        self.subtitle_label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)];
        self.textfield_1.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        self.textfield_1.leftViewMode = UITextFieldViewModeAlways;
        self.textfield_2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        self.textfield_2.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)commiteAciton:(id)sender {
   [self prepareDataWithCount:OpinionFeedBackRequestPostInfo];
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case OpinionFeedBackRequestPostInfo:
            self.cmd = XPostFeedback;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.textstr,@"feedback_desc",
                         self.textfield_1.text,@"account_qq",
                         self.textfield_2.text,@"wechat_number",nil];
            break;
            
        default:
            break;
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OpinionFeedBackRequestPostInfo:{
            [self setHudWithName:@"提交成功，谢谢您的建议。" Time:1.5 andType:0];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
