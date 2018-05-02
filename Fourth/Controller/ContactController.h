//
//  ContactController.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/13.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "ApplyListModel.h"
@interface ContactController : XBaseViewController
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UIButton *CopyButton;
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UILabel *ContactType;
@property (weak, nonatomic) IBOutlet UILabel *ContactString;
@property (nonatomic, strong) ApplyListModel *model;

@end
