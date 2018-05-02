//
//  FailApplicantionController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/17.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "FailApplicantionController.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "ResultApplicationVC.h"
#import "XRootWebVC.h"


typedef NS_ENUM(NSInteger ,FailApplicantionRequest) {
    FailApplicantionRequestSpecial,
    FailApplicantionRequestBatch,
};

@interface FailApplicantionController ()<RecommendTableViewCellDelegate>
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *cuntArr;
@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end

@implementation FailApplicantionController
- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"申请失败页面"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [self prepareDataWithCount:FailApplicantionRequestSpecial];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
   
    
}
-(void)timerAction{
    __weak FailApplicantionController *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.imageView.frame = CGRectMake(AdaptationWidth(9), -AdaptationWidth(74),AdaptationWidth(166), AdaptationWidth(97));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakself.imageView.frame = CGRectMake(AdaptationWidth(9), -AdaptationWidth(64),AdaptationWidth(166), AdaptationWidth(97));
        }];
    }];
    
}
- (void)creatBottomView{
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    if (self.modelArray.count) {
        [btnContinue setTitle:@"一键申请" forState:UIControlStateNormal];
    }else{
        [btnContinue setTitle:@"去办信用卡" forState:UIControlStateNormal];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(9), -AdaptationWidth(64), AdaptationWidth(166), AdaptationWidth(97))];
        _imageView.image = [UIImage imageNamed:@"toast_bg"];
        [btnContinue addSubview:_imageView];
        
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)];
        label.textColor = XColorWithRBBA(34, 58, 80, 0.48);
        label.text = @"试试申请信用卡提升您的授信额度";
        [_imageView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imageView).offset(AdaptationWidth(20));
            make.left.mas_equalTo(_imageView).offset(AdaptationWidth(25));
            make.right.mas_equalTo(_imageView).offset(-AdaptationWidth(25));
        }];
    }
    [btnContinue setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContinue];
    
    UIButton *btnBack = [[UIButton alloc]init];
    btnBack.tag = 101;
    [btnBack setTitle:@"返回首页" forState:UIControlStateNormal];
    [btnBack setBackgroundColor:XColorWithRGB(255, 255, 255)];
    [btnBack setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [btnBack  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    [btnContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
}
#pragma mark - tableviewdelegate
- (UIView *)creatHeader{
    
    UIView *view = [[UIView alloc]init];
    if (self.modelArray.count) {
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(128));
    }else{
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(331));
    }
    
    UIImageView *image = [[UIImageView alloc]init];
    if (self.modelArray.count == 0) {
        [image setImage:[UIImage imageNamed:@"dataDetail_low"]];
    }
    [view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:@"申请失败"];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    if (self.errCode.integerValue == 33) {
        [TalkingData trackEvent:@"申请失败-资质不符"];
        NSString *labelText = @"您当前资质无法申请该产品";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        labDetail.attributedText = attributedString;
        [labDetail sizeToFit];
        labDetail.numberOfLines = 2;
    }else{
        [TalkingData trackEvent:@"申请失败-30天重复申请"];
        NSString *labelText = @"您在30天内申请过该产品";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        labDetail.attributedText = attributedString;
        [labDetail sizeToFit];
        labDetail.numberOfLines = 2;
    }
    labDetail.numberOfLines = 2;
    [labDetail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labDetail];
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(32));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
    }];
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(4));
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labDetail.mas_bottom).offset(AdaptationWidth(32));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.modelArray.count == 0) {
        return 0.1;
    }
    return AdaptationWidth(60);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.modelArray.count) {
        UIView *view = [[UIView alloc]init];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = XColorWithRGB(233, 233, 235);
        [view addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *labTitle = [[UILabel alloc]init];
        [labTitle setText:@"和您资质相近的产品"];
        [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
        [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        [view addSubview:labTitle];
        
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(AdaptationWidth(16));
            make.bottom.mas_equalTo(view);
        }];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.modelArray.count > 3) {
        return 3;
    }
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecommendCell";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:nil options:nil].lastObject;
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    cell.isSuccessApp = @(1);
    cell.delegate = self;
    cell.selected_btn.tag = indexPath.row;
    cell.model =[ProductModel mj_objectWithKeyValues:self.modelArray[indexPath.row]] ;
    return cell;
}

#pragma mark - 一一一一一 <* RecommendTableViewCellDelegate *> 一一一一一
- (void)isSelectedOrNot:(UIButton *)button{
    button.selected = !button.selected;
    
    self.productModel = self.modelArray[button.tag];
    _productModel.itemIsSelected = button.selected;
    if (_productModel.itemIsSelected == YES) {
        [self.cuntArr addObject:_productModel.loan_pro_id];
    }else{
        for(NSString *model in self.cuntArr){
            if([model isEqualToString:_productModel.loan_pro_id]){
                [self.cuntArr removeObject:model];
                break;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    //是否名额已满
//    NSInteger row = [self.modelArray[indexPath.row][@"apply_is_full"]integerValue];
//    if (row == 1) {
//        [self setHudWithName:@"名额已满" Time:0.5 andType:3];
//        return;
//    }
    
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    ProductModel *model = self.modelArray[indexPath.row];
    vc.loan_pro_id = model.loan_pro_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        if (self.cuntArr.count == 0 && self.modelArray.count > 0) {
            [self setHudWithName:@"请选择您需要申请的产品" Time:1 andType:3];
            return;
        }
        if ([btn.titleLabel.text isEqualToString:@"一键申请"]) {
            [self prepareDataWithCount:FailApplicantionRequestBatch];
        }else{
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = self.clientGlobalInfoRM.wap_url_list.credit_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (btn.tag == 101) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma  mark - request
- (void)setRequestParams{
    switch (self.requestCount) {
        case FailApplicantionRequestSpecial:
            self.cmd = XGetRecommendLoanProList;
            self.dict =@{@"query_param":@{@"page_size":@(30),
                                          @"page_num":@(1)
                                          },
                        @"cooperation_type":@(3)
                                            };
            break;
        case FailApplicantionRequestBatch:{
            self.cmd = XBatchApplyLoan;
            
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.cuntArr,@"loan_pro_list_id", nil];
        }
            break;
            
        default:
            break;
    }
   
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case FailApplicantionRequestSpecial:{
            self.dataSourceArr = response.content[@"loan_pro_list"];
            if (self.dataSourceArr.count && [CreditState creditStateWith:self.creditInfoModel]) {
                [self.dataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    self.productModel = [ProductModel mj_objectWithKeyValues:obj];
                    [self.modelArray addObject:self.productModel];
                    
                }];
                if (self.modelArray.count) {
                    NSInteger row = self.modelArray.count > 3 ? 3 : self.modelArray.count;
                    for (int i = 0 ; i< row ;i++) {
                        self.productModel =self.modelArray[i];
                        _productModel.itemIsSelected = YES;
                        if (_productModel.itemIsSelected == YES ) {
                            [self.cuntArr addObject:_productModel.loan_pro_id];
                        }
                    }
                }
                
                
            }
            [self creatBottomView];
            self.tableView.tableHeaderView = [self creatHeader];
            [self.tableView reloadData];
        }
            break;
        case FailApplicantionRequestBatch:{
            ResultApplicationVC *vc = [[ResultApplicationVC alloc]init];
            vc.resultCuntArr = response.content[@"apply_loan_result"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray  = [NSMutableArray array];
    }
    return _modelArray;
}
-(NSMutableArray *)cuntArr{
    if (!_cuntArr) {
        _cuntArr = [NSMutableArray array];
    }
    return _cuntArr;
}
- (ProductModel *)productModel{
    if (!_productModel) {
        _productModel = [[ProductModel alloc]init];
    }
    return _productModel;
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:0];
}


@end
