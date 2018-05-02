//
//  PhoneController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/13.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "PhoneController.h"

@interface PhoneController ()

@end

@implementation PhoneController
-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"PhoneController" owner:self options:nil];
        [self.BGView setCornerValue:8.0];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)changeAction:(id)sender {
    
}

- (IBAction)comfirmAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"%@",self.phoneNumber.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)dissmissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
