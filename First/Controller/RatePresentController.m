//
//  RatePresentController.m
//  QuanWangDai
//
//  Created by mac on 2018/4/11.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "RatePresentController.h"

@interface RatePresentController ()

@end

@implementation RatePresentController

-(instancetype)init{
	self = [super init];
	if (self) {
		[[NSBundle mainBundle] loadNibNamed:@"RatePresentController"owner:self options:nil];
        self.subTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)];
        self.rateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.rateLabel.textColor = XColorWithRBBA(34, 58, 80, 0.8);
        self.Interest_rates.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.Interest_rates.textColor = XColorWithRBBA(34, 58, 80, 0.8);
        self.server_lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.service_fee.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.service_fee.textColor = XColorWithRBBA(34, 58, 80, 0.8);
        self.poundage.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
        self.poundage.textColor = XColorWithRBBA(34, 58, 80, 0.8);

	}
	return self;
}
- (IBAction)rateAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = XColorWithRGB(255, 255, 255);
	self.view.alpha = 0.9;
//	/*!< 毛玻璃 >*/
//	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//	UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
//	visualView.frame = self.view.frame;
//	[self.view addSubview:visualView];

}

-(void)setModel:(ProductModel *)model{

    if ( model.loan_year_rate.integerValue < 36 ) {
        if ((![model.loan_min_credit isEqualToString:model.loan_max_credit] && model.cooperation_type.integerValue == 1) || ![model.min_loan_rate isEqualToString:model.loan_rate]) {
            self.Interest_rates.text = @"浮动";
            self.rateLabel.text = @"利率利息";
            self.subTitle.hidden = YES;
            self.rateConstraint.constant = 23;
        }else{
            switch ([model.loan_deadline_type integerValue]) {
                case 1:{  // 借款期限 天
                    switch ([model.loan_rate_type integerValue]) {
                        case 1:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum];
                        }
                            break;
                        case 2:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/30/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum];
                        }
                            break;
                        case 3:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/360/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 2:{ // 借款期限 月
                    switch ([model.loan_rate_type integerValue]) {
                        case 1:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum *30];
                        }
                            break;
                        case 2:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum];
                        }
                            break;
                        case 3:{
                            float sum = self.moneyStr.integerValue * self.dateStr.integerValue * model.loan_rate.doubleValue/12/100;
                            self.Interest_rates.text = [NSString stringWithFormat:@"%.2f 元",sum];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    
                default:
                    break;
            }
            
            if (model.loan_rate.length > 5) {
                NSString *substring = [model.loan_rate substringToIndex:5];
                switch ([model.loan_rate_type integerValue]) {
                    case 1:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考日利率 %@%%)",substring]];
                        break;
                    case 2:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考月利率 %@%%)",substring]];
                        break;
                    case 3:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考年利率 %@%%)",substring]];
                        break;
                        
                    default:
                        break;
                }
            }else{
                switch ([model.loan_rate_type integerValue]) {
                    case 1:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考日利率 %@%%)",model.loan_rate]];
                        break;
                    case 2:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考月利率 %@%%)",model.loan_rate]];
                        break;
                    case 3:
                        [self.rateLabel setText:[NSString stringWithFormat:@"利率利息 (参考年利率 %@%%)",model.loan_rate]];
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }else{
        self.Interest_rates.text = @"浮动";
        self.rateLabel.text = @"利率利息";
        self.subTitle.hidden = YES;
        self.rateConstraint.constant = AdaptationWidth(32);
    }
    if (model.agency_fee.integerValue == -1) {
        self.service_fee.text = @"面议";
    }else{
        self.service_fee.text = [NSString stringWithFormat:@"%.2f 元",model.agency_fee.doubleValue/100];
    }
    if (model.service_fee_rate.integerValue == -1) {
        self.poundage.text = @"面议";
    }else{
        self.poundage.text = [NSString stringWithFormat:@"%.2f 元",(self.moneyStr.integerValue * model.service_fee_rate.doubleValue /100)];
    }
    if ([self.Interest_rates.text isEqualToString:@"浮动"] || [self.service_fee.text isEqualToString:@"面议"] || [self.poundage.text isEqualToString:@"面议"]) {
        self.total.text = @"浮动";
    }else{
        self.total.text = [NSString stringWithFormat:@"%.2f 元",self.Interest_rates.text.doubleValue + self.service_fee.text.doubleValue + self.poundage.text.doubleValue ];
//        NSLog(@"%@,%@,%@,%@",self.Interest_rates.text,self.service_fee.text,self.poundage.text,self.total.text);
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
