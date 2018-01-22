//
//  AuthenticationManVC.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "AuthenticationManVC.h"

@interface AuthenticationManVC ()

@end

@implementation AuthenticationManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self creatHeadView];
    self.tableView.tableFooterView = [self creatFooterView];
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
    return view;
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
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //    if (!self.dataSourceArr.count) {
//    //        return nil;
//    //    }
//    UIView * view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    UILabel *lab = [[UILabel alloc]init];
//    [lab setText:@"热门产品推荐"];
//    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
//    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
//    [view addSubview:lab];
//    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
//        make.centerY.mas_equalTo(view);
//    }];
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UITableViewCell" owner:nil options:nil].lastObject;
    }
//    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
//    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
//    cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

}

@end
