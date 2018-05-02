//
//  ContactController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/13.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ContactController.h"

@interface ContactController ()

@end

@implementation ContactController
-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ContactController" owner:self options:nil];
        [self.BgView setCornerValue:8.0];
        [self.CopyButton setCornerValue:2.0];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)setModel:(ApplyListModel *)model{
    if (model.contact_wechat_number.length) {
        self.ContactType.text = @"微信号";
        self.Description.text = @"商家提供了微信号，您可以添加对方微信号，办理效率更高";
        self.ContactString.text = model.contact_wechat_number;
    }
    if (!model.contact_wechat_number.length && model.contact_wechat_public.length) {
        self.ContactType.text = @"微信公众号";
        self.Description.text = @"商家提供了微信公众号，您可以添加对方微信公众号，办理效率更高";
        self.ContactString.text = model.contact_wechat_public;
    }
    if (!model.contact_wechat_number.length && !model.contact_wechat_public.length && model.contact_qq.length) {
        self.ContactType.text = @"QQ";
        self.Description.text = @"商家提供了QQ，您可以主动添加对方QQ,办理效率更高";
        self.ContactString.text = model.contact_qq;
    }
    
}
- (IBAction)CopyAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ContactString.text;
    [self setHudWithName:@"复制成功" Time:1 andType:3];
}

- (IBAction)dissmissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
