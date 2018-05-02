//
//  ReportController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ReportController.h"
#import "ReportCell.h"
#import "HelpViewController.h"
#import "PayView.h"
#import "PaySuccessController.h"
#import "ReportModel.h"
#import "XRootWebVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ReportOrderModel.h"
#import "DateHelper.h"
typedef NS_ENUM(NSInteger , ReportRequest) {
    ReportRequestInfo,
    ReportRequestUpload,
    ReportRequestPay,
    ReportRequestPayInfo,
};
@interface ReportController ()<PayViewDelegate>

@property (nonatomic, strong) PayView *payView;
@property (nonatomic,strong) ReportModel *reportModel;
@property (nonatomic,strong) ReportDetailModel *reportDetailModel;
@property (nonatomic,strong) ReportOrderModel *reportOrderModel;
@property (nonatomic, copy) NSNumber *reportType;//报告类型,1运营商2信贷预测
@end

@implementation ReportController
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 134, 44);
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"我的信用报告" forState:UIControlStateNormal];
    [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(28), 0, -AdaptationWidth(28));
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIView *lineview  = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
    lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
    [button addSubview:lineview];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIView *ringhtView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightbutton.frame = CGRectMake(0, 0, 64, 44);
    [rightbutton setImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [ringhtView addSubview:rightbutton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:ringhtView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)rightbuttonClick{
    HelpViewController *help = [[HelpViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:help];
    nav.navigationBar.hidden = YES;
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【我的信用报告】页"];
    [self prepareDataWithCount:ReportRequestInfo];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    
    [WDNotificationCenter addObserver:self selector:@selector(AlipayNotification:) name:@"AliPaySucceed" object:nil];
}

#pragma mark - 通知
- (void)AlipayNotification:(NSNotification *)notification{
    NSString *str = notification.userInfo[@"success"];
    if (![str isEqualToString:@"支付成功"]) {
//        [XAlertView alertWithTitle:@"温馨提示" message:notification.userInfo[@"success"] cancelButtonTitle:@"" confirmButtonTitle:nil viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
//
//        }];
            PaySuccessController *vc = [[PaySuccessController alloc]init];
            vc.reportType = self.reportType;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [self.tableView reloadData];
    if (self.reportType.integerValue == 1) {
        [CreditState selectOperatorCreaditState:self];
    }else{
        [CreditState selectIdentityCreaditState:self];
    }

    
   
}

#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 176;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ReportCell";
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ReportCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.detailModel = self.reportModel.yys_report;
    }else{
        cell.detailModel = self.reportModel.td_report;
    }
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    dictionary = @{@"name":@[@"运营商信用报告",@"信贷预测报告"],@"image":@[@"运营商报告卡片",@"信贷预测报告卡片"]};
    cell.report_name.text = dictionary[@"name"][indexPath.row];
    cell.card_view.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dictionary[@"image"][indexPath.row]]];
    [cell.pay_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.pay_button.tag = indexPath.row;
    [cell.report_example addTarget:self action:@selector(exampleclickAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.report_example.tag = indexPath.row;
    return cell;
}
-(void)clickAction:(UIButton *)button{
    if (button.tag == 0) {
        _reportDetailModel = self.reportModel.yys_report;
        self.reportType = @1;
    }else if (button.tag == 1){
        _reportDetailModel = self.reportModel.td_report;
        self.reportType = @2;
    }
    
    if (_reportDetailModel.buy_report_status.integerValue == 0) {
        self.payView = [[PayView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, AdaptationWidth(210)) andNSString:@"选择支付方式"];
        self.payView.delegate = self;
        [self.payView.online setTitle:[NSString stringWithFormat:@"确定支付 ￥%.2f",(_reportDetailModel.report_price.floatValue/100)] forState:UIControlStateNormal];
        [[[UIApplication sharedApplication] keyWindow] addSubview:_payView];
        [self showPayView];
    }else{
       
        switch (_reportDetailModel.get_report_status.integerValue) {
            case 1:{ // 查看报告
                if (self.reportType.integerValue == 1) {
                    [TalkingData trackEvent:@"【查看报告-运营商报告】页"];
                }else{
                    [TalkingData trackEvent:@"【查看报告-信贷预测报告】页"];
                }
                XRootWebVC *vc = [[XRootWebVC alloc]init];
                vc.url = _reportDetailModel.report_url;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{ // 免费重查
                if (self.reportType.integerValue == 1) {
                    [CreditState selectOperatorCreaditState:self];
                }else{
                    [CreditState selectIdentityCreaditState:self];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
}
-(void)exampleclickAction:(UIButton *)button{
    switch (button.tag) {
        case 0:{
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = self.reportModel.yys_report.report_example_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = self.reportModel.td_report.report_example_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak ReportController *weakSelf = self;
    self.payView.backgroundColor = XColorWithRBBA(0, 0, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = XColorWithRBBA(0, 0, 1, 0.6);

    }];
}

#pragma mark - 一一一一一 <* PayViewDelegate *> 一一一一一
- (void)PayViewOnlinePay:(UIButton *)button {
    
    if (self.payView.walltBtn.selected == NO) {
        [self setHudWithName:@"请选择正确的支付方式" Time:1.5 andType:3];
    }else{
        [self prepareDataWithCount:ReportRequestPayInfo];
       
        

    }
    
}

#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    PaySuccessController *vc = [[PaySuccessController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case ReportRequestInfo:
            self.cmd = XGetCreditReportInfo;
            self.dict =@{};
            break;
        case ReportRequestUpload:
//            self.cmd = XGetCreditReportInfo;
//            self.dict =@{};
            break;
        case ReportRequestPay:{
            self.cmd = XPayCreditReportOrder;
            NSString *time =[NSString stringWithFormat:@"%lld",[DateHelper getTimeStamp]] ;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        self.reportDetailModel.report_price,@"recharge_amount",
                         @2,@"pay_channel",
                         @1,@"pay_channel_type",
                         time,@"client_time_millseconds",
                         self.reportOrderModel.report_order_id,@"report_order_id", nil];
        }
            break;
        case ReportRequestPayInfo:{
            self.cmd = XRechargeCreditReport;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                         self.reportModel.td_report.report_price,@"total_amount",
                         self.reportType,@"report_type",
                         nil];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ReportRequestInfo:{
            self.reportModel = [ReportModel mj_objectWithKeyValues:response.content];
            [self.tableView reloadData];
        }
            break;
        case ReportRequestUpload:{

        }
            break;
        case ReportRequestPay:{
            
            //调起支付宝
            [[AlipaySDK defaultService] payOrder:response.content[@"order_string"] fromScheme:@"quanwangdai" callback:^(NSDictionary *resultDic) {
                MyLog(@"========%@",resultDic);
            }];
        }
            break;
        case ReportRequestPayInfo:{
            self.reportOrderModel.report_order_id = response.content[@"report_order_id"];
            [self prepareDataWithCount:ReportRequestPay];
        }
            break;
        default:
            break;
            
    }
}
-(ReportModel *)reportModel{
    if (!_reportModel) {
        _reportModel = [[ReportModel alloc]init];
    }
    return _reportModel;
}
-(ReportDetailModel *)reportDetailModel{
    if (!_reportDetailModel) {
        _reportDetailModel = [[ReportDetailModel alloc]init];
    }
    return _reportDetailModel;
}
-(ReportOrderModel *)reportOrderModel{
    if (!_reportOrderModel) {
        _reportOrderModel = [[ReportOrderModel alloc]init];
    }
    return _reportOrderModel;
}
-(void)dealloc{
    [WDNotificationCenter removeObserver:self];
}
@end

