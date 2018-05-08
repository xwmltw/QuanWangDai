//
//  InformationViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationModel.h"
#import "XRootWebVC.h"
#import "DateHelper.h"
#import "UIView+XMGExtension.h"
#import "Hot_pintsController.h"
#import "StrategyController.h"
#import "XDeviceHelper.h"

//typedef NS_ENUM(NSInteger ,InformationTableViewHeader) {
//    InformationTableViewHeaderZX,
//    InformationTableViewHeaderRaider,
//    InformationTableViewHeaderHot,
//};
//typedef NS_ENUM(NSInteger , InformationBtn) {
//    InformationBtnRaiders,
//    InformationBtnCenter,
//    InformationBtnCredit,
//    InformationBtnApply,
//};
//typedef NS_ENUM(NSInteger ,InformationRequest) {
//    InformationRequestGetInfo,
//    InformationRequestClickRecord,
//};
typedef NS_ENUM(NSInteger ,InformationRequest) {
    InformationRequestGetInfo,
};
@interface InformationViewController ()<UITabBarControllerDelegate,UIScrollViewDelegate>{
    UIScrollView *mainScrollView;
    UIView   *navView;
    UIButton *topbutton;
}
//@property (nonatomic, strong) NSMutableArray *headerArry;
@property (nonatomic, strong) InformationModel *informationModel;
//@property (nonatomic, strong) NSMutableArray *raiderArry;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView  *sliderView;
@end

@implementation InformationViewController
{
    NSString *click_id;//点击id
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAndLoad) name:@"informationClick" object:nil];
}

- (void)scrollAndLoad {
    //这个方法可直接实现回滚到顶部并且开始刷新
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【资讯】页"];

//    [self getData];
    [self prepareDataWithCount:InformationRequestGetInfo];
    
//    [self createTableViewWithFrame:CGRectZero];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self createTableViewWithFrame:CGRectZero];
    NSString *platform = [XDeviceHelper getDevicePlatform];
    
    if ([platform isEqualToString:@"iPhone10,3"]){
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(24);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 一一一一一 <* 创建子控制器 *> 一一一一一
-(void)setChildControllers{
    Hot_pintsController *hot = [[Hot_pintsController alloc] init];
//    hot.article_cat_id = self.dataSourceArr[0][@"article_cat_id"];
//    hot.is_strategy = self.dataSourceArr[0][@"is_strategy"];
    [self addChildViewController:hot];
    
    for (int i = 1; i < self.dataSourceArr.count; i ++) {
        StrategyController *Strategy = [[StrategyController alloc] init];
        Strategy.article_cat_id = self.dataSourceArr[i][@"article_cat_id"];
        Strategy.is_strategy = self.dataSourceArr[i][@"is_strategy"];
        [self addChildViewController:Strategy];
    }
}

#pragma mark - 初始化三个UIButton和一个滑动的sliderView，三个btn放到一个UIView（navView）上面。
-(void)initUI{
    
    navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    for (int i = 1; i < self.dataSourceArr.count + 1; i ++) {
        self.informationModel = [InformationModel mj_objectWithKeyValues:self.dataSourceArr[i-1]];
        topbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topbutton setTitleColor:XColorWithRBBA(17, 142, 149, 1) forState:UIControlStateSelected];
        [topbutton setTitleColor:XColorWithRBBA(149, 161, 171, 1) forState:UIControlStateNormal];
        topbutton.frame = CGRectMake(ScreenWidth/self.dataSourceArr.count *(i - 1) , 0, ScreenWidth/self.dataSourceArr.count, navView.frame.size.height);
        topbutton.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(12)];
        [topbutton addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
        [topbutton setTitle:self.informationModel.article_cat_name forState:UIControlStateNormal];
        topbutton.tag = i;
        [navView addSubview:topbutton];
        if (i == 1) {
            topbutton.selected = YES;
            topbutton.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
            
            self.sliderView = [[UIView alloc]init];
            self.sliderView.backgroundColor = XColorWithRBBA(17, 142, 149, 1);
            self.sliderView.height = 2;
            self.sliderView.y = navView.height - self.sliderView.height;
            [topbutton.titleLabel sizeToFit];
            self.sliderView.width = topbutton.titleLabel.width;
            self.sliderView.centerX = topbutton.centerX;
            [navView addSubview:self.sliderView];
        }
    }
}

#pragma mark 初始化srollView
-(void)setMainSrollView{
    
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, self.view.frame.size.height - 64)];
    mainScrollView.delegate = self;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.pagingEnabled = YES;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.contentSize = CGSizeMake(ScreenWidth * self.dataSourceArr.count, 0);
    [self.view addSubview:mainScrollView];
    
    UIViewController *vc = self.childViewControllers[0];
    vc.view.x = 0;
    vc.view.y = 0;
    vc.view.height = mainScrollView.frame.size.height;
    [mainScrollView addSubview:vc.view];
    
//    for (int i = 0; i < self.dataSourceArr.count; i ++) {
//        UIViewController *vc = self.childViewControllers[i];
//        vc.view.x = ScreenWidth * i ;
//        vc.view.y = 0;
//        vc.view.height = mainScrollView.frame.size.height;
//        [mainScrollView addSubview:vc.view];
//    }
    
}

#pragma mark - 一一一一一 <* 顶部按钮点击事件 *> 一一一一一
-(void)sliderAction:(UIButton *)sender{
  
    if (self.currentIndex == sender.tag){
        return;
    }
    self.currentIndex = sender.tag;
    for (int i = 1; i < self.dataSourceArr.count + 1; i ++) {
        UIButton *sender = (UIButton *)[self.view viewWithTag:i];
        sender.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(12)];
    }
    UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag];
    button.selected = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderView.width = button.titleLabel.width;
        self.sliderView.centerX = button.centerX;
        mainScrollView.contentOffset = CGPointMake(ScreenWidth * (button.tag - 1), 0);
    }];
    NSInteger index = mainScrollView.contentOffset.x / mainScrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = mainScrollView.contentOffset.x ;
    vc.view.y = 0;
    vc.view.height = mainScrollView.height;
    [mainScrollView addSubview:vc.view];
}

#pragma mark - 一一一一一 <* 手势滑动事件 *> 一一一一一
-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    for (int i = 1; i < self.dataSourceArr.count + 1; i ++) {
        UIButton *sender = (UIButton *)[self.view viewWithTag:i];
        sender.selected = NO;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(12)];
    }
    UIButton *sender1 = (UIButton *)[self.view viewWithTag:tag];
    sender1.selected = YES;
    sender1.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptationWidth(14)];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sliderView.width = sender1.titleLabel.width;
        self.sliderView.centerX = sender1.centerX;
    }];
}

#pragma mark - 一一一一一 <* UIScrollViewDelegate *> 一一一一一
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x ;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    int index_ = contentOffSetX / ScreenWidth;
    [self sliderWithTag:index_+ 1];
}
-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}






//-(UIView *)createFooterView
//{
//    if (!self.informationModel.strategy_list.count || !self.informationModel.zixun_list.count) {
//        UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
//        view.backgroundColor = [UIColor clearColor];
//
//        UILabel *lab = [[UILabel alloc]init];
//        [lab setText:@"新鲜内容马上就来"];
//        [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
//        [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//        [view addSubview:lab];
//
//        UILabel *lab2 = [[UILabel alloc]init];
//        [lab2 setText:@"小编玩命赶稿中…"];
//        [lab2 setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
//        [lab2 setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//        [view addSubview:lab2];
//
//        UIImageView *image = [[UIImageView alloc]init];
//        [image setImage:[UIImage imageNamed:@"messages_nodata"]];
//        [view addSubview:image];
//
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
//            make.top.mas_equalTo(view).offset(AdaptationWidth(40));
//        }];
//        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
//            make.top.mas_equalTo(lab.mas_bottom).offset(4);
//        }];
//        [image mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
//            make.top.mas_equalTo(lab2.mas_bottom).offset(AdaptationWidth(32));
//            make.width.mas_equalTo(AdaptationWidth(327));
//            make.height.mas_equalTo(AdaptationWidth(161));
//        }];
//
//        return view;
//     }
//    return nil;
//}

//- (void)getData
//{
//
//    self.headerArry = [NSMutableArray array];
//    [self.headerArry addObject:@(InformationTableViewHeaderZX)];
//    if (_informationModel.strategy_list.count) {
//        [self.headerArry addObject:@(InformationTableViewHeaderRaider)];
//        self.raiderArry = [NSMutableArray arrayWithArray:_informationModel.strategy_list];
//    }
//    if (_informationModel.zixun_list.count) {
//        [self.headerArry addObject:@(InformationTableViewHeaderHot)];
//    }
//
//}
//#pragma mark - tableview
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.headerArry.count;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]init];
//    UILabel *lab = [[UILabel alloc]init];
//    [view addSubview:lab];
//
//
//    InformationTableViewHeader row = [self.headerArry[section]integerValue];
//    switch (row) {
//        case InformationTableViewHeaderZX:{
//            [lab setText:@"资讯"];
//            [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)]];
//            [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(view).offset(AdaptationWidth(32));
//                make.left.mas_equalTo(view).offset(AdaptationWidth(24));
//            }];
//        }
//            break;
//        case InformationTableViewHeaderRaider:{
//            [lab setText:@"攻略精选"];
//            [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
//            [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
//            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(view).offset(AdaptationWidth(16));
//                make.centerY.mas_equalTo(view);
//            }];
//        }
//            break;
//        case InformationTableViewHeaderHot:{
//            [lab setText:@"热点资讯"];
//            [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
//            [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
//            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(view).offset(AdaptationWidth(16));
//                make.bottom.mas_equalTo(view).offset(AdaptationWidth(0));
//                make.height.mas_equalTo(@(28));
//            }];
//        }
//            break;
//
//        default:
//            break;
//    }
//    return view;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    InformationTableViewHeader row = [self.headerArry[section]integerValue];
//    switch (row) {
//        case InformationTableViewHeaderZX:{
//            return 1;
//        }
//            break;
//        case InformationTableViewHeaderRaider:{
//            return 1;
//        }
//            break;
//        case InformationTableViewHeaderHot:{
//            return _informationModel.zixun_list.count;
//        }
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    InformationTableViewHeader row = [self.headerArry[section]integerValue];
//    if (row == InformationTableViewHeaderZX) {
//        return AdaptationWidth(64);
//    }else if (row == InformationTableViewHeaderRaider)
//    {
//        return AdaptationWidth(44);
//    }else{
//        return AdaptationWidth(36);
//    }
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    InformationTableViewHeader row = [self.headerArry[indexPath.section]integerValue];
//    switch (row) {
//        case InformationTableViewHeaderZX:{
//            return AdaptationWidth(114);
//        }
//            break;
//        case InformationTableViewHeaderRaider:{
//            return AdaptationWidth(143);
//        }
//            break;
//        case InformationTableViewHeaderHot:{
//            return AdaptationWidth(105);
//        }
//            break;
//
//        default:
//            break;
//    }
//    return 0;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"";
//
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    }
////    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
//    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
////    cell.textLabel.text = @"xwm";
//    InformationTableViewHeader row = [self.headerArry[indexPath.section]integerValue];
//    switch (row) {
//        case InformationTableViewHeaderZX:{
//            UIButton *raiderBtn = [[UIButton alloc]init];
//            [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_raiders1"] forState:UIControlStateNormal];
//            [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_raiders_selected1"] forState:UIControlStateHighlighted];
//            raiderBtn.tag = InformationBtnRaiders;
//            [raiderBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:raiderBtn];
//
//            UIButton *centerBtn = [[UIButton alloc]init];
//            [centerBtn setBackgroundImage:[UIImage imageNamed:@"messages_center1"] forState:UIControlStateNormal];
//            [centerBtn setBackgroundImage:[UIImage imageNamed:@"messages_center_selected1"] forState:UIControlStateHighlighted];
//            centerBtn.tag = InformationBtnCenter;
//            [centerBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:centerBtn];
//
//            [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.top.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.bottom.mas_equalTo(cell).offset(-AdaptationWidth(24));
//                make.width.mas_equalTo(centerBtn);
//            }];
//
//            [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(raiderBtn.mas_right).offset(AdaptationWidth(8));
//                make.right.mas_equalTo(cell).offset(-AdaptationWidth(16));
//                make.top.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.bottom.mas_equalTo(cell).offset(-AdaptationWidth(24));
//                make.width.mas_equalTo(raiderBtn);
//            }];
//
//        }
//            break;
//        case InformationTableViewHeaderRaider:{
//            NSInteger btnNum = self.raiderArry.count;
//            UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(143))];
//            scroll.directionalLockEnabled = YES;
//            scroll.scrollEnabled =YES;
//            scroll.showsVerticalScrollIndicator = NO;
//            scroll.showsHorizontalScrollIndicator = NO;
//            scroll.contentSize = CGSizeMake(btnNum * AdaptationWidth(208) , AdaptationWidth(143));
//            [cell addSubview:scroll];
//
//            [self.raiderArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                UIButton *raiderBtn = [[UIButton alloc]init];
//                [raiderBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
//                raiderBtn.titleLabel.numberOfLines = 2;
//                raiderBtn.titleEdgeInsets = UIEdgeInsetsMake(2, AdaptationWidth(24), 12, AdaptationWidth(24));
//                [raiderBtn setTitleColor:XColorWithRGB(7, 137, 133) forState:UIControlStateNormal];
//                NSString *str = obj[@"artical_title"];
////                NSString *str = @"这是一段测试的话话话话话话话话话话话话话话话话话话话话";
//                if (str.length > 11) {
//                    NSString *subStr = [str substringToIndex:11];
//                    [raiderBtn setTitle:[NSString stringWithFormat:@"『%@…』",subStr] forState:UIControlStateNormal];
//                }else{
//                    [raiderBtn setTitle:[NSString stringWithFormat:@"『%@』",str] forState:UIControlStateNormal];
//                }
//                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_frame"] forState:UIControlStateNormal];
//                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"messages_frame_selected"] forState:UIControlStateHighlighted];
//                raiderBtn.tag = idx;
//                [raiderBtn addTarget:self action:@selector(raiderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//                [scroll addSubview:raiderBtn];
//                [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.mas_equalTo(scroll).offset(AdaptationWidth(4)+(idx*AdaptationWidth(208)));
//                    make.top.mas_equalTo(scroll).offset(AdaptationWidth(0));
//                    make.bottom.mas_equalTo(cell).offset(-AdaptationWidth(8));
//                    make.width.mas_equalTo(AdaptationWidth(208));
//                }];
//
//            }];
//
//        }
//            break;
//        case InformationTableViewHeaderHot:{
//
//            UILabel *title = [[UILabel alloc]init];
//            [title setNumberOfLines:2];
//            if (_informationModel) {
//                [title setText:_informationModel.zixun_list[indexPath.row][@"artical_title"]];
//            }
//            [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)]];
//            [title setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//            [cell addSubview:title];
//
//            UILabel *date = [[UILabel alloc]init];
//            if (_informationModel) {
//                [date setText: [DateHelper getDateFromTimeNumber:_informationModel.zixun_list[indexPath.row][@"create_time"]]];
//            }
//            [date setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
//            [date setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
//            [cell addSubview:date];
//
//            UIImageView *imageView = [[UIImageView alloc]init];
//            [imageView setCornerValue:AdaptationWidth(2)];
//            if (_informationModel) {
//                [imageView sd_setImageWithURL:[NSURL URLWithString:_informationModel.zixun_list[indexPath.row][@"cover_img_url"]]];
//            }else{
//                [imageView setImage:[UIImage imageNamed:@"loadingPage-1"]];
//            }
//
//            [cell addSubview:imageView];
//
//            UIView *line = [[UIView alloc]init];
//            line.backgroundColor = XColorWithRGB(233, 233, 235);
//            [cell addSubview:line];
//
//            [title mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.top.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.right.mas_equalTo(imageView.mas_left).offset(-AdaptationWidth(20));
//                make.bottom.mas_equalTo(date.mas_top).offset(-AdaptationWidth(8));
//            }];
//            [date mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.bottom.mas_equalTo(cell).offset(-AdaptationWidth(16));
//            }];
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(cell).offset(-AdaptationWidth(16));
//                make.top.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.width.mas_equalTo(AdaptationWidth(115));
//                make.height.mas_equalTo(AdaptationWidth(74));
//            }];
//            [line mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
//                make.right.mas_equalTo(cell).offset(-AdaptationWidth(16));
//                make.height.mas_equalTo(0.5);
//                make.bottom.mas_equalTo(cell);
//            }];
//        }
//            break;
//        default:
//            break;
//    }
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//
//        //记录日记
//        click_id = _informationModel.zixun_list[indexPath.row][@"id"];
//        [self prepareDataWithCount:InformationRequestClickRecord];
//
//        XRootWebVC *vc = [[XRootWebVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.url = _informationModel.zixun_list[indexPath.row][@"zixun_detail_url"];
//        [self.navigationController pushViewController:vc animated:YES];
//}

//#pragma mark - btn
//- (void)btnOnClick:(UIButton *)btn{
//    switch (btn.tag) {
//        case InformationBtnRaiders:{
//            XRootWebVC *vc = [[XRootWebVC alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.url = _informationModel.strategy_url;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case InformationBtnCenter:{
//            XRootWebVC *vc = [[XRootWebVC alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.url = _informationModel.zixun_url;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//}
//- (void)raiderBtnOnClick:(UIButton *)btn{
//
//    //记录日记
//    click_id = _informationModel.strategy_list[btn.tag][@"id"];
//    [self prepareDataWithCount:InformationRequestClickRecord];
//
//    XRootWebVC *vc = [[XRootWebVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.url = _informationModel.strategy_list[btn.tag][@"zixun_detail_url"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case InformationRequestGetInfo:
            self.cmd = XGetArticleCatList;
            if (self.informationModel.md5_hash.length) {
                self.dict = @{@"md5_hash":self.informationModel.md5_hash};
            }else{
                self.dict = @{@"md5_hash":@""};
            }
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case InformationRequestGetInfo:
            if (![self.informationModel.md5_hash isEqualToString:response.content[@"md5_hash"]]) {
                self.dataSourceArr = response.content[@"article_cat_list"];
                [self setChildControllers];
                [self initUI];
                [self setMainSrollView];
            }
            break;
            
        default:
            break;
    }
}
//#pragma mark - 网络
//- (void)setRequestParams{
//    switch (self.requestCount) {
//        case InformationRequestGetInfo:
//            self.cmd = XGetZiXunCenter;
//            self.dict = [NSDictionary dictionary];
//            break;
//        case InformationRequestClickRecord:
//            self.cmd = XArticleClickRecord;
//            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:click_id,@"content_id", nil];
//            break;
//
//        default:
//            break;
//    }
//}
//- (void)requestSuccessWithDictionary:(XResponse *)response{
//    switch (self.requestCount) {
//        case InformationRequestGetInfo:
//            self.informationModel = [InformationModel mj_objectWithKeyValues:response.content];
//            [self getData];
//            if ( self.informationModel.zixun_list.count == 0 && self.informationModel.strategy_list.count ==  0 ) {
//                self.tableView.tableFooterView = [self createFooterView];
//            }else{
//                self.tableView.tableFooterView = nil;
//            }
//            [self.tableView reloadData];
//            break;
//
//        case InformationRequestClickRecord:
//
//            break;
//
//        default:
//            break;
//    }
//}
- (void)headerRefresh{
    [self prepareDataWithCount:InformationRequestGetInfo];
    self.informationModel = nil;
}
- (InformationModel*)InformationModel{
    if (!_informationModel) {
        _informationModel = [[InformationModel alloc]init];
    }
    return _informationModel;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.selectedViewController isEqual:viewController] && tabBarController.selectedIndex == self.index )  {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"informationClick" object:nil];
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
