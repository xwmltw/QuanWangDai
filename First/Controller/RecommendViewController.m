//
//  RecommendViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendTableViewCell.h"
#import "AllDKViewController.h"
#import "ProductDetailVC.h"
#import "LoginVC.h"
#import "ServiceURLVC.h"
#import "ParamModel.h"
#import "ProductModel.h"
#import "SDCycleScrollView.h"
#import "XRootWebVC.h"
#import "CreditViewController.h"



typedef NS_ENUM(NSInteger , RecommendBtnOnClick){
    RecommendBtnOnClickAllDK,
    RecommendBtnOnClickXYZS,
    RecommendBtnOnClickNext,
    
};
typedef NS_ENUM(NSInteger , RecommenRequest) {
    RecommenRequestHotInfo,
    RecommenRequestClickLogRecord,
};
@interface RecommendViewController ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate>
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) WapUrlList *wapUrlLisModel;
@property (nonatomic, strong) SDCycleScrollView *sdcycleScrollView;
@property (nonatomic, assign)NSInteger index;
@end

@implementation RecommendViewController
{
    NSMutableArray *imageArry;
    NSString *ad_id;//banner点击日志
}
#pragma mark - 懒加载
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
- (ProductModel *)productModel{
    if (!_productModel) {
        _productModel = [[ProductModel alloc]init];
    }
    return _productModel;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
- (WapUrlList *)wapUrlLisModel{
    if (!_wapUrlLisModel) {
        _wapUrlLisModel = self.clientGlobalInfoModel.wap_url_list ;
    }
    return _wapUrlLisModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAndLoad) name:@"Recommend" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"【推荐】页"];
    
    [self setData];
    [self prepareDataWithCount:RecommenRequestHotInfo];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self creatHeadView];

//    self.tableView.tableFooterView = [self creatFooterView];
}
- (void)setData{
    imageArry = [NSMutableArray array];
    [self.clientGlobalInfoModel.banner_ad_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str= obj[@"img_url"];
        if(str.length)
        [imageArry addObject:str];
    }];
    

}
- (void)scrollAndLoad {
    //这个方法可直接实现回滚到顶部并且开始刷新
    [self.tableView.mj_header beginRefreshing];
}
- (UIView *)creatHeadView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(390))];
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.backgroundColor = [UIColor clearColor];
    
    _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"loadingPage-2"]];
    _sdcycleScrollView.imageURLStringsGroup = imageArry;
    if (imageArry.count == 1 ) {
        _sdcycleScrollView.autoScroll = NO;
    }
    _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;

    _sdcycleScrollView.autoScrollTimeInterval = 3;
    _sdcycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdcycleScrollView.layer.masksToBounds = YES;
    _sdcycleScrollView.layer.cornerRadius = AdaptationWidth(4);
    _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
    
    [view addSubview:_sdcycleScrollView];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = RecommendBtnOnClickAllDK;
    [btn setBackgroundImage:[UIImage imageNamed:@"alldaikuan"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"alldaikuan_selected"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc]init];
    btn2.tag = RecommendBtnOnClickXYZS;
    [btn2 setBackgroundImage:[UIImage imageNamed:@"channel"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"channel_selected"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];

    UIButton *bgView = [[UIButton alloc]init];
    bgView.tag = RecommendBtnOnClickNext;
    [bgView.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(15)]];
    [bgView setTitle:@"十次申请九次不过？那是你少做了一步 →" forState:UIControlStateNormal];
    [bgView setTitleColor:XColorWithRGB(7, 137, 133) forState:UIControlStateNormal];
    bgView.backgroundColor = XColorWithRBBA(7, 137, 133, 0.08);
    bgView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bgView.titleEdgeInsets = UIEdgeInsetsMake(0,16,0,0);
    [bgView setCornerValue:AdaptationWidth(4)];
    [bgView addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bgView];
    

    [_sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(30));
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
//        make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.width.mas_equalTo(AdaptationWidth(343));
        make.height.mas_equalTo(AdaptationWidth(186));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sdcycleScrollView.mas_bottom).offset(AdaptationWidth(8));
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.width.mas_equalTo(btn2);
        make.height.mas_equalTo(AdaptationWidth(74));
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_right).offset(AdaptationWidth(8));
        make.top.mas_equalTo(_sdcycleScrollView.mas_bottom).offset(AdaptationWidth(8));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.width.mas_equalTo(btn);
        make.height.mas_equalTo(AdaptationWidth(74));
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(btn.mas_bottom).offset(AdaptationWidth(24));
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
//        make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(49));
        make.width.mas_equalTo(AdaptationWidth(343));
        make.bottom.mas_equalTo(view).offset(-AdaptationWidth(24));
    }];
    return view;
}
- (UIView *)creatFooterView{
    if (!self.dataSourceArr.count) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(203))];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:@"notData"]];
        [view addSubview:image];
        
        UILabel *lab = [[UILabel alloc]init];
        [lab setText:@"喝口水先，暂无推荐"];
        [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        [view addSubview:lab];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view).offset(AdaptationWidth(24));
            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
            make.width.mas_offset(AdaptationWidth(327));
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(image.mas_bottom).offset(16);
            make.centerX.mas_equalTo(image);
        }];
        
        return view;
    }else {
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setCornerValue:20];

        [btn setBackgroundColor:XColorWithRBBA(7, 137, 133, 0.08)];
        [btn setTitleColor:XColorWithRGB(7, 137, 133) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        [btn setTitle:@"全部贷款产品" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tinyEntreGreen"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tinyEntreGreen"] forState:UIControlStateHighlighted];
        btn.tag = RecommendBtnOnClickAllDK;
        [btn sizeToFit];
        btn.titleLabel.backgroundColor = [UIColor clearColor];
        btn.imageView.backgroundColor = [UIColor clearColor];
        CGSize titleSize = btn.titleLabel.frame.size;
        CGSize imageSize = btn.currentImage.size;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width, 0, -(titleSize.width));
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width), 0, imageSize.width);

        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
            make.width.mas_equalTo(134);
            make.height.mas_equalTo(41);
        }];
        
        return view;
    }
    
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (!self.dataSourceArr.count) {
//        return 0.1;
//    }
    return 28;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (!self.dataSourceArr.count) {
//        return nil;
//    }
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"热门产品推荐"];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.centerY.mas_equalTo(view);
    }];
     return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecommendCell";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:nil options:nil].lastObject;
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if(![[UserInfo sharedInstance]isSignIn] ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
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
#pragma mark - sdcycscrollview delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSInteger openType = [self.clientGlobalInfoModel.banner_ad_list[index][@"ad_type"]integerValue];
    NSString *url = self.clientGlobalInfoModel.banner_ad_list[index][@"ad_detail_url"];
    //点击广告日记
    ad_id = self.clientGlobalInfoModel.banner_ad_list[index][@"ad_id"];
    [self prepareDataWithCount:RecommenRequestClickLogRecord];
    
    if (openType == 1) {//应用内打开
        
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//浏览器打开
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark- btn

- (void)btnOnClick:(UIButton *)btn{
    

    switch (btn.tag) {
        case RecommendBtnOnClickAllDK:{
            AllDKViewController *vc = [[AllDKViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RecommendBtnOnClickXYZS:{
            if(![[UserInfo sharedInstance]isSignIn] ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.url = self.wapUrlLisModel.credit_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RecommendBtnOnClickNext:{
            if(![[UserInfo sharedInstance]isSignIn] ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case RecommenRequestHotInfo:
            self.cmd = XGetHotLoanProList;
            self.dict = [self.query_param mj_keyValues];
            break;
        case RecommenRequestClickLogRecord:{
            self.cmd = XAdClickLogRecord;
            self.dict = @{@"ad_id":ad_id};
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case RecommenRequestHotInfo:{
            self.dataSourceArr = response.content[@"loan_pro_list"];
            self.tableView.tableFooterView = [self creatFooterView];
            [self.tableView reloadData];
        }
            break;

        default:
            break;
    }
}

#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:RecommenRequestHotInfo];
}
#pragma mark - tabbar
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if ([tabBarController.selectedViewController isEqual:viewController] && tabBarController.selectedIndex == self.index )  {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Recommend" object:nil];
    }
    self.index = tabBarController.selectedIndex;
    return YES;
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
