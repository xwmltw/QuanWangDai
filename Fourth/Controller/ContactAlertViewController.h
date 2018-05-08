//
//  ContactAlertViewController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"

@interface ContactAlertViewController : XBaseViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_label;
@property (weak, nonatomic) IBOutlet UITextField *textfield_1;
@property (weak, nonatomic) IBOutlet UITextField *textfield_2;
@property (weak, nonatomic) IBOutlet UIButton *commit_button;
@property (nonatomic,copy) NSString *textstr;
@end
