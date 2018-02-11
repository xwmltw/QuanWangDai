//
//  WorkInfoVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/29.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "WorkInfoVC.h"
#import "WorkInfoTableViewCell.h"
#import "XChooseCityView.h"
#import "WorkInfoModel.h"
#import "AuthorizationView.h"
#import "XRootWebVC.h"

typedef NS_ENUM(NSInteger ,WorkInfoRequest) {
    WorkInfoRequestGetInfo,
    WorkInfoRequestPostInfo,
};
@interface WorkInfoVC ()<XChooseCityViewDelegate>
@property (nonatomic ,strong) WorkInfoModel *workInfoModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation WorkInfoVC
{
    XChooseCityView *cityView;
    NSIndexPath *cityIndexPath;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareDataWithCount:WorkInfoRequestGetInfo];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.tableHeaderView = [self HeaderView];
    self.tableView.tableFooterView = [self FooderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    [self.tableView registerClass:[WorkInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WorkInfoTableViewCell class])];
    
    
}
- (UIView *)HeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(70))];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]init];
    [title setText:@"工作信息认证"];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:30]];
    [title setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(view).offset(AdaptationWidth(16));
    }];
    return view;
}
- (UIView *)FooderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(132))];
    view.backgroundColor = [UIColor whiteColor];
    
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.authView];
    if (self.creditInfoModel.company_status.integerValue == 1 || self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 1) {//判断是否认证过
        self.authView.hidden = YES;
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(80));
    }
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setCornerValue:5];
    [btn addTarget:self  action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(btn.mas_top);
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(90);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WorkInfoTableViewCell class])];
    if (!cell) {
        cell = [[WorkInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WorkInfoTableViewCell class])];
    }
    [cell setCellWith:self.workInfoModel indexPath:indexPath.row];
    WEAKSELF
    cell.block = ^(NSString * text) {
        if (text.length) {
            switch (indexPath.row) {
                case 0:
                    weakSelf.workInfoModel.company_name = text;
                    break;
                case 2:
                    weakSelf.workInfoModel.company_address = text;
                    break;
                case 3:
                    weakSelf.workInfoModel.company_phone = text;
                    break;
                case 4:
                    weakSelf.workInfoModel.job_name = text;
                    break;
                case 5:
                    weakSelf.workInfoModel.job_salary = text;
                    break;
                case 6:
                    weakSelf.workInfoModel.job_pay_salary_day = text;
   
                    break;
                    
           
                    
                default:
                    break;
            }
            
        }
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 1) {
        cityIndexPath = indexPath;
        cityView = [[XChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        cityView.delegate = self;
        [cityView showView];
    }
}
#pragma  mark - delegate
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(XChooseCityView *)chooseView{
//    self.workInfoModel.c
    self.workInfoModel.company_province = province;
    self.workInfoModel.company_city = city;
    if (town.length != 0) {
        self.workInfoModel.company_town = town;
    }
    [self.tableView reloadData];
    
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (self.workInfoModel.company_name.length == 0 || self.workInfoModel.company_name.length >32) {
        [self setHudWithName:@"请填写正确的公司名称(不大于32个字)" Time:2 andType:1];
        return;
    }
    if (self.workInfoModel.job_name.length >  32) {
        [self setHudWithName:@"请填写正确的工作岗位(不大于32个字)" Time:2 andType:1];
        return;
    }
    if (self.workInfoModel.company_city.length == 0) {
        [self setHudWithName:@"请填写工作城市" Time:0.5 andType:1];
        return;
    }
    if (self.workInfoModel.company_address.length <= 6 ) {
        [self setHudWithName:@"请填写公司地址(地址填写应不少于6个字)" Time:2 andType:1];
        return;
    }
    if (self.workInfoModel.company_phone.length > 11) {
        [self setHudWithName:@"请填写正确的公司电话" Time:1 andType:1];
        return;
    }

    if (([self.workInfoModel.job_salary integerValue] < 0) || !([self.workInfoModel.job_salary rangeOfString:@"."].location == NSNotFound) ) {
        [self setHudWithName:@"请填写正确的工资收入" Time:1 andType:3];
        return;
    }
    
    if ([self.workInfoModel.job_pay_salary_day integerValue] > 31 || [self.workInfoModel.job_pay_salary_day integerValue] <= 0 || !([self.workInfoModel.job_pay_salary_day rangeOfString:@"."].location == NSNotFound) ) {
        [self setHudWithName:@"请填写正确的发薪日期" Time:1 andType:3];
        return;
    }
    if (!self.authView.AgreementBtn.selected && self.creditInfoModel.company_status.integerValue == 0) {
        [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {}];
        return;
    }
    [self prepareDataWithCount:WorkInfoRequestPostInfo];
}

-(void)buttonClick:(UIButton*)button{
    switch (button.tag) {
        case AuthorizationBtnOnClickAgreement:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.clientGlobalInfoModel.wap_url_list.collect_info_grant_authorization_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case AuthorizationBtnOnClickTick:
            button.selected = !button.selected;
            self.authView.AgreementBtn.selected = button.selected;
            break;
            
        default:
            break;
    }
}
#pragma  mark - request
- (void)setRequestParams{
    switch (self.requestCount) {
        case WorkInfoRequestGetInfo:
            self.cmd = XGetWorkInfo;
            self.dict = @{};
            break;
        case WorkInfoRequestPostInfo:
            self.cmd = XPostWorkInfo;
            self.dict = [self.workInfoModel mj_keyValues];
            break;
            
        default:
            break;
    }
}
-(void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case WorkInfoRequestGetInfo:
            self.workInfoModel = [WorkInfoModel mj_objectWithKeyValues:response.content];
            [self.tableView reloadData];
            break;
        case WorkInfoRequestPostInfo:
        {
            [self setHudWithName:@"提交成功" Time:0.5 andType:0];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil]; 
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (WorkInfoModel*)workInfoModel{
    if (!_workInfoModel) {
        _workInfoModel =[[WorkInfoModel alloc]init];
    }
    return _workInfoModel;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
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
