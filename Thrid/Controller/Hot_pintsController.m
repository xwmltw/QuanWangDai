//
//  Hot_pintsController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "Hot_pintsController.h"
#import "InformationCell.h"
#import "ImformationDetailModel.h"
#import "ImformationDetailVC.h"
#import "SDCycleScrollView.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSInteger ,Hot_pintsRequest) {
    Hot_pintsRequestGetbanner,
    Hot_pintsRequestGetHotlist,
};
@interface Hot_pintsController ()<SDCycleScrollViewDelegate>
{
    NSMutableArray *imageArry;   // banner图片源
    NSMutableArray *imageArry2;  // banner2图片源
    NSMutableArray *titleArry;   // banner文字源
    NSMutableArray *titleArry2;  // banner2文字源
}
@property (nonatomic,strong) ImformationDetailModel *imformationDetailModel;
@property (nonatomic,strong) NSMutableArray *bannerArr;
@property (nonatomic,strong) NSMutableArray *bannerArr2;
@property (nonatomic,strong) NSMutableArray *dataArr2;
@property (nonatomic,strong) SDCycleScrollView *sdcycleScrollView;
@property (nonatomic,assign) NSNumber *page_num;
@end

@implementation Hot_pintsController
-(ImformationDetailModel *)imformationDetailModel{
    if (!_imformationDetailModel) {
        _imformationDetailModel = [[ImformationDetailModel alloc]init];
    }
    return _imformationDetailModel;
}
-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [[NSMutableArray alloc]init];
    }
    return _bannerArr;
}
-(NSMutableArray *)bannerArr2{
    if (!_bannerArr2) {
        _bannerArr2 = [[NSMutableArray alloc]init];
    }
    return _bannerArr2;
}
-(NSMutableArray *)dataArr2{
    if (!_dataArr2) {
        _dataArr2 = [[NSMutableArray alloc]init];
    }
    return _dataArr2;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self prepareDataWithCount:Hot_pintsRequestGetHotlist];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page_num = @(1);
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.hidden = NO;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"——————  我是有底线的  ——————" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(12)];
    footer.stateLabel.textColor = XColorWithRBBA(34, 58, 80, 0.32);
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];

    if (section == 0 && imageArry.count != 0) {
        _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"loading_page-1"]];
        [_sdcycleScrollView setCornerValue:AdaptationWidth(8)];
        _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _sdcycleScrollView.autoScrollTimeInterval = 5;
        _sdcycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _sdcycleScrollView.layer.masksToBounds = YES;
        _sdcycleScrollView.layer.cornerRadius = AdaptationWidth(2);
        _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
        [view addSubview:_sdcycleScrollView];
        if (imageArry.count == 0 ) {
            _sdcycleScrollView.hidden = YES;
        }
        if (imageArry.count == 1 ) {
            _sdcycleScrollView.autoScroll = NO;
        }
        _sdcycleScrollView.imageURLStringsGroup = imageArry;
        _sdcycleScrollView.titlesGroup = titleArry;
        _sdcycleScrollView.titleLabelTextColor = XColorWithRBBA(255, 255, 255, 1);
        _sdcycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _sdcycleScrollView.titleLabelTextFont = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)];
        _sdcycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        _sdcycleScrollView.titleLabelHeight = AdaptationWidth(56);
        [_sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(view);
        }];
    }else if(section == 1 && imageArry2.count != 0){
        _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"loading_page-1"]];
        [_sdcycleScrollView setCornerValue:AdaptationWidth(8)];
        _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _sdcycleScrollView.autoScrollTimeInterval = 5;
        _sdcycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _sdcycleScrollView.layer.masksToBounds = YES;
        _sdcycleScrollView.layer.cornerRadius = AdaptationWidth(2);
        _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
        [view addSubview:_sdcycleScrollView];
        if (imageArry2.count == 0 ) {
            _sdcycleScrollView.hidden = YES;
        }
        if (imageArry2.count == 1 ) {
            _sdcycleScrollView.autoScroll = NO;
        }
        _sdcycleScrollView.imageURLStringsGroup = imageArry2;
        _sdcycleScrollView.titlesGroup = titleArry2;
        _sdcycleScrollView.titleLabelTextColor = XColorWithRBBA(255, 255, 255, 1);
        _sdcycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        _sdcycleScrollView.titleLabelTextFont = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)];
        _sdcycleScrollView.titleLabelTextAlignment = NSTextAlignmentLeft;
        _sdcycleScrollView.titleLabelHeight = AdaptationWidth(56);
        
        UILabel *lab = [[UILabel alloc]init];
        [lab setText:@"万款豪车超低价巨划算！"];
        [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)]];
        [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [view addSubview:lab];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = XColorWithRBBA(233, 233, 235, 1);
        [view addSubview:lineView];
        
        [_sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view).offset(AdaptationWidth(54));
            make.left.mas_equalTo(view).offset(AdaptationWidth(16));
            make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
            make.bottom.mas_equalTo(view).offset(-AdaptationWidth(16));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(AdaptationWidth(16));
            make.right.mas_equalTo(view).offset(-AdaptationWidth(16));
            make.bottom.mas_equalTo(view);
            make.height.mas_equalTo(0.5);
        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(AdaptationWidth(16));
            make.top.mas_equalTo(view).offset(AdaptationWidth(16));
        }];
    }

    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr2.count;
    }
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (imageArry2.count != 0) {
            return AdaptationWidth(230);
        }else{
            return 0.1;
        }
    }
    if (imageArry.count != 0) {
        return AdaptationWidth(180);
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"InformationCell";
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"InformationCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.model = [ImformationDetailModel mj_objectWithKeyValues:self.dataArr2[indexPath.row]];
    }else{
        cell.model = [ImformationDetailModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section == 0) {
        self.imformationDetailModel = [ImformationDetailModel mj_objectWithKeyValues:self.dataArr2[indexPath.row]];
    }else{
        self.imformationDetailModel = [ImformationDetailModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    }
    ImformationDetailVC *vc = [[ImformationDetailVC alloc]init];
    vc.article_id = self.imformationDetailModel.article_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - sdcycscrollview delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    NSInteger login = [self.bannerArr[index][@"is_need_login"]integerValue];
    if (login) {
        if(![[UserInfo sharedInstance]isSignIn]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getBlackLogin:self];//判断是否登录状态
            });
            return;
        }
    }
    NSInteger openType = [self.bannerArr[index][@"ad_type"]integerValue];
    NSString *url = self.bannerArr[index][@"ad_detail_url"];
//    //点击广告日记
//    ad_id = self.clientGlobalInfoModel.banner_ad_list[index][@"ad_id"];
//    [self prepareDataWithCount:RecommenRequestClickLogRecord];
    
    if (openType == 1) {//应用内打开
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else{//浏览器打开
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case Hot_pintsRequestGetHotlist:
            self.cmd = XGetArticleList;
            self.dict = @{@"query_param":@{@"page_size":@(30),@"page_num":self.page_num}
                          ,@"is_hot":@(1)};
            break;
        case Hot_pintsRequestGetbanner:
            self.cmd = XGetArticleAdInfoList;
            self.dict = [NSDictionary new];
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case Hot_pintsRequestGetHotlist:{            
            [response.content[@"article_list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx < 6 && self.page_num.integerValue == 1) {
                    [self.dataArr2 addObject:obj];
                }else{
                    [self.dataSourceArr addObject:obj];
                }
            }];
            [self.tableView reloadData];
            [self prepareDataWithCount:Hot_pintsRequestGetbanner];
        }
            break;
        case Hot_pintsRequestGetbanner:{
            self.bannerArr = response.content[@"article_banner_ad_list"];
            imageArry = [NSMutableArray array];
            titleArry = [NSMutableArray array];
            [self.bannerArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str = obj[@"img_url"];
                NSString *str2= obj[@"ad_name"];
                if(str.length)
                    [imageArry addObject:str];
                    [titleArry addObject:str2];
            }];
            self.bannerArr2 = response.content[@"article_list_ad_list"];
            imageArry2 = [NSMutableArray array];
            titleArry2 = [NSMutableArray array];
            [self.bannerArr2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str = obj[@"img_url"];
                NSString *str2= obj[@"ad_name"];
                if(str.length)
                    [imageArry2 addObject:str];
                    [titleArry2 addObject:str2];
            }];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
-(void)headerRefresh{
    [self prepareDataWithCount:Hot_pintsRequestGetHotlist];
}
- (void)footerRefresh{
        self.page_num = @(self.page_num.integerValue + 1);
        [self prepareDataWithCount:Hot_pintsRequestGetHotlist];
}
@end
