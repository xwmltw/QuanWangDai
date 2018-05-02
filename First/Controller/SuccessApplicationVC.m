//
//  SuccessApplicationVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "SuccessApplicationVC.h"
#import "AllDKViewController.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "PersonalTailorVC.h"
#import "XRootWebVC.h"


@interface SuccessApplicationVC ()
{
    NSString *copyStr;
}
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@property (nonatomic ,strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@end

@implementation SuccessApplicationVC
- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"申请成功页面"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self prepareDataWithCount:0];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}
-(void)createBottomBTN{
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    if (self.dataSourceArr.count != 0) {
        [btnContinue setTitle:@"继续申请" forState:UIControlStateNormal];
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
-(void)timerAction{
    __weak SuccessApplicationVC *weakself = self;
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
    if (self.dataSourceArr.count == 0) {
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(331));
        UIImageView *image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:@"notData"]];
        [view addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view).offset(AdaptationWidth(154));
            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
            make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
            make.height.mas_equalTo(AdaptationWidth(161));
        }];
    }else{
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(162));
    }
    

    UILabel *labTitle = [[UILabel alloc]init];
    [labTitle setText:@"恭喜, 申请成功！"];
    [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [labTitle setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:labTitle];
    
    UILabel *labDetail = [[UILabel alloc]init];
    if (self.applyProductModel.contact_wechat_public.length > 0) {
        NSString *labelText = @"请保持手机通畅，稍后会有工作人员与您联系；您可以关注对方的公众号，办理效率更高";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        labDetail.attributedText = attributedString;
        [labDetail sizeToFit];
        labDetail.numberOfLines = 2;
    }else if (self.applyProductModel.contact_qq.length > 0) {
        NSString *labelText = @"请保持手机通畅，稍后会有工作人员与您联系；您也可以主动添加对方QQ进行联系。";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4.0];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        labDetail.attributedText = attributedString;
        [labDetail sizeToFit];
        labDetail.numberOfLines = 2;
    }else{
        NSString *labelText = @"请保持手机通畅，稍后会有工作人员与您联系。";
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
    [labDetail setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
    [view addSubview:labDetail];
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(32));
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
    }];
    
    [labDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(12));
        make.top.mas_equalTo(labTitle.mas_bottom).offset(AdaptationWidth(4));
    }];
    
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ((self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) && self.dataSourceArr.count != 0){
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length){
           return AdaptationWidth(68);
        }
    }
    if (self.dataSourceArr.count == 0) {
        return 0.1;
    }
    return AdaptationWidth(60);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    
    if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) {
        if (section == 0) {
            UILabel *labTitle = [[UILabel alloc]init];
            if (self.applyProductModel.contact_wechat_public.length) {
                [labTitle setText:[NSString stringWithFormat:@"微信公众号：%@",self.applyProductModel.contact_wechat_public]];
                copyStr = self.applyProductModel.contact_wechat_public;
            }else{
                [labTitle setText:[NSString stringWithFormat:@"QQ：%@",self.applyProductModel.contact_qq]];
                copyStr = self.applyProductModel.contact_qq;
            }
            
            [labTitle setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
            [labTitle setTextColor:XColorWithRBBA(252, 93, 109, 1)];
            [view addSubview:labTitle];
            
            [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
                make.centerY.mas_equalTo(view);
            }];
            
            UIButton *btnCopy = [[UIButton alloc]init];
            btnCopy.tag = 102;
            [btnCopy.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
            [btnCopy setTitle:@"复制" forState:UIControlStateNormal];
            [btnCopy setBackgroundColor:XColorWithRGB(252, 93, 109)];
            btnCopy.layer.masksToBounds = YES;
            [btnCopy setCornerValue:2];
            [btnCopy setTitleColor:XColorWithRGB(255, 255, 255) forState:UIControlStateNormal];
            [btnCopy setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
            [btnCopy addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btnCopy];
            
            [btnCopy mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
                make.width.mas_equalTo(58);
                make.centerY.mas_equalTo(view);
            }];
            
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = XColorWithRGB(233, 233, 235);
            [view addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(view);
                make.height.mas_equalTo(0.5);
            }];
            return view;
        }
    }

    if (self.dataSourceArr.count != 0) {
        
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
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.applyProductModel.contact_qq.length || self.applyProductModel.contact_wechat_public.length) {
        if (section < 1) {
            return 0;
        }
    }
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
        if (self.dataSourceArr.count > 3) {
            PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
            vc.isAllProduct = @1;
            [self.navigationController pushViewController:vc animated:YES];
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
    if (btn.tag == 102) {
        [self setHudWithName:@"复制成功" Time:1 andType:0];
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = copyStr;
    }
}
#pragma  mark - request
- (void)setRequestParams{
    self.cmd = XGetRecommendLoanProList;
    self.dict =@{@"query_param":@{@"page_size":@(30),
                                  @"page_num":@(1)
                                },
                                @"cooperation_type":@(1)
                                };
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = response.content[@"loan_pro_list"];
    if (![CreditState creditStateWith:self.creditInfoModel]) {
        [self.dataSourceArr removeAllObjects];
    }
    self.tableView.tableHeaderView = [self creatHeader];
    [self createBottomBTN];
    [self.tableView reloadData];
}
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:0];
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
