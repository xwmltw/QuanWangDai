//
//  ApplicantManVC.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ApplicantManVC.h"
#import "ApplicantCell.h"
#import "AuthorizationView.h"
#import "XChooseBankView.h"
#import "ApplicantModel.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSUInteger, ApplicantManVCRequest) {
    ApplicantManVCPost,
    ApplicantManVCGet,
};
@interface ApplicantManVC ()<XChooseBankPickerViewDelegate>
{
    NSArray *dataArry;
    XChooseBankView *pickerView;
    NSInteger pickerRow;
}
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) ApplicantModel *applicantModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation ApplicantManVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:ApplicantManVCGet];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    self.tableView.tableHeaderView = [self creatHeadView];
    self.tableView.tableFooterView = [self creatFooterView];
    
    self.dataDic = @{@"title":@[@"借款用途",@"职业身份",@"本地公积金",@"本地社保",@"名下房产",@"亲属名下房产 (直系亲属、配偶)",@"名下车辆",@"信用状况"]};
//    ,@"subtitle":@[@"选择您的借款用途",@"选择您的职业身份",@"有无本地公积金",@"有无本地社保",@"名下有无房产",@"亲属名下有无房产",@"名下有无车辆",@"选择您的信用情况"]
    
    dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                 @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                 @[@"有",@"无"],
                 @[@"有",@"无"],
                 @[@"有",@"无"],
                 @[@"有",@"无"],
                 @[@"有",@"无"],
                 @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"]];
}
- (UIView *)creatHeadView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(100))];
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setText:@"申请人资质"];
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:titleLab];
    
    UILabel *subtitleLab = [[UILabel alloc]init];
    subtitleLab.numberOfLines = 0;
    [subtitleLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [subtitleLab setText:@"信息越真实，贷款通过率越高！"];
    [subtitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:subtitleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(16));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
    }];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
    }];
    return view;
}
- (UIView *)creatFooterView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(132))];
    
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.authView];
    if (self.creditInfoModel.applicant_qualification_status.integerValue == 1) {//判断是否认证过
        self.authView.hidden = YES;
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(80));
    }
    
    UIButton *sureBtn  = [[UIButton alloc]init];
    sureBtn.tag = 100;
    [sureBtn setCornerValue:5];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [sureBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [sureBtn addTarget:self action:@selector(SubmmitClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(sureBtn.mas_top);
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    return view;
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *countArr = self.dataDic[@"title"];
    return countArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ApplicantCellCell";
    ApplicantCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[ApplicantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLab.text = self.dataDic[@"title"][indexPath.row];
    cell.detailLab.text = self.dataDic[@"subtitle"][indexPath.row];
    [cell setDataModel:self.applicantModel with:indexPath.row];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    [self selectOnClick:indexPath.row];
}

- (void)selectOnClick:(NSInteger)tag{
    pickerRow = tag;
    pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    pickerView.delegate = self;
    pickerView.chooseThings = dataArry[tag];
    [pickerView showView];
}

#pragma mark - 一一一一一 <* XChooseBankPickerViewDelegate *> 一一一一一 
- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row{
    BOOL yes = [self.applicantModel.professional_identity.description isEqualToString:@"1"];
    switch (pickerRow) {
        case 0:{
            self.applicantModel.loan_usage = dataArry[pickerRow][row];
        }
            break;
        case 1:{
            self.applicantModel.professional_identity = [NSNumber numberWithInteger:row + 1];
            
            if (pickerRow == 1) {
                [self showWorkView:row];
                [self.tableView reloadData];
            }
        }
             break;
        case 2:{
            if (yes){
                self.applicantModel.payroll_type = [NSNumber numberWithInteger:row+1];
            }else{
                self.applicantModel.has_accumulation_fund = [NSNumber numberWithInteger:row];
            }
        }
            break;
        case 3:{
            if (yes){
                self.applicantModel.working_years = [NSNumber numberWithInteger:row+1];
            }else{
                self.applicantModel.has_social_security = [NSNumber numberWithInteger:row];
            }
           
        }
            break;
        case 4:{
            if (yes) {
                self.applicantModel.has_accumulation_fund = [NSNumber numberWithInteger:row];
            }else{
                self.applicantModel.has_house_property = [NSNumber numberWithInteger:row];
            }
            
        }
            break;
        case 5:{
            if (yes) {
                self.applicantModel.has_social_security = [NSNumber numberWithInteger:row];
            }else{
                self.applicantModel.relatives_has_house_property = [NSNumber numberWithInteger:row];
            }
           
        }
            break;
        case 6:{
            if (yes) {
                self.applicantModel.has_house_property = [NSNumber numberWithInteger:row];
            }else{
                self.applicantModel.has_car_property = [NSNumber numberWithInteger:row];
            }
           
        }
            break;
        case 7:{
            if (yes) {
                self.applicantModel.relatives_has_house_property = [NSNumber numberWithInteger:row];
            }else{
                self.applicantModel.credit_info = [NSNumber numberWithInteger:row+1];
            }
           
        }
            break;
        case 8:{
            if (yes) {
                self.applicantModel.has_car_property = [NSNumber numberWithInteger:row];
            }else{
                
            }
        }
            break;
        case 9:{
            if (yes) {
                self.applicantModel.credit_info = [NSNumber numberWithInteger:row+1];
            }else{
                
            }
            
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}
-(void)showWorkView:(NSInteger)row{
    if (row == 0) {
        self.dataDic = @{@"title":@[@"借款用途",@"职业身份",@"工资发放形式",@"当前单位工龄",
                                    @"本地公积金",@"本地社保",@"名下房产",@"亲属名下房产 (直系亲属、配偶)",
                                    @"名下车辆",@"信用状况"]};
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"银行卡发放",@"现金发放",@"部分银行卡,部分现金"],
                     @[@"不足3个月",@"3-5个月",@"6-11个月",@"1-3年",@"4-7年",@"7年以上"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"]];
    }else{
        self.dataDic = @{@"title":@[@"借款用途",@"职业身份",@"本地公积金",@"本地社保",
                                    @"名下房产",@"亲属名下房产 (直系亲属、配偶)",@"名下车辆",@"信用状况"]};
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"有",@"无"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"]];
    }
    
}

#pragma mark - 一一一一一 <* 按钮点击事件 *> 一一一一一
-(void)SubmmitClick{
    MyLog(@"%d",self.authView.AgreementBtn.selected);
    if (!self.authView.AgreementBtn.selected && self.creditInfoModel.applicant_qualification_status.integerValue == 0) {
        [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
        }];
        return;
    }
    [self prepareDataWithCount:ApplicantManVCPost];
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
//            NSLog(@"按钮");
            break;
            
        default:
            break;
    }
}
#pragma mark - 一一一一一 <* 网络请求 *> 一一一一一
-(void)setRequestParams
{
    if (self.requestCount == ApplicantManVCGet) {
        self.cmd = XGetLoanQualificationInfo;
        self.dict = @{};
        
    }else if (self.requestCount == ApplicantManVCPost) {
        self.cmd = XPostLoanQualificationInfo;
        self.dict = [self.applicantModel mj_keyValues];
    }
}

- (void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.requestCount == ApplicantManVCGet) {
        self.applicantModel = [ApplicantModel mj_objectWithKeyValues:response.content];
    }else if (self.requestCount == ApplicantManVCPost) {
        [self setHudWithName:@"提交成功" Time:1 andType:0];
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
    }
    [self.tableView reloadData];
}
-(void)requestFaildWithDictionary:(XResponse *)response{
    [self setHudWithName:@"请填写完整信息" Time:2 andType:1];
}

-(ApplicantModel *)applicantModel{
    if (!_applicantModel) {
        _applicantModel = [[ApplicantModel alloc]init];
    }
    return _applicantModel;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
@end
