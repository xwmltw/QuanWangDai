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
#import "PersonalTailorVC.h"

typedef NS_ENUM(NSUInteger, ApplicantManVCRequest) {
    ApplicantManVCPost,
    ApplicantManVCGet,
    ApplicantManVCLoanProList,
    HalfWithAllProduct,
    CreditRequestDetailInfo
};
@interface ApplicantManVC ()<XChooseBankPickerViewDelegate>
{
    NSArray *dataArry;
    XChooseBankView *pickerView;
    NSInteger pickerRow;
    
}
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *otherdataDic;
@property (nonatomic, strong) ApplicantModel *applicantModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@property (nonatomic ,copy) NSNumber *isAllProduct;//1全流程 2流程
@end

@implementation ApplicantManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【申请人资质】页"];
    [self prepareDataWithCount:ApplicantManVCGet];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = nil;
    self.tableView.tableHeaderView = [self creatHeadView];
    self.tableView.tableFooterView = [self creatFooterView];
    
    self.dataDic = @{@"title":@[@"借款用途",@"职业身份",@"本地公积金",@"本地社保"
                                ,@"名下房产",@"亲属名下房产 (直系亲属、配偶)",@"名下车辆",@"信用状况",@"保单",@"学历"]};
    self.otherdataDic = @{@"title":@[@"借款用途",@"职业身份",@"工资发放形式",@"当前单位工龄",
                                     @"本地公积金",@"本地社保",@"名下房产",@"亲属名下房产 (直系亲属、配偶)",
                                     @"名下车辆",@"信用状况",@"保单",@"学历"]};
    
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
    if (self.creditInfoModel.applicant_qualification_status.integerValue == 1 || self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 1) {//判断是否认证过
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
    BOOL yes = [self.applicantModel.professional_identity.description isEqualToString:@"1"];
    if (yes) {
        NSArray *countArr = self.otherdataDic[@"title"];
        return countArr.count;
    } else {
        NSArray *countArr = self.dataDic[@"title"];
        return countArr.count;
    }
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
    BOOL yes = [self.applicantModel.professional_identity.description isEqualToString:@"1"];
    if (yes) {
        cell.titleLab.text = self.otherdataDic[@"title"][indexPath.row];
    }else{
        cell.titleLab.text = self.dataDic[@"title"][indexPath.row];
    }
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
            // 借款用途
            self.applicantModel.loan_usage = dataArry[pickerRow][row];
        }
            break;
        case 1:{
            // 职业身份
            self.applicantModel.professional_identity = [NSNumber numberWithInteger:row + 1];
            
            if (pickerRow == 1) {
                [self showWorkView:row];
                [self.tableView reloadData];
            }
        }
             break;
        case 2:{
            if (yes){
                // 工资发放形式
                self.applicantModel.payroll_type = [NSNumber numberWithInteger:row+1];
            }else{
                // 公积金
                self.applicantModel.has_accumulation_fund = [NSNumber numberWithInteger:row];
            }
        }
            break;
        case 3:{
            if (yes){
                // 工作时间
                self.applicantModel.working_years = [NSNumber numberWithInteger:row+1];
            }else{
                // 社保
                self.applicantModel.has_social_security = [NSNumber numberWithInteger:row];
            }
           
        }
            break;
        case 4:{
            if (yes) {
                // 公积金
                self.applicantModel.has_accumulation_fund = [NSNumber numberWithInteger:row];
            }else{
                // 名下房产
                self.applicantModel.has_house_property = [NSNumber numberWithInteger:row];
            }
            
        }
            break;
        case 5:{
            if (yes) {
                // 社保
                self.applicantModel.has_social_security = [NSNumber numberWithInteger:row];
            }else{
                // 亲属名下房产
                self.applicantModel.relatives_has_house_property = [NSNumber numberWithInteger:row];
            }
        }
            break;
        case 6:{
            if (yes) {
                // 名下房产
                self.applicantModel.has_house_property = [NSNumber numberWithInteger:row];
            }else{
                // 名下车辆
                self.applicantModel.has_car_property = [NSNumber numberWithInteger:row];
            }
           
        }
            break;
        case 7:{
            if (yes) {
                // 亲属名下房产
                self.applicantModel.relatives_has_house_property = [NSNumber numberWithInteger:row];
            }else{
                // 信用状况
                self.applicantModel.credit_info = [NSNumber numberWithInteger:row+1];
            }
           
        }
            break;
        case 8:{
            if (yes) {
                // 名下车辆
                self.applicantModel.has_car_property = [NSNumber numberWithInteger:row];
            }else{
                // 保单
                self.applicantModel.has_policy = [NSNumber numberWithInteger:row];
            }
        }
            break;
        case 9:{
            if (yes) {
                // 信用状况
                self.applicantModel.credit_info = [NSNumber numberWithInteger:row+1];
            }else{
                // 学历
                self.applicantModel.education_type = [NSNumber numberWithInteger:row];
            }
            
        }
            break;
        case 10:{
            if (yes) {
                // 保单
                self.applicantModel.has_policy = [NSNumber numberWithInteger:row];
            }else{
                
            }
        }
            break;
        case 11:{
            if (yes) {
                // 学历
               self.applicantModel.education_type = [NSNumber numberWithInteger:row];
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
                                    @"名下车辆",@"信用状况",@"保单",@"学历"]};
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"银行卡发放",@"现金发放",@"部分银行卡,部分现金"],
                     @[@"不足3个月",@"3-5个月",@"6-11个月",@"1-3年",@"4-7年",@"7年以上"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"],
                     @[@"无",@"有"],
                     @[@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"]];
    }else{
        self.dataDic = @{@"title":@[@"借款用途",@"职业身份",@"本地公积金",@"本地社保",
                                    @"名下房产",@"亲属名下房产 (直系亲属、配偶)",@"名下车辆",@"信用状况",@"保单",@"学历"]};
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"],
                     @[@"无",@"有"],
                     @[@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"]];
    }
    
}

#pragma mark - 一一一一一 <* 按钮点击事件 *> 一一一一一
-(void)SubmmitClick{
    MyLog(@"%d",self.authView.AgreementBtn.selected);
    
    if (self.applicantModel.loan_usage.length == 0) {
        [self setHudWithName:@"请选择借款用途" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.professional_identity == nil) {
        [self setHudWithName:@"请选择职业身份" Time:0.5 andType:1];
        return;
    }
    if ([self.applicantModel.professional_identity.description isEqualToString:@"1"]) {
        if (self.applicantModel.payroll_type == nil) {
            [self setHudWithName:@"请选择工资发放形式" Time:0.5 andType:1];
            return;
        }
        if (self.applicantModel.working_years == nil) {
            [self setHudWithName:@"请选择工龄" Time:0.5 andType:1];
            return;
        }
    }
    if (self.applicantModel.has_accumulation_fund == nil) {
        [self setHudWithName:@"请选择是否拥有本地公积金" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.has_social_security == nil) {
        [self setHudWithName:@"请选择是否拥有本地社保" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.has_house_property == nil) {
        [self setHudWithName:@"请选择是否拥有房产" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.relatives_has_house_property == nil) {
        [self setHudWithName:@"请选择亲属是否拥有房产" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.has_car_property == nil) {
        [self setHudWithName:@"请选择名下是否有车" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.credit_info == nil) {
        [self setHudWithName:@"请选择信用情况" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.has_policy == nil) {
        [self setHudWithName:@"请选择是否有保单" Time:0.5 andType:1];
        return;
    }
    if (self.applicantModel.education_type == nil) {
        [self setHudWithName:@"请选择学历情况" Time:0.5 andType:1];
        return;
    }
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
        self.dict = [NSDictionary dictionary];
        
    }else if (self.requestCount == ApplicantManVCPost) {
        self.cmd = XPostLoanQualificationInfo;
        self.dict = [self.applicantModel mj_keyValues];
    }else if (self.requestCount == ApplicantManVCLoanProList){
        self.cmd = XGetRecommendLoanProList;
        self.dict =@{@"query_param":@{@"page_size":@(1),
                                      @"page_num":@(1)
                                      },
                     @"query_entry_type":@(2)
                     };
    }else if(self.requestCount == HalfWithAllProduct){
        self.cmd  = XGetSpecialLoanProList;
        self.dict =@{@"query_type":self.isAllProduct};
    }else if(self.requestCount == CreditRequestDetailInfo){
        self.cmd = XGetCreditInfo;
        self.dict = [NSDictionary dictionary];
    }
}

- (void)requestSuccessWithDictionary:(XResponse *)response{
    if (self.requestCount == ApplicantManVCGet) {
        self.applicantModel = [ApplicantModel mj_objectWithKeyValues:response.content];
        [self setupdata];
        [self.tableView reloadData];
    }else if (self.requestCount == ApplicantManVCPost) {
        [self setHudWithName:@"提交成功" Time:1 andType:0];
        if (self.isBlock.integerValue == 1) {
            
            [self prepareDataWithCount:CreditRequestDetailInfo];
            
            return;
        }
        [self prepareDataWithCount:ApplicantManVCLoanProList];
        return;
    }else if (self.requestCount == ApplicantManVCLoanProList){
        NSNumber *row = response.content[@"loan_pro_list_count"];
        if(self.comeFrom.integerValue == 1){
            if (row.integerValue > 0) {//判断是否有可推荐的产品
                PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
    }else if (self.requestCount == HalfWithAllProduct){
        
        NSNumber *row = response.content[@"loan_pro_list_count"];
        
        if(row.integerValue > 0){
            PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
            vc.isAllProduct = self.isAllProduct;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        [CreditState selectCreaditState:self with:self.creditInfoModel];
        
        
        
    }else if(self.requestCount == CreditRequestDetailInfo){
         [[CreditInfoModel sharedInstance]saveCreditStateInfo:[CreditInfoModel mj_objectWithKeyValues:response.content]];
        if ([CreditState creditStateWith:self.creditInfoModel]) {
            self.isAllProduct = @1;
        }else{
            self.isAllProduct = @2;
        }
        [self prepareDataWithCount:HalfWithAllProduct];
 
    }
    
}
-(void)requestFaildWithDictionary:(XResponse *)response{
//    [self setHudWithName:response.errMsg Time:2 andType:1];
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
}
-(void)setupdata{
    if ([self.applicantModel.professional_identity.description isEqualToString:@"1"]) {
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"银行卡发放",@"现金发放",@"部分银行卡,部分现金"],
                     @[@"不足3个月",@"3-5个月",@"6-11个月",@"1-3年",@"4-7年",@"7年以上"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"],
                     @[@"无",@"有"],
                     @[@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"]];
    } else {
        dataArry = @[@[@"网上购物",@"实体店购物",@"教育培训",@"租房买房",@"出国留学",@"婚庆装修",@"餐饮娱乐",@"医疗美容",@"其他"],
                     @[@"上班族",@"个体户",@"无固定职业",@"企业主",@"学生"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"无",@"有"],
                     @[@"1年内逾期超过3次或超过90天",@"1年内逾期少3次且少于90天",@"无信用卡或贷款",@"信用良好",@"无逾期"],
                     @[@"无",@"有"],
                     @[@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"]];
    }
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
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
