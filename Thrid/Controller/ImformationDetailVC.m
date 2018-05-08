//
//  ImformationDetailVC.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ImformationDetailVC.h"
#import "ImformationDetailModel.h"
#import "ImformationEntryCell.h"
#import "SpecialEntryModel.h"
#import "DateHelper.h"
#import "XRootWebVC.h"
#import "SpecialController.h"
typedef NS_ENUM(NSInteger ,ImformationDetailRequest) {
    ImformationDetailRequestGetDetailInfo,
};
@interface ImformationDetailVC ()
@property (nonatomic,strong) ImformationDetailModel *imformationDetailModel;
@property (nonatomic,strong) SpecialEntryModel *specialEntryModel;
@end

@implementation ImformationDetailVC
-(ImformationDetailModel *)imformationDetailModel{
    if (!_imformationDetailModel) {
        _imformationDetailModel = [[ImformationDetailModel alloc]init];
    }
    return _imformationDetailModel;
}
-(SpecialEntryModel *)specialEntryModel{
    if (!_specialEntryModel) {
        _specialEntryModel = [[SpecialEntryModel alloc] init];
    }
    return _specialEntryModel;
}

-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 44);
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"详情" forState:UIControlStateNormal];
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

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self prepareDataWithCount:ImformationDetailRequestGetDetailInfo];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createHeaderView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(300))];
}
-(UIView *)createHeaderView:(CGRect)rect{
    UIView *detailHeadView = [[UIView alloc]initWithFrame:rect];
    detailHeadView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *headImageView = [[UIImageView alloc]init];
    if (self.imformationDetailModel.cover_img_url.length) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.imformationDetailModel.cover_img_url]];
    }else{
        [headImageView setImage:[UIImage imageNamed:@"loading_page-1"]];
    }
    [detailHeadView addSubview:headImageView];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.numberOfLines = 0;
    [lab setText:self.imformationDetailModel.artical_title];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(24)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 1)];
    [detailHeadView addSubview:lab];
    

    if (self.imformationDetailModel.artical_keyword.length) {
        UIView *keywordbgView = [[UIView alloc]init];
        keywordbgView.backgroundColor = XColorWithRBBA(255, 248, 235, 1);
        [detailHeadView addSubview:keywordbgView];
        
        UILabel *keyword = [[UILabel alloc]init];
        [keyword setText:self.imformationDetailModel.artical_keyword];
        [keyword setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [keyword setTextColor:XColorWithRBBA(255, 176, 53, 1)];
        [keywordbgView addSubview:keyword];
        
        [keywordbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(detailHeadView).offset(AdaptationWidth(16));
            make.height.mas_equalTo(AdaptationWidth(26));
            make.right.mas_equalTo(keyword.mas_right).offset(AdaptationWidth(8));
            make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(12));
        }];
        [keyword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keywordbgView).offset(AdaptationWidth(8));
            make.top.mas_equalTo(keywordbgView).offset(AdaptationWidth(4));
            make.bottom.mas_equalTo(keywordbgView).offset(-AdaptationWidth(4));
        }];
    }
    
    UILabel *time_Lab = [[UILabel alloc]init];
    time_Lab.text = [DateHelper getDateFromTimeNumber:self.imformationDetailModel.update_time withFormat:@"yyyy/MM/dd"];
    time_Lab.textAlignment = NSTextAlignmentRight;
    [time_Lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [time_Lab setTextColor:XColorWithRBBA(184, 192, 199, 1)];
    [detailHeadView addSubview:time_Lab];
    
    UILabel *author = [[UILabel alloc]init];
    [author setText:self.imformationDetailModel.artical_author];
    author.textAlignment = NSTextAlignmentRight;
    [author setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [author setTextColor:XColorWithRBBA(184, 192, 199, 1)];
    [detailHeadView addSubview:author];
    
    UILabel *main_text = [[UILabel alloc]init];
    main_text.numberOfLines = 0;
    [main_text setText:self.imformationDetailModel.artical_main_text];
    main_text.textAlignment = NSTextAlignmentLeft;
    [main_text setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(17)]];
    [main_text setTextColor:XColorWithRBBA(34, 58, 80, 1)];
    [detailHeadView addSubview:main_text];
    
    UILabel *read_num = [[UILabel alloc]init];
    if (self.imformationDetailModel.read_num.length) {
        if (self.imformationDetailModel.read_num.integerValue > 10000) {
            read_num.text = [NSString stringWithFormat:@"%.1f万 阅读",self.imformationDetailModel.read_num.floatValue/10000];
        }else if (self.imformationDetailModel.read_num.integerValue > 1000000){
            read_num.text = @"100万+ 阅读";
        }else{
            read_num.text = [NSString stringWithFormat:@"%@ 阅读",self.imformationDetailModel.read_num];
        }
    }else{
        read_num.hidden = YES;
    }
    read_num.textAlignment = NSTextAlignmentLeft;
    [read_num setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [read_num setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [detailHeadView addSubview:read_num];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(detailHeadView);
        make.top.mas_equalTo(detailHeadView);
        make.height.mas_equalTo(AdaptationWidth(177));
        make.width.mas_equalTo(ScreenWidth);
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(detailHeadView).offset(AdaptationWidth(16));
        make.right.mas_equalTo(detailHeadView).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(headImageView.mas_bottom).offset(AdaptationWidth(24));
    }];

    [time_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(detailHeadView).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(15));
    }];
    [author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(time_Lab.mas_left).offset(-AdaptationWidth(10));
        make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(15));
//        make.left.mas_equalTo(keywordbgView.mas_right).offset(AdaptationWidth(8));
    }];
    [main_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(detailHeadView).offset(-AdaptationWidth(16));
        make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(62));
        make.left.mas_equalTo(detailHeadView).offset(AdaptationWidth(16));
    }];
    [read_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(main_text.mas_bottom).offset(AdaptationWidth(24));
        make.left.mas_equalTo(detailHeadView).offset(AdaptationWidth(16));
    }];
    
    return detailHeadView;
}
#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.specialEntryModel.special_entry_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.specialEntryModel.special_entry_list.count == 0) {
        return 0.1;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview = [[UIView alloc]init];
    headview.backgroundColor = XColorWithRBBA(248, 249, 250, 1);
    return headview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ImformationEntryCell";
    ImformationEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ImformationEntryCell" owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupmodel:self.specialEntryModel indexpath:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSNumber *indx = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_type"];
    if (indx.integerValue == 1) {
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_url"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indx.integerValue == 2) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_url"]]]];
    }
    if (indx.integerValue == 3) {
        SpecialController *vc = [[SpecialController alloc]init];
        vc.titleStr = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_title"];
        vc.special_entry_id = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_id"];
        vc.loan_product_type = self.specialEntryModel.special_entry_list[indexPath.row][@"loan_product_type"];
        vc.loan_classify_ids_str = self.specialEntryModel.special_entry_list[indexPath.row][@"loan_classify_ids_str"];
        vc.list_properties = self.specialEntryModel.special_entry_list[indexPath.row][@"list_properties"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case ImformationDetailRequestGetDetailInfo:{
            self.cmd = XGetArticleDetail;
            self.dict = @{@"article_id":self.article_id};
            }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ImformationDetailRequestGetDetailInfo:{
            self.imformationDetailModel =[ImformationDetailModel mj_objectWithKeyValues:response.content[@"article_detail"]];
            /*!< 计算标题高度 >*/
            NSString *artical_title = self.imformationDetailModel.artical_title;
            NSDictionary *artical_title_dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(24)]};
            CGSize artical_title_size = [artical_title boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(32), 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:artical_title_dic context:nil].size;
            /*!< 计算正文高度 >*/
            NSString *artical_main_text = self.imformationDetailModel.artical_main_text;
            NSDictionary *artical_main_text_dic = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(17)]};
            CGSize artical_main_text_size = [artical_main_text boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(32), 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:artical_main_text_dic context:nil].size;
            /*!< 头部 >*/
            self.tableView.tableHeaderView = [self createHeaderView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(201) + artical_title_size.height  + AdaptationWidth(62) + artical_main_text_size.height + AdaptationWidth(60))];
            self.specialEntryModel = [SpecialEntryModel mj_objectWithKeyValues:response.content];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
-(void)headerRefresh{
    [self prepareDataWithCount:ImformationDetailRequestGetDetailInfo];
}
@end
