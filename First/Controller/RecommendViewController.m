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
#import "ReconmendCollectionCell.h"
#import "SpecialEntryModel.h"
#import "ApplicantManVC.h"
#import "UserLocation.h"
#import "PersonalTailorVC.h"
#import "ReconmadView.h"
#import "RecommentTopBtn.h"
#import "SYVerticalAutoScrollView.h"
#import "FeatureView.h"
#import "ReportController.h"
#import "CreditState.h"
#import "RecommendTableViewSecond.h"
#import "SpecialTopView.h"
#import "SpecialController.h"
typedef NS_ENUM(NSInteger , RecommendBtnOnClick){
    RecommendBtnOnClickAllDK,
    RecommendBtnOnClickUnlogin,
    RecommendBtnOnClickComplete,
    RecommendBtnOnClickCustomization,
    RecommendBtnOnClickLocation,
    RecommendBtnOnClickCreditState,
    RecommendBtnOnClickOther,
};
typedef NS_ENUM(NSInteger , RecommenRequest) {
    RecommenRequestHotInfo,
    RecommenRequestClickLogRecord,
    RecommenRequestSpecialEntry,
    RecommenRequestSpecialInfo,
    RecommenRequestCreditInfo,
};
 typedef NS_ENUM(NSInteger , RecommenTableViewSection) {
     RecommenTableViewSectionOne,
     RecommenTableViewSectionSecond,
 };
@interface RecommendViewController ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIView *scrollbgView;        // 无列表数据
    UIView *scrollbgViewList;    // 有列表数据
    UIView *scrollbgViewUnlogin; // 未登录
    NSMutableArray *imageArry;   // banner图片源
    NSString *ad_id;             // banner点击日志
    UIView * headerView;               // 头视图View
    UIView *TopBtnView;         // 头视图View
}
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, strong) ProductModel *specialproductModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) WapUrlList *wapUrlLisModel;
@property (nonatomic, strong) SpecialEntryModel *specialEntryModel;
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic, strong) SDCycleScrollView *sdcycleScrollView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIButton *locationbtn;
@property (nonatomic, strong) UIImageView *refreshView;
@property (nonatomic, strong) NSMutableArray *loan_pro_list;
@property (nonatomic, strong) NSMutableArray *tableViewSectionArry;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) SpecialTopView *customView;
@property (nonatomic, strong) NSMutableArray *custArr;
@property (nonatomic, copy) NSNumber *loan_pro_list_row;//推荐个数
@end

@implementation RecommendViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.delegate = self;
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor whiteColor];
    
    
    if ([[UserInfo sharedInstance]isSignIn]){
        //弹窗显示专属推荐
        NSDate *tadayDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *locationStr = [formatter stringFromDate:tadayDate];
        if (![locationStr isEqualToString:[WDUserDefaults objectForKey:@"tadayDate"]] && ![[UserInfo sharedInstance].phoneName isEqualToString:[WDUserDefaults objectForKey:@"UserName"]]) {
            
            if ([UserInfo sharedInstance].has_grant_authorization.integerValue != 1) {
                [self showAlertView:^(id result) {
                    [self createRemindView];
                }];
                
            }else{
                [self createRemindView];
            }
        }
        
        [WDUserDefaults setValue:locationStr forKey:@"tadayDate"];
        [WDUserDefaults synchronize];
    }
    
    [_customView run];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_customView stop];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"【推荐】页"];
    
    [self setData];
    [self prepareDataWithCount:RecommenRequestSpecialEntry];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(49);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (imageArry.count) {
         self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(423))];//57
    }else{
         self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(323))];
    }
   

    /*!< 通知 >*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAndLoad) name:@"Recommend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"Refresh" object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(notificationLocation:) name:XLocationCityName object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(ntificationAlert:) name:XNotificationAlert object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(notificationActivity:) name:@"ActivityProductVC" object:nil];
   
    
}

-(void)createRemindView{
	ReconmadView *view = [[ReconmadView alloc]initWithTitle:@"只需一步，100%下款" content:@"根据您的资料，为您推荐一定能贷的产品。" imgUrlStr:@"下款插图" cancel:@"cancel_btn" commit:@"获取推荐"  block:^(NSInteger block) {
		switch (block) {
			case 2:{ // 不再提醒
                [WDUserDefaults setValue:[UserInfo sharedInstance].phoneName forKey:@"UserName"];
                [WDUserDefaults synchronize];
			}
                break;
			case 1:{ // 获取推荐
                
				[CreditState selectCreaditState:self with:nil];
			}
				break;
			case 0:{ // 关闭
				//				//强制关闭应用
				//				exit(0);
				
			}
                break;
			default:
				break;
		}
	}];
	[[[UIApplication sharedApplication] keyWindow]addSubview:view];
}

- (void)setData{
    imageArry = [NSMutableArray array];
    [self.clientGlobalInfoModel.banner_ad_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str= obj[@"img_url"];
        if(str.length)
        [imageArry addObject:str];
    }];
}
#pragma mark - 通知
- (void)scrollAndLoad {
    //这个方法可直接实现回滚到顶部并且开始刷新
    [self.tableView.mj_header beginRefreshing];
}
-(void)refresh{

    [self prepareDataWithCount:RecommenRequestSpecialEntry];
    
}
- (void)notificationLocation:(NSNotification *)notification{
   
    [self performSelector:@selector(changeNotificationStatus)withObject:nil afterDelay:2.0f];//防止重复点击
    [_locationbtn setTitle:notification.object forState:UIControlStateNormal];
}
- (void)changeNotificationStatus{
    [self prepareDataWithCount:RecommenRequestHotInfo];
}
- (void)ntificationAlert:(NSNotification *)notification{
    XRootWebVC *vc = [[XRootWebVC alloc]init];
    vc.url = notification.object[@"url"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)notificationActivity:(NSNotification *)notification{
    [self setHudWithName:@"唤起" Time:2 andType:1];
    
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = notification.userInfo[@"url"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 一一一一一 <* 头视图创建 *> 一一一一一
- (UIView *)creatHeadView:(CGRect)rect{
    
    headerView = [[UIView alloc]initWithFrame:rect];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:topView];
    
/*!< 推荐 >*/
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)]];
    [titleLab setText:@"推荐"];
    [titleLab setTextColor:XColorWithRGB(77, 96, 114)];
    [topView addSubview:titleLab];
    
/*!< 定位 >*/
    _locationbtn = [[UIButton alloc]init];
    [_locationbtn setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_locationbtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
    NSString *locationStr = [[UserLocation sharedInstance]getCityName];
    if (locationStr.length) {
        [_locationbtn setTitle:locationStr forState:UIControlStateNormal];
    }else{
        [_locationbtn setTitle:@"重新定位" forState:UIControlStateNormal];
    }
    
    _locationbtn.tag = RecommendBtnOnClickLocation;
    [_locationbtn sizeToFit];
    _locationbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _locationbtn.titleLabel.backgroundColor = [UIColor clearColor];
    _locationbtn.imageView.backgroundColor = [UIColor clearColor];
//    _locationbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -AdaptationWidth(36), 0, AdaptationWidth(36));
    [_locationbtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_locationbtn];
    
    _refreshView = [[UIImageView alloc]init];
    _refreshView.image = [UIImage imageNamed:@"icon_refresh"];
    _refreshView.backgroundColor = [UIColor clearColor];
    _refreshView.layer.masksToBounds = YES;
    _refreshView.layer.cornerRadius = AdaptationWidth(14);
    _refreshView.userInteractionEnabled = NO;
    [_locationbtn addSubview:_refreshView];
    
    [self createTopBtn];
/*!< 特色入口 >*/
    [self createCollectionView];
    
/*!< banner >*/
    _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"loadingPage-2"]];
    _sdcycleScrollView.imageURLStringsGroup = imageArry;
    if (imageArry.count == 1 ) {
        _sdcycleScrollView.autoScroll = NO;
    }
    [_sdcycleScrollView setCornerValue:AdaptationWidth(8)];
    _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _sdcycleScrollView.autoScrollTimeInterval = 3;
    _sdcycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdcycleScrollView.layer.masksToBounds = YES;
    _sdcycleScrollView.layer.cornerRadius = AdaptationWidth(2);
    _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
    [headerView addSubview:_sdcycleScrollView];
    if (imageArry.count == 0 ) {
        _sdcycleScrollView.hidden = YES;
    }
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView).offset(AdaptationWidth(20));
        make.left.right.mas_equalTo(headerView);
        make.centerX.mas_equalTo(headerView);
        make.height.mas_equalTo(AdaptationWidth(72));
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView).offset(AdaptationWidth(10));
        make.left.mas_equalTo(topView).offset(AdaptationWidth(24));
    }];
    [_refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLab);
        make.right.mas_equalTo(topView).offset(-AdaptationWidth(16));
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    [_locationbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_refreshView);
        make.right.mas_equalTo(_refreshView.mas_left).offset(-AdaptationWidth(8));
//        make.top.mas_equalTo(topView).offset(AdaptationWidth(30));
//        make.right.mas_equalTo(topView).offset(-AdaptationWidth(16));
//        make.left.mas_equalTo(titleLab.mas_right);
        make.height.mas_equalTo(22);
    }];
    [_sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_customView.mas_bottom).offset(AdaptationWidth(12));
        make.left.mas_equalTo(headerView).offset(AdaptationWidth(16));
        make.width.mas_equalTo(AdaptationWidth(343));
        make.height.mas_equalTo(AdaptationWidth(84));
    }];
    return headerView;
}
#pragma mark - 一一一一一 <* 贷款大全，信用查询 *> 一一一一一
- (void)createTopBtn{
    
    TopBtnView  = [[UIView alloc]init];
    TopBtnView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:TopBtnView];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(240, 240, 240);
    [TopBtnView addSubview:line];
    
    [TopBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_refreshView.mas_bottom).offset(AdaptationWidth(16));
        make.left.right.mas_equalTo(headerView);
        make.height.mas_equalTo(AdaptationWidth(136));
    }];
    
    RecommentTopBtn *btn1 = [[RecommentTopBtn alloc]init];
    btn1.tag = 200;
    [btn1 addTarget:self action:@selector(btnOnTopClick:) forControlEvents:UIControlEventTouchUpInside];
    btn1.btnTitle = @"我要借钱";
    [btn1 setImage:[UIImage imageNamed:@"top_needMoney"] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"top_needMoney"] forState:UIControlStateHighlighted];
    [TopBtnView addSubview:btn1];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(TopBtnView);
        make.width.mas_equalTo(AdaptationWidth(125));
        make.height.mas_equalTo(AdaptationWidth(127));
    }];
    
    RecommentTopBtn *btn2 = [[RecommentTopBtn alloc]init];
    btn2.tag = 201;
    [btn2 addTarget:self action:@selector(btnOnTopClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.btnTitle = @"办信用卡";
    [btn2 setImage:[UIImage imageNamed:@"top_getCard"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"top_needMoney"] forState:UIControlStateHighlighted];
    [TopBtnView addSubview:btn2];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(TopBtnView);
        make.top.mas_equalTo(TopBtnView);
        make.width.mas_equalTo(AdaptationWidth(125));
        make.height.mas_equalTo(AdaptationWidth(127));
    }];
    
    RecommentTopBtn *btn3 = [[RecommentTopBtn alloc]init];
    btn3.tag = 202;
    [btn3 addTarget:self action:@selector(btnOnTopClick:) forControlEvents:UIControlEventTouchUpInside];
    btn3.btnTitle = @"信用查询";
    [btn3 setImage:[UIImage imageNamed:@"top_query"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"top_needMoney"] forState:UIControlStateHighlighted];
    [TopBtnView addSubview:btn3];
    
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(TopBtnView);
        make.width.mas_equalTo(AdaptationWidth(125));
        make.height.mas_equalTo(AdaptationWidth(127));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(TopBtnView);
        make.bottom.mas_equalTo(TopBtnView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark - 一一一一一 <* 特色入口 *> 一一一一一
-(void)createCollectionView{
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = -1;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 22, AdaptationWidth(91)) collectionViewLayout:_flowLayout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:_collectionView];
    
    _collectionView1 = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 22, AdaptationWidth(91)) collectionViewLayout:_flowLayout];
    _collectionView1.delegate = self;
    _collectionView1.dataSource = self;
    _collectionView1.scrollEnabled = NO;
    _collectionView1.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:_collectionView1];

    [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([ReconmendCollectionCell class])];
    [_collectionView1 registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([ReconmendCollectionCell class])];
    
    
    _custArr = [[NSMutableArray alloc]init];
    [_custArr addObject:_collectionView];
    if (self.specialEntryModel.special_entry_list.count > 4) {
        [_custArr addObject:_collectionView1];
        _collectionView.frame = CGRectMake(0, 0, ScreenWidth - 22, AdaptationWidth(182));
        _collectionView1.frame = CGRectMake(0, 0, ScreenWidth - 22, AdaptationWidth(182));
    }
    
    CGRect custRect = CGRectMake(11, AdaptationWidth(220), ScreenWidth - 22, AdaptationWidth(91));
    float animationInterval = 3.5;
    float animationDuration = 0.5;
    _customView = [SpecialTopView viewWithFrame1:custRect customVies:_custArr animationInterval:animationInterval animationDuration:animationDuration dataSource:nil updator:^(id sender, NSMutableArray *data, int index) {
        
    }];
    [headerView addSubview:_customView];
}

#pragma mark - 一一一一一 <* 尾视图创建 *> 一一一一一
- (UIView *)creatFooterView{
    if (self.dataSourceArr.count == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(272))];
        view.backgroundColor = [UIColor clearColor];
        
        UIImageView *image = [[UIImageView alloc]init];
        [image setImage:[UIImage imageNamed:@"notData1"]];
        [view addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view).offset(AdaptationWidth(24));
            make.left.mas_equalTo(view).offset(AdaptationWidth(24));
            make.width.mas_offset(AdaptationWidth(327));
        }];
        return view;
    }else {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 139)];
        view.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = [[UIButton alloc]init];
        [btn setCornerValue:AdaptationWidth(20)];

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
            make.top.mas_equalTo(view).offset(24);
            make.centerX.mas_equalTo(view);
            make.width.mas_equalTo(AdaptationWidth(144));
            make.height.mas_equalTo(AdaptationWidth(41));
        }];
        
        return view;
    }
    
}

#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.tableViewSectionArry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    RecommenTableViewSection row = [self.tableViewSectionArry[section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn] || self.loan_pro_list_row.integerValue == 0) {
                return 1;
            }
            return self.loan_pro_list.count;
        }
            break;
        case RecommenTableViewSectionSecond:
            return self.dataSourceArr.count;
            break;
            
        default:
            break;
    }
    return self.dataSourceArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommenTableViewSection row = [self.tableViewSectionArry[indexPath.section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                return AdaptationWidth(182);
            }
            if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
                return AdaptationWidth(182);
            }
            return  108;
        }
            break;
        case RecommenTableViewSectionSecond:{
            return 127;
        }
            break;
        default:
            break;
    }
    return 127;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    RecommenTableViewSection row = [self.tableViewSectionArry[section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                return 0.1;
            }
            if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
                return 0.1;
            }
        }
            break;
        default:
            break;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    RecommenTableViewSection row = [self.tableViewSectionArry[section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                return 0.1;
            }
            if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
                return 0.1;
            }
            if ([CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list_row.integerValue <= 3) {
                return 0.1;
            }
            return  AdaptationWidth(108);
        }
            break;
        default:
            break;
    }
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]init];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(view);
    }];
    
    RecommenTableViewSection row = [self.tableViewSectionArry[section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                return nil;
            }
            if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
                return nil;
            }
            
            [lab setText:@"数万额度，100%下款"];
            
        }
            break;
        case RecommenTableViewSectionSecond:
            if (!self.dataSourceArr.count) {
                [lab setText:@"暂无推荐，吃口土先"];
            }else{
                [lab setText:@"热门产品"];
            }
            break;
            
        default:
            break;
    }
    
    
    
    
     return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (![[UserInfo sharedInstance]isSignIn]) {
        return nil;
    }
    if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
        return nil;
    }
    if ([CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list_row.integerValue <= 3) {
        return nil;
    }
    RecommenTableViewSection row = [self.tableViewSectionArry[section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            UIView * Footerview = [[UIView alloc]init];
            Footerview.backgroundColor = [UIColor clearColor];
            UILabel *lab = [[UILabel alloc]init];
            [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
            [lab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(14)]];
            [Footerview addSubview:lab];
            
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(Footerview).offset(AdaptationWidth(16));
                make.centerX.mas_equalTo(Footerview);
               
            }];
            
            UIButton *btn = [[UIButton alloc]init];
            [btn setCornerValue:AdaptationWidth(20)];
            
            [btn setBackgroundColor:XColorWithRBBA(7, 137, 133, 0.08)];
            [btn setTitleColor:XColorWithRGB(7, 137, 133) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
            [btn setImage:[UIImage imageNamed:@"tinyEntreGreen"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"tinyEntreGreen"] forState:UIControlStateHighlighted];

            [btn sizeToFit];
            btn.titleLabel.backgroundColor = [UIColor clearColor];
            btn.imageView.backgroundColor = [UIColor clearColor];
            
            if (![CreditState creditStateWith:self.creditInfoModel]) {
                btn.tag = RecommendBtnOnClickCreditState;
                [lab setText:@"没有满意的产品？"];
                [btn setTitle:@"完善资料, 100%下款" forState:UIControlStateNormal];
               
            }else{
                btn.tag = RecommendBtnOnClickOther;
                [lab setText:@"没有满意的？还有更多100%下款产品!"];
                [btn setTitle:@"更多推荐" forState:UIControlStateNormal];
                
            }
            
            CGSize imageSize = btn.currentImage.size;
            CGSize titleSize = btn.titleLabel.intrinsicContentSize;
            btn.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width, 0, -(titleSize.width));
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
            
            [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [Footerview addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(16));
                make.centerX.mas_equalTo(Footerview);
                make.width.mas_equalTo(AdaptationWidth(108));
                make.height.mas_equalTo(AdaptationWidth(41));
            }];
             if (![CreditState creditStateWith:self.creditInfoModel]) {
                 [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                     make.width.mas_equalTo(AdaptationWidth(194));
                 }];
             }
           
            
            return Footerview;
        }
            break;
            default:
            break;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommenTableViewSection row = [self.tableViewSectionArry[indexPath.section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            if (![[UserInfo sharedInstance]isSignIn]) {//未登录。
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *raiderBtn = [[UIButton alloc]init];
//                raiderBtn.userInteractionEnabled  = NO;
                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制未登录卡片"] forState:UIControlStateNormal];
                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制未登录卡片点击态"] forState:UIControlStateHighlighted];
                [raiderBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:raiderBtn];
                
                [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
                
                
                
                UILabel *btnTitleLab = [[UILabel alloc]init];
                btnTitleLab.textAlignment = NSTextAlignmentLeft;
                btnTitleLab.text = @"100%下款";
                [btnTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(19)]];
                [btnTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
                [raiderBtn addSubview:btnTitleLab];
                
                UIView *btnSubTitleLabBgView = [[UIView alloc]init];
                [raiderBtn addSubview:btnSubTitleLabBgView];
                
                UILabel *btnSubTitleLab = [[UILabel alloc]init];
                btnSubTitleLab.text = @"登录获得一定能贷的产品";
                [btnSubTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(13)]];
                [btnSubTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.64)];
                [btnSubTitleLabBgView addSubview:btnSubTitleLab];
                
                UILabel *levelLab = [[UILabel alloc]init];
                [levelLab setCornerValue:2];
                levelLab.textAlignment = NSTextAlignmentCenter;
                levelLab.text = [NSString stringWithFormat:@"去下款"];
                [levelLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(13)]];
                [levelLab setTextColor:XColorWithRBBA(255, 255, 255, 1)];
                [levelLab setBackgroundColor:XColorWithRBBA(252, 93, 109, 1)];
                [raiderBtn addSubview:levelLab];
                
                
                [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(180));
                    make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(40));
                    make.height.mas_equalTo(AdaptationWidth(26));
                }];
                [btnSubTitleLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(180));
                    make.top.mas_equalTo(btnTitleLab.mas_bottom).offset(AdaptationWidth(6));
                    make.height.mas_equalTo(AdaptationWidth(18));
                }];
                [btnSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.bottom.mas_equalTo(btnSubTitleLabBgView);
                }];
                [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(180));
                    make.top.mas_equalTo(btnSubTitleLabBgView.mas_bottom).offset(AdaptationWidth(12));
                    make.width.mas_equalTo(AdaptationWidth(72));
                    make.height.mas_equalTo(AdaptationWidth(28));
                }];
                return cell;
            }
            if (self.loan_pro_list.count == 0) {//5项资料未填写完整，无推荐产品时显示
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *raiderBtn = [[UIButton alloc]init];
//                raiderBtn.userInteractionEnabled  = NO;
                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"等级太低卡片"] forState:UIControlStateNormal];
                [raiderBtn setBackgroundImage:[UIImage imageNamed:@"等级太低卡片点击态"] forState:UIControlStateHighlighted];
                [raiderBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:raiderBtn];
                
                [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(cell);
                }];
        
                UILabel *btnTitleLab = [[UILabel alloc]init];
                btnTitleLab.textAlignment = NSTextAlignmentLeft;
                btnTitleLab.text = @"仅需一步, 100%下款";
                btnTitleLab.numberOfLines = 1;
                [btnTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(18)]];
                [btnTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
                [raiderBtn addSubview:btnTitleLab];
                
                UILabel *levelLab = [[UILabel alloc]init];
                [levelLab setCornerValue:2];
                levelLab.textAlignment = NSTextAlignmentCenter;
                levelLab.text = [NSString stringWithFormat:@"去下款"];
                [levelLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(13)]];
                [levelLab setTextColor:XColorWithRBBA(255, 255, 255, 1)];
                [levelLab setBackgroundColor:XColorWithRBBA(252, 93, 109, 1)];
                [raiderBtn addSubview:levelLab];
        
                [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(AdaptationWidth(28));
                    make.top.mas_equalTo(cell).offset(AdaptationWidth(53));
                }];
                
                [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell).offset(AdaptationWidth(28));
                    make.top.mas_equalTo(btnTitleLab.mas_bottom).offset(AdaptationWidth(16));
                    make.width.mas_equalTo(AdaptationWidth(72));
                    make.height.mas_equalTo(AdaptationWidth(28));
                }];
                
                return cell;
            }
            static NSString *identifier = @"RecommendTableViewCellSecond";
            RecommendTableViewSecond *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"RecommendTableViewCellSecond" owner:nil options:nil].lastObject;
            }
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
            cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
            
            ProductModel *model =[ProductModel mj_objectWithKeyValues:self.loan_pro_list[indexPath.row]] ;
            cell.model = model;
            switch (indexPath.row) {
                case 0:{
                    NSString *rateStr;
                    switch ([model.loan_rate_type integerValue]) {
                        case 1:
                            rateStr = @"参考日利率:";
                            break;
                        case 2:
                            rateStr = @"参考月利率:";
                            break;
                        case 3:
                            rateStr = @"参考年利率:";
                            break;
                            
                        default:
                            break;
                    }
                    if (model.loan_year_rate.intValue > 36) {
                        [cell.cellInfo setText:[NSString stringWithFormat:@"浮动利率"]];
                        cell.cellInfo.hidden = YES;
                    }else{
                        
                        if ([model.min_loan_rate isEqualToString:model.loan_rate]) {
                            if (model.loan_rate.length > 5) {
                                NSString *substring = [model.loan_rate substringToIndex:5];
                                [cell.cellInfo setText:[NSString stringWithFormat:@"%@%@%%",rateStr,substring]];
                            }else{
                                [cell.cellInfo setText:[NSString stringWithFormat:@"%@%@%%",rateStr,model.loan_rate]];
                            }
                            
                        }else{
                            [cell.cellInfo setText:[NSString stringWithFormat:@"%@%@%%~%@%%",rateStr,model.min_loan_rate,model.loan_rate]];
                        }
                    }
                }
                    break;
                case 1:
                case 2:
                    cell.cellInfo.text = model.recommend_desc;
                    break;
                    
                default:
                    break;
            }
            return cell;
            
            
        }
            break;
        case RecommenTableViewSectionSecond:{
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
            break;
        default:
            break;
    }
    
    return nil;
}
-(void)buttonAction{
    if(![[UserInfo sharedInstance]isSignIn] ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
    if (![CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
        [CreditState selectCreaditState:self with:self.creditInfoModel];
        return;
    }
}

#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    RecommenTableViewSection row = [self.tableViewSectionArry[indexPath.section]integerValue];
    switch (row) {
        case RecommenTableViewSectionOne:{
            
            ProductDetailVC *vc = [[ProductDetailVC alloc]init];
            vc.loan_pro_id = self.loan_pro_list[indexPath.row][@"loan_pro_id"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RecommenTableViewSectionSecond:{
            
            //是否名额已满
            NSInteger index = [self.dataSourceArr[indexPath.row][@"apply_is_full"]integerValue];
            if (index == 1) {
                [self setHudWithName:@"名额已满" Time:0.5 andType:3];
                return;
            }
            
            ProductDetailVC *vc = [[ProductDetailVC alloc]init];
            vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark - sdcycscrollview delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    NSInteger login = [self.clientGlobalInfoModel.banner_ad_list[index][@"is_need_login"]integerValue];
    if (login) {
        if(![[UserInfo sharedInstance]isSignIn]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getBlackLogin:self];//判断是否登录状态
            });
            return;
        }
    }

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

#pragma mark - 一一一一一 <* 按钮点击事件 *> 一一一一一
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case RecommendBtnOnClickAllDK:{    // 全部贷款产品
            AllDKViewController *VC = [[AllDKViewController alloc]init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }
             break;
        case RecommendBtnOnClickUnlogin:{  // 未登录
            LoginVC *vc = [[LoginVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RecommendBtnOnClickComplete:{   // 完善资料
            self.tabBarController.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case RecommendBtnOnClickCustomization:{   // 跳转申请人资质
            ApplicantManVC *vc = [[ApplicantManVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case RecommendBtnOnClickLocation:{ // 定位
            CABasicAnimation *rotationAnimation;
            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
            rotationAnimation.duration = 0.7;
            rotationAnimation.repeatCount = 3;
            [self.refreshView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
            [[UserLocation sharedInstance]UserLocation];
        }
            break;
        case RecommendBtnOnClickCreditState:{//去认证
            [CreditState selectCreaditState:self with:self.creditInfoModel];
        }
            break;
        case RecommendBtnOnClickOther:{//更多推荐
            [CreditState selectCreaditState:self with:nil];
        }
            break;
        default:
            break;
    }
}

- (void)btnOnTopClick:(RecommentTopBtn *)btn{
   
    switch (btn.tag) {
        case 200:{
            AllDKViewController *vc = [[AllDKViewController alloc]init];
            vc.loan_product_type = @0;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 201:{
            if(![[UserInfo sharedInstance]isSignIn]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
                [TalkingData trackEvent:@"【信用助手】页"];
                XRootWebVC *vc = [[XRootWebVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.url = self.clientGlobalInfoModel.wap_url_list.credit_url;
                [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 202:{
            if(![[UserInfo sharedInstance]isSignIn]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
            ReportController *vc = [[ReportController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } 
            break;
            
        default:
            break;
    }
}
#pragma mark - 一一一一一 <* UICollectionViewDataSource *> 一一一一一
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return self.specialEntryModel.special_entry_list.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReconmendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReconmendCollectionCell class]) forIndexPath:indexPath];
    [cell configureWith:self.specialEntryModel indexPath:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *indx2 = self.specialEntryModel.special_entry_list[indexPath.row][@"is_need_login"];
    if(![[UserInfo sharedInstance]isSignIn] && indx2.integerValue == 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [TalkingData trackEvent:@"【特色入口】页"];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        {
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
            break;
        default:
            break;
    }
}
// 选中高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self fixSlitWith:self.collectionView1.bounds colCount:4 space:AdaptationWidth(0.01)], AdaptationWidth(91));
}
- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;                  // 总共留出的距离
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;// 按照真实屏幕算出的cell宽度 （iPhone6 375*667）
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale;           // (1px=0.5pt,6Plus为3px=1pt)
    CGFloat realItemWidth = floor(itemWidth) + fixValue;// 取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    if (realItemWidth < itemWidth) {                    // 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    CGFloat realWidth = colCount * realItemWidth + totalSpace;// 算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    CGFloat pointX = (realWidth - rect.size.width) / 2;      // 偏移距离
    rect.origin.x = -pointX;//向左偏移
    rect.size.width = realWidth;
    return (rect.size.width - totalSpace) / colCount;        // 每个cell的真实宽度
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case RecommenRequestCreditInfo:{
            self.cmd = XGetCreditInfo;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case RecommenRequestHotInfo:
            self.cmd = XGetHotLoanProList;
            self.dict = [self.query_param mj_keyValues];
            break;
        case RecommenRequestClickLogRecord:{
            self.cmd = XAdClickLogRecord;
            self.dict = @{@"ad_id":ad_id};
        }
            break;
        case RecommenRequestSpecialEntry:{
            self.cmd = XGetSpecialEntryList;
            if (self.specialEntryModel.md5_hash.length) {
                self.dict = @{@"md5_hash":self.specialEntryModel.md5_hash};
            }else{
                self.dict = @{@"md5_hash":@""};
            }
        }
            break;
        case RecommenRequestSpecialInfo:{
            self.cmd = XGetSpecialLoanProList;
            if ([CreditState creditStateWith:self.creditInfoModel]) {
                self.dict =@{@"query_type":@1};
            }else{
                self.dict =@{@"query_type":@2};
            }
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case RecommenRequestCreditInfo:{
            [[CreditInfoModel sharedInstance]saveCreditStateInfo:[CreditInfoModel mj_objectWithKeyValues:response.content]];

            if ([CreditState creditStateWith:self.creditInfoModel] && self.loan_pro_list.count == 0) {
                [self.tableViewSectionArry removeObject:@(RecommenTableViewSectionOne)];
            }
            [self.tableView reloadData];
        }
            break;
        case RecommenRequestHotInfo:{
            self.dataSourceArr = response.content[@"loan_pro_list"];
            self.tableView.tableFooterView = [self creatFooterView];
            
            [self.tableViewSectionArry removeAllObjects];
            [self.tableViewSectionArry addObject:@(RecommenTableViewSectionOne)];
            [self.tableViewSectionArry addObject:@(RecommenTableViewSectionSecond)];
            if ([[UserInfo sharedInstance]isSignIn]) {
                [self prepareDataWithCount:RecommenRequestSpecialInfo];
                
                return;
            }
            [self.tableView reloadData];      
        }
            break;
        case RecommenRequestSpecialEntry:{
            if (![self.specialEntryModel.md5_hash isEqualToString:response.content[@"md5_hash"]]) {
                [[SpecialEntryModel sharedInstance]saveSpecialEntryModel:response.content];
                [self.collectionView reloadData];
            }
            [self prepareDataWithCount:RecommenRequestHotInfo];
        }
            break;
        case RecommenRequestSpecialInfo:{
            self.loan_pro_list_row = response.content[@"loan_pro_list_count"];
            self.loan_pro_list = response.content[@"loan_pro_list"];
            
            [self prepareDataWithCount:RecommenRequestCreditInfo];
            
        }
            
            break;
        default:
            break;
            
    }
}
-(void)requestFaildWithDictionary:(XResponse *)response{
    [super requestFaildWithDictionary:response];
    if (self.requestCount == RecommenRequestSpecialInfo) {
        self.loan_pro_list_row = nil;
        [self.loan_pro_list removeAllObjects];
       [self prepareDataWithCount:RecommenRequestCreditInfo];
    }
}

#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:RecommenRequestHotInfo];
}

#pragma mark - 懒加载
- (NSMutableArray *)tableViewSectionArry{
    if (!_tableViewSectionArry) {
        _tableViewSectionArry = [NSMutableArray array];
    }
    return _tableViewSectionArry;
}
-(NSMutableArray *)loan_pro_list{
    if (!_loan_pro_list) {
        _loan_pro_list = [NSMutableArray array];
    }
    return _loan_pro_list;
}
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
- (ProductModel *)specialproductModel{
    if (!_specialproductModel) {
        _specialproductModel = [[ProductModel alloc]init];
    }
    return _specialproductModel;
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
- (SpecialEntryModel *)specialEntryModel{
    if (!_specialEntryModel) {
        _specialEntryModel = [[SpecialEntryModel sharedInstance]getSpecialEntryModel];
    }
    return _specialEntryModel;
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel sharedInstance]getCreditStateInfo];
    }
    return _creditInfoModel;
}
#pragma mark - Tabbar 点击刷新
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([tabBarController.selectedViewController isEqual:viewController] && tabBarController.selectedIndex == self.index )  {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Recommend" object:nil];
    }
    self.index = tabBarController.selectedIndex;
    return YES;
}

-(void)dealloc{
    [WDNotificationCenter removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refresh" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Recommend" object:nil];
}

@end
