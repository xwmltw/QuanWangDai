//
//  BuyRecordController.m
//  QuanWangDai
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "BuyRecordController.h"
#import "MoneyListModel.h"
#import "BuyReocordCell.h"
#import "ReportController.h"
typedef NS_ENUM(NSInteger , BuyRequest) {
	BuyRecordRequest,
};
@interface BuyRecordController ()
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, strong) MoneyListModel *moneyListModel;
@end

@implementation BuyRecordController
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"交易记录" forState:UIControlStateNormal];
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

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self prepareDataWithCount:BuyRecordRequest];
	
	[self createTableViewWithFrame:CGRectZero];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.right.bottom.mas_equalTo(self.view);
	}];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(UIView *)createFooterView{
	UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
	
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"无记录"];
    [footerView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"无交易记录";
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [footerView addSubview:titleLabel];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"您还没有交易记录哦";
    [tipLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [tipLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [footerView addSubview:tipLabel];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [btn setTitle:@"去购买"forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(footerView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(footerView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(footerView).offset(AdaptationWidth(32));
        make.height.mas_equalTo(AdaptationWidth(42));
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(footerView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(26));
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
	
	return footerView;
}


#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return self.dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 91;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"BuyRecordCell";
	BuyReocordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[BuyReocordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
	cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
	cell.model = [MoneyListModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
	
	//	ProductDetailVC *vc = [[ProductDetailVC alloc]init];
	//	vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
	//	vc.hidesBottomBarWhenPushed = YES;
	//	[self.navigationController pushViewController:vc animated:YES];
}

-(void)BtnAction{
    [TalkingData trackEvent:@"【交易记录】-去购买"];
    ReportController *vc = [[ReportController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络
- (void)setRequestParams{
	switch (self.requestCount) {
		case BuyRecordRequest:
			self.cmd = XGetMoneyDetailList;
			self.dict =@{@"query_param":@{@"page_size":@(30),
										  @"page_num":@(1)
										  },
//                         @"cooperation_type":@(1)
						 };
			break;
			
		default:
			break;
	}
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
	switch (self.requestCount) {
		case BuyRecordRequest:{
            self.dataSourceArr = response.content[@"detail_list"];
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
	[self prepareDataWithCount:BuyRecordRequest];
}

#pragma mark - 懒加载
- (QueryParamModel *)query_param{
	if (!_query_param) {
		_query_param = [[QueryParamModel alloc]init];
	}
	return _query_param;
}
- (MoneyListModel *)moneyListModel{
	if (!_moneyListModel) {
		_moneyListModel = [[MoneyListModel alloc]init];
	}
	return _moneyListModel;
}


@end

