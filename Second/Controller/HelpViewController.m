//
//  HelpViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"HelpViewController" owner:self options:nil];
        [self.title_label setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
        [self.discription_label1 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        [self.discription_label3 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"特别说明：由于各地运营商系统都不相同，可能 需要输入运营商密码以及多次的验证码。"];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                      range:titleRange];
        [title addAttribute:NSForegroundColorAttributeName value:XColorWithRBBA(34, 58, 80, 0.48) range:titleRange];
        self.dicription_label2.attributedText = title;
        [self.dicription_label2 setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
    }
    return self;
}

- (IBAction)dismissAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


@end
