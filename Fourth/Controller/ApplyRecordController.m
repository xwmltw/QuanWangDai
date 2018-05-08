//
//  ApplyRecordController.m
//  QuanWangDai
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ApplyRecordController.h"
#import "ApplyListModel.h"
#import "ApplyRecordCell.h"
#import "ContactController.h"
#import "PhoneController.h"
#import "ProductDetailVC.h"
#import "PersonalTailorVC.h"
#import "AllDKViewController.h"
typedef NS_ENUM(NSInteger , ApplyRequest) {
	ApplyRecordRequest,
    ApplyRecordRequestSpecialInfo,
};
@interface ApplyRecordController ()
{
	UIView *bgView;
	NSString *connetString;
}
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, strong) ApplyListModel *applyListModel;
@property (nonatomic, strong) NSMutableArray *loan_pro_list;
@end

@implementation ApplyRecordController

-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"申请记录" forState:UIControlStateNormal];
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
	
	[self prepareDataWithCount:ApplyRecordRequest];
	
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
    titleLabel.text = @"无申请记录";
    [titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [footerView addSubview:titleLabel];
	
	UILabel *tipLabel = [[UILabel alloc]init];
	tipLabel.text = @"您还没有借款记录哦";
    [tipLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [tipLabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
	tipLabel.textAlignment = NSTextAlignmentLeft;
	[footerView addSubview:tipLabel];
	
	UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
	[btn setTitle:@"去借款"forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(ViewAction:) forControlEvents:UIControlEventTouchUpInside];
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
	return 149;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identifier = @"ApplyRecordCell";
	ApplyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[NSBundle mainBundle]loadNibNamed:@"ApplyRecordCell" owner:nil options:nil].lastObject;
	}
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
	cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
	cell.model =[ApplyListModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    [cell.business addTarget:self action:@selector(connetAction1:) forControlEvents:UIControlEventTouchUpInside];
    cell.business.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}
-(void)connetAction1:(UIButton *)button{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(connetAction:)object:button];
    [self performSelector:@selector(connetAction:)withObject:button afterDelay:0.3f];
}
-(void)connetAction:(UIButton *)button{
    [TalkingData trackEvent:@"【申请记录】-联系商户"];
    self.applyListModel =[ApplyListModel mj_objectWithKeyValues:self.dataSourceArr[button.tag]];
    if (!self.applyListModel.contact_wechat_number.length && !self.applyListModel.contact_wechat_public.length && !self.applyListModel.contact_qq.length) {
        NSString * str = [[NSString alloc] initWithFormat:@"telprompt://%@",self.applyListModel.contact_telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        ContactController *rate = [[ContactController alloc]init];
        rate.model = self.applyListModel;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rate];
        nav.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
-(void)ViewAction:(UIButton *)button{
    [TalkingData trackEvent:@"【申请记录】-去借款"];
    if (self.loan_pro_list.count > 3) {
        PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AllDKViewController *vc = [[AllDKViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (self.applyListModel.loan_pro_status.integerValue == 2) {
        [self setHudWithName:@"该产品已下架，去看看其他产品吧." Time:2 andType:3];
        return;
    }
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 网络
- (void)setRequestParams{
	switch (self.requestCount) {
		case ApplyRecordRequest:
			self.cmd = XGetLoanApplyList;
			self.dict =@{@"query_param":@{@"page_size":@(30),
										  @"page_num":@(1)}
//                         ,@"cooperation_type":@(1)
						 };
			break;
        case ApplyRecordRequestSpecialInfo:{
            self.cmd = XGetSpecialLoanProList;
            self.dict = @{};
        }
			
		default:
			break;
	}
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
	switch (self.requestCount) {
		case ApplyRecordRequest:{
            self.dataSourceArr = response.content[@"loan_apply_list"];
			if (self.dataSourceArr.count == 0) {
				self.tableView.tableFooterView = [self createFooterView];
                [self prepareDataWithCount:ApplyRecordRequestSpecialInfo];
			}
			[self.tableView reloadData];
		}
			break;
        case ApplyRecordRequestSpecialInfo:{
            self.loan_pro_list = response.content[@"loan_pro_list"];
        }
			
		default:
			break;
			
	}
}

#pragma  mark - 刷新
- (void)headerRefresh{
	[self prepareDataWithCount:ApplyRecordRequest];
}

#pragma mark - 懒加载
- (QueryParamModel *)query_param{
	if (!_query_param) {
		_query_param = [[QueryParamModel alloc]init];
	}
	return _query_param;
}
- (ApplyListModel *)applyListModel{
	if (!_applyListModel) {
		_applyListModel = [[ApplyListModel alloc]init];
	}
	return _applyListModel;
}
-(NSMutableArray *)loan_pro_list{
    if (!_loan_pro_list) {
        _loan_pro_list = [NSMutableArray array];
    }
    return _loan_pro_list;
}
@end
