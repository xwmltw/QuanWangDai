//
//  ResultApplicationVC.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/18.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ResultApplicationVC.h"
#import "RecommendTableViewCell.h"
#import "AllDKViewController.h"
#import "ProductDetailVC.h"
#import "PersonalTailorVC.h"
#import "ProductModel.h"
#import "XRootWebVC.h"


@interface ResultApplicationVC ()
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic ,strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@end

@implementation ResultApplicationVC
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"申请结果-一键申请"];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [self prepareDataWithCount:0];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self creatHeader];
    
    
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    [btnContinue setTitle:@"去办信用卡" forState:UIControlStateNormal];
    [btnContinue setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContinue];
    
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
-(void)timerAction{
    __weak ResultApplicationVC *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.imageView.frame = CGRectMake(AdaptationWidth(9), -AdaptationWidth(74),AdaptationWidth(166), AdaptationWidth(97));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakself.imageView.frame = CGRectMake(AdaptationWidth(9), -AdaptationWidth(64),AdaptationWidth(166), AdaptationWidth(97));
        }];
    }];
    
}
#pragma mark - tableviewdelegate
- (UIView *)creatHeader{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(331));
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"notData"]];
    [view addSubview:image];
    
    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:@"申请结果"];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    NSMutableArray *mutArray = [NSMutableArray array];
    
    [self.resultCuntArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *middleStr = [NSString stringWithFormat:@"\"%@\"",obj[@"loan_pro_name"]];
        [mutArray addObject:middleStr];
    }];
    
    
    NSString *resultStr = [mutArray componentsJoinedByString:@"、"];
    NSString *labelText =[NSString stringWithFormat:@"%@ %d款产品申请成功",resultStr,mutArray.count];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.0];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    labDetail.attributedText = attributedString;
    [labDetail sizeToFit];
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
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataSourceArr.count > 3) {
        return 3;
    }
    return self.dataSourceArr.count;
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
    cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    //是否名额已满
    NSInteger row = [self.dataSourceArr[indexPath.row][@"apply_is_full"]integerValue];
    if (row == 1) {
        [self setHudWithName:@"名额已满" Time:0.5 andType:3];
        return;
    }
    
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (btn.tag == 100) {
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = self.clientGlobalInfoRM.wap_url_list.credit_url;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (btn.tag == 101) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma  mark - request
- (void)setRequestParams{
    self.cmd = XGetRecommendLoanProList;
    self.dict = [self.query_param mj_keyValues];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = response.content[@"loan_pro_list"];
    [self.dataSourceArr removeAllObjects];
    [self.tableView reloadData];
}
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:0];
}


@end

