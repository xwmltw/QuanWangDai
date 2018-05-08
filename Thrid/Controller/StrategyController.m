//
//  StrategyController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "StrategyController.h"
#import "InformationCell.h"
#import "ImformationDetailModel.h"
#import "ImformationDetailVC.h"
#import "InformationModel.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSInteger ,StrategyRequest) {
    StrategyRequestGetList,
    StrategyRequestGethandpick,
};
@interface StrategyController ()
@property (nonatomic,strong) ImformationDetailModel *imformationDetailModel;
@property (nonatomic, strong) InformationModel *informationModel;
@property (nonatomic, strong) NSMutableArray *raiderArry;
@property (nonatomic,assign) NSNumber *page_num;
@end

@implementation StrategyController

-(ImformationDetailModel *)imformationDetailModel{
    if (!_imformationDetailModel) {
        _imformationDetailModel = [[ImformationDetailModel alloc]init];
    }
    return _imformationDetailModel;
}
- (InformationModel*)InformationModel{
    if (!_informationModel) {
        _informationModel = [[InformationModel alloc]init];
    }
    return _informationModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self prepareDataWithCount:StrategyRequestGetList];
    
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
    if (self.is_strategy.integerValue == 1) {
        self.tableView.tableHeaderView = [self createHeadView];
    }
}
-(UIView *)createHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(187))];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"攻略精选"];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [headView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(16));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(16));
    }];
    
    NSInteger btnNum = self.raiderArry.count;
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, AdaptationWidth(52), ScreenWidth, AdaptationWidth(135))];
    scroll.directionalLockEnabled = YES;
    scroll.scrollEnabled =YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(btnNum * AdaptationWidth(208) , AdaptationWidth(135));
    [headView addSubview:scroll];

    [self.raiderArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *raiderBtn = [[UIButton alloc]init];
        [raiderBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
        raiderBtn.titleLabel.numberOfLines = 2;
        raiderBtn.titleEdgeInsets = UIEdgeInsetsMake(2, AdaptationWidth(24), 12, AdaptationWidth(24));
        [raiderBtn setTitleColor:XColorWithRGB(7, 137, 133) forState:UIControlStateNormal];
        NSString *str = obj[@"artical_title"];
//                NSString *str = @"这是一段测试的话话话话话话话话话话话话话话话话话话话话";
        if (str.length > 11) {
            NSString *subStr = [str substringToIndex:11];
            [raiderBtn setTitle:[NSString stringWithFormat:@"『%@…』",subStr] forState:UIControlStateNormal];
        }else{
            [raiderBtn setTitle:[NSString stringWithFormat:@"『%@』",str] forState:UIControlStateNormal];
        }
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_frame"] forState:UIControlStateNormal];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_frame_selected"] forState:UIControlStateHighlighted];
        raiderBtn.tag = idx;
        [raiderBtn addTarget:self action:@selector(raiderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:raiderBtn];
        [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scroll).offset(AdaptationWidth(4)+(idx*AdaptationWidth(208)));
            make.top.mas_equalTo(scroll).offset(AdaptationWidth(0));
            make.bottom.mas_equalTo(headView).offset(-AdaptationWidth(8));
            make.width.mas_equalTo(AdaptationWidth(208));
        }];

    }];
    return headView;
}

- (void)raiderBtnOnClick:(UIButton *)btn{
    XRootWebVC *vc = [[XRootWebVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = _informationModel.strategy_list[btn.tag][@"zixun_detail_url"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
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
    cell.model = [ImformationDetailModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    self.imformationDetailModel = [ImformationDetailModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    ImformationDetailVC *vc = [[ImformationDetailVC alloc]init];
    vc.article_id = self.imformationDetailModel.article_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case StrategyRequestGetList:
            self.cmd = XGetArticleList;
            if (self.is_strategy.integerValue == 1) {
                self.dict = @{@"query_param":@{@"page_size":@(30),@"page_num":self.page_num}
                              ,@"article_cat_id":self.article_cat_id
                              ,@"is_strategy":@(1)};
            }else{
                self.dict = @{@"query_param":@{@"page_size":@(30),@"page_num":self.page_num}
                              ,@"article_cat_id":self.article_cat_id
                              ,@"is_strategy":@(0)};
            }
            
            break;
        case StrategyRequestGethandpick:
            self.cmd = XGetZiXunCenter;
            self.dict = [NSDictionary new];
            
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case StrategyRequestGetList:{
            [self.dataSourceArr addObjectsFromArray:response.content[@"article_list"]];
            [self.tableView reloadData];
            [self prepareDataWithCount:StrategyRequestGethandpick];
        }
            break;
        case StrategyRequestGethandpick:{
            self.informationModel = [InformationModel mj_objectWithKeyValues:response.content];
            self.raiderArry = [NSMutableArray arrayWithArray:self.informationModel.strategy_list];
            if (self.is_strategy.integerValue == 1) {
                self.tableView.tableHeaderView = [self createHeadView];
            }
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
-(void)headerRefresh{
    [self prepareDataWithCount:StrategyRequestGetList];
}
- (void)footerRefresh{
    self.page_num = @(self.page_num.integerValue + 1);
    [self prepareDataWithCount:StrategyRequestGetList];
}
@end

