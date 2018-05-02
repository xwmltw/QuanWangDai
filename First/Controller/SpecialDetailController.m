//
//  SpecialDetailController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/23.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "SpecialDetailController.h"
#import "ProductDetailVC.h"
#import "RecommendTableViewCell.h"

typedef NS_ENUM(NSInteger , SpecialDetailRequest) {
    SpecialDetailRecordRequest,
};
@interface SpecialDetailController ()
@property (nonatomic, strong) QueryParamModel *query_param;

@property (nonatomic ,strong) QueryParamModel *queryParamModel;
@property (nonatomic ,strong) RecommendTableViewCell *cell;

@end

@implementation SpecialDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareDataWithCount:SpecialDetailRecordRequest];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)setBackNavigationBarItem
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 124, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 130, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:self.titleStr forState:UIControlStateNormal];
   
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
}

-(UIView *)createFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"暂无合适的产品"];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [footerView addSubview:lab];
    
    UILabel *lab2 = [[UILabel alloc]init];
    [lab2 setText:@"逛逛其他地方先，玩命补货中…"];
    [lab2 setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [lab2 setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [footerView addSubview:lab2];
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"allDK_notData"]];
    [footerView addSubview:image];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(footerView).offset(AdaptationWidth(64));
    }];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab.mas_bottom).offset(4);
    }];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab2.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(327));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    return footerView;
}

#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"RecommendCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!_cell) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendCell" owner:nil options:nil].lastObject;
    }
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    _cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    _cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    _cell.appState.hidden = YES;
    return _cell;
}

#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case SpecialDetailRecordRequest:
            self.cmd = XQuerySpecialEntryLoanProductList;
            self.productListModel.query_param = self.queryParamModel;
            self.dict = [self.productListModel mj_keyValues];
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case SpecialDetailRecordRequest:{
            self.dataSourceArr = response.content[@"loan_pro_list"];
            if (self.dataSourceArr.count == 0) {
                self.tableView.tableFooterView = [self createFooterView];
            }
            [self.tableView reloadData];
        }
            break;
        default:
            break;
            
    }
}

#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:SpecialDetailRecordRequest];
}

#pragma mark - 懒加载
- (QueryParamModel *)query_param{
    if (!_query_param) {
        _query_param = [[QueryParamModel alloc]init];
    }
    return _query_param;
}
- (ProductListModel *)productListModel{
    if (!_productListModel) {
        _productListModel = [[ProductListModel alloc]init];
    }
    return _productListModel;
}

@end

