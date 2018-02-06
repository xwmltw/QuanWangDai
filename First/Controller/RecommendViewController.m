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



typedef NS_ENUM(NSInteger , RecommendBtnOnClick){
    RecommendBtnOnClickAllDK,
    RecommendBtnOnClickUnlogin,
    RecommendBtnOnClickComplete,
    RecommendBtnOnClickCustomization,
    RecommendBtnOnClickLocation,
};
typedef NS_ENUM(NSInteger , RecommenRequest) {
    RecommenRequestHotInfo,
    RecommenRequestClickLogRecord,
    RecommenRequestSpecialEntry,
    RecommenRequestSpecialInfo,
};
@interface RecommendViewController ()<SDCycleScrollViewDelegate,UITabBarControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIView *scrollbgView;        // 无列表数据
    UIView *scrollbgViewList;    // 有列表数据
    UIView *scrollbgViewUnlogin; // 未登录
    NSMutableArray *imageArry;   // banner图片源
    NSString *ad_id;             // banner点击日志
    UIView * view;               // 头视图View
}
@property (nonatomic, strong) QueryParamModel *query_param;
@property (nonatomic, strong) ProductModel *productModel;
@property (nonatomic, strong) ProductModel *specialproductModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) WapUrlList *wapUrlLisModel;
@property (nonatomic, strong) SpecialEntryModel *specialEntryModel;
@property (nonatomic, strong) SDCycleScrollView *sdcycleScrollView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIButton *locationbtn;
@property (nonatomic, strong) UIImageView *refreshView;
@property (nonatomic, strong) NSMutableArray *loan_pro_list;
@end

@implementation RecommendViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.delegate = self;
    
    /*!< 通知 >*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollAndLoad) name:@"Recommend" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"Refresh" object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(notificationLocation:) name:XLocationCityName object:nil];
    [WDNotificationCenter addObserver:self selector:@selector(ntificationAlert:) name:XNotificationAlert object:nil];
}

-(void)refresh{
    [self prepareDataWithCount:RecommenRequestHotInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"【推荐】页"];
    
    [self setData];
    [self prepareDataWithCount:RecommenRequestHotInfo];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(49);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(684))];

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
- (void)notificationLocation:(NSNotification *)notification{
    [_locationbtn setTitle:notification.object forState:UIControlStateNormal];
}
- (void)ntificationAlert:(NSNotification *)notification{
    XRootWebVC *vc = [[XRootWebVC alloc]init];
    vc.url = notification.object[@"url"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 一一一一一 <* 头视图创建 *> 一一一一一
- (UIView *)creatHeadView:(CGRect)rect{
    
    view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor clearColor];
    [view addSubview:topView];
    
/*!< 推荐 >*/
    UILabel *titleLab = [[UILabel alloc]init];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [titleLab setText:@"推荐"];
    [titleLab setTextColor:XColorWithRGB(77, 96, 114)];
    [topView addSubview:titleLab];
    
/*!< 定位 >*/
    _locationbtn = [[UIButton alloc]init];
    [_locationbtn setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [_locationbtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:16]];
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
    _locationbtn.titleEdgeInsets = UIEdgeInsetsMake(0, -AdaptationWidth(36), 0, AdaptationWidth(36));
    [_locationbtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_locationbtn];
    
    _refreshView = [[UIImageView alloc]init];
    _refreshView.image = [UIImage imageNamed:@"icon_refresh"];
    _refreshView.backgroundColor = [UIColor clearColor];
    _refreshView.layer.masksToBounds = YES;
    _refreshView.layer.cornerRadius = AdaptationWidth(14);
    _refreshView.userInteractionEnabled = NO;
    [_locationbtn addSubview:_refreshView];
    
/*!< 特色入口 >*/
    [self createCollectionView];
    
/*!< banner >*/
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
    _sdcycleScrollView.layer.cornerRadius = AdaptationWidth(2);
    _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
    [view addSubview:_sdcycleScrollView];
    if (imageArry.count == 0 ) {
        _sdcycleScrollView.hidden = YES;
    }
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(20));
        make.left.right.mas_equalTo(view);
        make.centerX.mas_equalTo(view);
        make.height.mas_equalTo(AdaptationWidth(98));
    }];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView).offset(AdaptationWidth(40));
        make.left.mas_equalTo(topView).offset(AdaptationWidth(16));
    }];
    [_locationbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView).offset(AdaptationWidth(50));
        make.right.mas_equalTo(topView).offset(-AdaptationWidth(16));
        make.left.mas_equalTo(titleLab.mas_right);
        make.height.mas_equalTo(22);
    }];
    [_refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_locationbtn).offset(-AdaptationWidth(3));
        make.right.mas_equalTo(_locationbtn);
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    [_sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_collectionView.mas_bottom).offset(AdaptationWidth(22));
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.width.mas_equalTo(AdaptationWidth(343));
        make.height.mas_equalTo(AdaptationWidth(84));
    }];
    return view;
}

#pragma mark - 一一一一一 <* 特色入口 *> 一一一一一
-(void)createCollectionView{
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = -1;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(11, AdaptationWidth(128), ScreenWidth - 22, AdaptationWidth(164)) collectionViewLayout:_flowLayout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delaysContentTouches = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [view addSubview:_collectionView];

    [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([ReconmendCollectionCell class])];
}

#pragma mark - 一一一一一 <* 尾视图创建 *> 一一一一一
- (UIView *)creatFooterView{
    if (!self.dataSourceArr.count) {
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
            make.width.mas_equalTo(AdaptationWidth(134));
            make.height.mas_equalTo(AdaptationWidth(41));
        }];
        
        return view;
    }
    
}

#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lab = [[UILabel alloc]init];
    if (!self.dataSourceArr.count) {
        [lab setText:@"暂无推荐，吃口土先"];
    }else{
        [lab setText:@"热门产品"];
    }
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(view);
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

#pragma mark - 一一一一一 <* UITableViewDelegate *> 一一一一一
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
        default:
            break;
    }
}

-(void)raiderBtnOnClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:{
            self.specialproductModel = [ProductModel mj_objectWithKeyValues:self.loan_pro_list[btn.tag]];
            ProductDetailVC *vc = [[ProductDetailVC alloc]init];
            vc.loan_pro_id = self.specialproductModel.loan_pro_id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:{
            PersonalTailorVC *vc = [PersonalTailorVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 一一一一一 <* UICollectionViewDataSource *> 一一一一一
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
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
    switch (indexPath.row) {
//        case 0:{
//            AllDKViewController *vc = [[AllDKViewController alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
//        case 1:{
//
//            XRootWebVC *vc = [[XRootWebVC alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.url = self.wapUrlLisModel.credit_url;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//            break;
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
                AllDKViewController *vc = [[AllDKViewController alloc]init];
                vc.titleStr = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_title"];
                vc.special_entry_id = self.specialEntryModel.special_entry_list[indexPath.row][@"special_entry_id"];
                vc.loan_product_type = self.specialEntryModel.special_entry_list[indexPath.row][@"loan_product_type"];
                vc.loan_classify_ids_str = self.specialEntryModel.special_entry_list[indexPath.row][@"loan_classify_ids_str"];
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
    
    return CGSizeMake([self fixSlitWith:self.collectionView.bounds colCount:4 space:AdaptationWidth(0.01)], AdaptationWidth(82));
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

#pragma mark - 一一一一一 <* 未登录 *> 一一一一一
-(void)userUnlogin{
    
    NSInteger btnNum = 1;
    NSArray *arr = @[@{@"artical_title":@"1111"}];
    NSMutableArray *raiderArry = [NSMutableArray arrayWithArray:arr];
    
    scrollbgViewUnlogin = [[UIView alloc]init];
    scrollbgViewUnlogin.backgroundColor = [UIColor clearColor];
    [view addSubview:scrollbgViewUnlogin];
    
    UILabel *personlab = [[UILabel alloc]init];
    [personlab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [personlab setText:@"私人定制"];
    [personlab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [scrollbgViewUnlogin addSubview:personlab];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.directionalLockEnabled = YES;
    scroll.scrollEnabled =YES;
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(btnNum * AdaptationWidth(358) + (btnNum +1)*AdaptationWidth(8) , AdaptationWidth(182));
    [scrollbgViewUnlogin addSubview:scroll];
    
    UIView *scrollcontentsizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height)];
    scrollcontentsizeView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:scrollcontentsizeView];
    
    [raiderArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        UIButton *raiderBtn = [[UIButton alloc]init];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制card"] forState:UIControlStateNormal];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制card-2"] forState:UIControlStateHighlighted];
        raiderBtn.tag = RecommendBtnOnClickUnlogin;
        [raiderBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:raiderBtn];
        
        [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollcontentsizeView).offset(AdaptationWidth(8)+ idx*(AdaptationWidth(359)) + idx * AdaptationWidth(8));
            make.top.mas_equalTo(scrollcontentsizeView);
            make.bottom.mas_equalTo(scrollcontentsizeView);
            make.width.mas_equalTo(AdaptationWidth(359));
        }];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = AdaptationWidth(12);
        imageView.backgroundColor = XColorWithRBBA(252, 93, 109, 1);
        [raiderBtn addSubview:imageView];
        
        UILabel *btnTitleLab = [[UILabel alloc]init];
        btnTitleLab.textAlignment = NSTextAlignmentLeft;
        btnTitleLab.text = @"您还未登录";
        [btnTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(19)]];
        [btnTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [raiderBtn addSubview:btnTitleLab];
        
        UIView *btnSubTitleLabBgView = [[UIView alloc]init];
        //        btnSubTitleLabBgView.backgroundColor = XColorWithRBBA(255, 242, 244, 1);
        //        [btnSubTitleLabBgView setCornerValue:AdaptationWidth(2)];
        [raiderBtn addSubview:btnSubTitleLabBgView];
        
        UILabel *btnSubTitleLab = [[UILabel alloc]init];
        btnSubTitleLab.text = @"小贷无法为您定制产品哦";
        [btnSubTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [btnSubTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
        [btnSubTitleLabBgView addSubview:btnSubTitleLab];
        
        UILabel *levelLab = [[UILabel alloc]init];
        levelLab.textAlignment = NSTextAlignmentLeft;
        levelLab.numberOfLines = 2;
        levelLab.text = [NSString stringWithFormat:@"戳我\n登录"];
        [levelLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(13)]];
        [levelLab setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [raiderBtn addSubview:levelLab];
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(32));
            make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(42));
            make.width.height.mas_equalTo(AdaptationWidth(64));
        }];
        [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
            make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(24));
            make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(49));
            make.height.mas_equalTo(AdaptationWidth(28));
        }];
        [btnSubTitleLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
            make.top.mas_equalTo(btnTitleLab.mas_bottom).offset(AdaptationWidth(4));
            make.height.mas_equalTo(AdaptationWidth(22));
        }];
        [btnSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnSubTitleLabBgView);
            make.right.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(2));
            make.top.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(2));
            make.bottom.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(2));
        }];
        [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView).offset(AdaptationWidth(18));
            make.top.mas_equalTo(imageView).offset(AdaptationWidth(12));
            make.width.mas_equalTo(AdaptationWidth(28));
            make.height.mas_equalTo(AdaptationWidth(40));
        }];
    }];
    if (imageArry.count == 0 ) {
        [scrollbgViewUnlogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_collectionView.mas_bottom).offset(AdaptationWidth(10));
            make.bottom.mas_equalTo(view);
        }];
    }else{
        [scrollbgViewUnlogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_sdcycleScrollView.mas_bottom).offset(AdaptationWidth(12));
            make.bottom.mas_equalTo(view);
        }];
    }
    [personlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollbgViewUnlogin).offset(AdaptationWidth(16));
        make.left.mas_equalTo(scrollbgViewUnlogin).offset(AdaptationWidth(16));
    }];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollbgViewUnlogin);
        make.right.mas_equalTo(scrollbgViewUnlogin);
        make.top.mas_equalTo(scrollbgViewUnlogin).offset(AdaptationWidth(60));
        make.bottom.mas_equalTo(scrollbgViewUnlogin);
    }];
}
#pragma mark - 一一一一一 <* 私人定制 无数据 *> 一一一一一
-(void)customizeWithNoData:(NSString *)message{
    
    NSInteger btnNum = 1;
    NSArray *arr = @[@{@"artical_title":@"1111"}];
    NSMutableArray *raiderArry = [NSMutableArray arrayWithArray:arr];
    
    scrollbgView = [[UIView alloc]init];
    scrollbgView.backgroundColor = [UIColor clearColor];
    [view addSubview:scrollbgView];
    
    UILabel *personlab = [[UILabel alloc]init];
    [personlab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [personlab setText:@"私人定制"];
    [personlab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [scrollbgView addSubview:personlab];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.directionalLockEnabled = YES;
    scroll.scrollEnabled =YES;
    scroll.bounces = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(btnNum * AdaptationWidth(358) + (btnNum +1)*AdaptationWidth(8) , AdaptationWidth(182));
    [scrollbgView addSubview:scroll];
    
    UIView *scrollcontentsizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height)];
    scrollcontentsizeView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:scrollcontentsizeView];
    
    [raiderArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        UIButton *raiderBtn = [[UIButton alloc]init];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制card"] forState:UIControlStateNormal];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"定制card-2"] forState:UIControlStateHighlighted];
        if ([message isEqualToString:@"D"] || [message isEqualToString:@"E"]  ) {
            raiderBtn.tag = RecommendBtnOnClickComplete;
        }else{
            raiderBtn.tag = RecommendBtnOnClickCustomization;
        }
        [raiderBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:raiderBtn];
        
        [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollcontentsizeView).offset(AdaptationWidth(8)+ idx*(AdaptationWidth(359)) + idx * AdaptationWidth(8));
            make.top.mas_equalTo(scrollcontentsizeView);
            make.bottom.mas_equalTo(scrollcontentsizeView);
            make.width.mas_equalTo(AdaptationWidth(359));
        }];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = AdaptationWidth(12);
        imageView.backgroundColor = XColorWithRBBA(252, 93, 109, 1);
        [raiderBtn addSubview:imageView];
        
        UILabel *btnTitleLab = [[UILabel alloc]init];
        btnTitleLab.textAlignment = NSTextAlignmentLeft;
        if ([message isEqualToString:@"D"] || [message isEqualToString:@"E"]  ) {
            btnTitleLab.text = @"等级太低, 无法为您推荐";
        }else{
            btnTitleLab.text = @"找合适的产品太难？";
        }
        [btnTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(19)]];
        [btnTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [raiderBtn addSubview:btnTitleLab];
        
        UIView *btnSubTitleLabBgView = [[UIView alloc]init];
        btnSubTitleLabBgView.backgroundColor = XColorWithRBBA(255, 242, 244, 1);
        [btnSubTitleLabBgView setCornerValue:AdaptationWidth(2)];
        [raiderBtn addSubview:btnSubTitleLabBgView];
        
        UILabel *btnSubTitleLab = [[UILabel alloc]init];
        if ([message isEqualToString:@"D"] || [message isEqualToString:@"E"]  ) {
            btnSubTitleLabBgView.backgroundColor = [UIColor clearColor];
            btnSubTitleLab.text = @"戳我提升等级，获得定制推荐";
            [btnSubTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
        }else{
            btnSubTitleLab.text = @"试试一键定制";
            [btnSubTitleLab setTextColor:XColorWithRBBA(252, 93, 109, 1)];
        }
        [btnSubTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [btnSubTitleLabBgView addSubview:btnSubTitleLab];
        
        UILabel *levelLab = [[UILabel alloc]init];
        levelLab.textAlignment = NSTextAlignmentLeft;
        levelLab.text = [NSString stringWithFormat:@"信用等级"];
        [levelLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(12)]];
        [levelLab setTextColor:XColorWithRBBA(255, 255, 255, 1)];
        [raiderBtn addSubview:levelLab];
        
        UILabel *level = [[UILabel alloc]init];
        [level setFont:[UIFont fontWithName:@"iconfont" size:AdaptationWidth(26)]];
        [level setTextColor:[UIColor whiteColor]];
        if ([message isEqualToString:@"E"]) {
            level.text =  @"\U0000e60c";
        }
        if ([message isEqualToString:@"D"]) {
            level.text =@"\U0000e60f";
        }
        if ([message isEqualToString:@"C"]) {
            level.text =@"\U0000e60e";
        }
        if ([message isEqualToString:@"B"]) {
            level.text =@"\U0000e60d";
        }
        [raiderBtn addSubview:level];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(32));
            make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(48));
            make.width.height.mas_equalTo(AdaptationWidth(64));
        }];
        [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
            make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(24));
            make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(50));
            make.height.mas_equalTo(AdaptationWidth(30));
        }];
        [btnSubTitleLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
            make.top.mas_equalTo(btnTitleLab.mas_bottom).offset(AdaptationWidth(4));
            make.height.mas_equalTo(AdaptationWidth(26));
        }];
        if ([message isEqualToString:@"D"] || [message isEqualToString:@"E"]  ) {
            [btnSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(btnSubTitleLabBgView);
                make.right.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
                make.top.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(4));
                make.bottom.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
            }];
        }else{
            [btnSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(4));
                make.right.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
                make.top.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(4));
                make.bottom.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
            }];
        }
        
        [levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView).offset(AdaptationWidth(7));
            make.top.mas_equalTo(imageView).offset(AdaptationWidth(8));
            make.height.mas_equalTo(AdaptationWidth(17));
        }];
        [level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView).offset(AdaptationWidth(19));
            make.top.mas_equalTo(imageView).offset(AdaptationWidth(30));
//            make.height.mas_equalTo(AdaptationWidth(25));
//            make.width.mas_equalTo(AdaptationWidth(25));
        }];
    }];
    if (imageArry.count == 0 ) {
        [scrollbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_collectionView.mas_bottom).offset(AdaptationWidth(10));
            make.bottom.mas_equalTo(view);
        }];
    }else{
        [scrollbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_sdcycleScrollView.mas_bottom).offset(AdaptationWidth(12));
            make.bottom.mas_equalTo(view);
        }];
    }
    [personlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollbgView).offset(AdaptationWidth(16));
        make.left.mas_equalTo(scrollbgView).offset(AdaptationWidth(16));
    }];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollbgView);
        make.right.mas_equalTo(scrollbgView);
        make.top.mas_equalTo(scrollbgView).offset(AdaptationWidth(60));
        make.bottom.mas_equalTo(scrollbgView);
    }];
}
#pragma mark - 一一一一一 <* 私人定制 有数据 *> 一一一一一
-(void)customize:(NSNumber *)count with:(NSMutableArray *)list{
    NSInteger btnNum = count.integerValue;
    NSMutableArray *raiderArry = [NSMutableArray arrayWithArray:list];
    if (btnNum > 3) {
        [raiderArry addObject:@{@"":@""}];
    }
    scrollbgViewList = [[UIView alloc]init];
    scrollbgViewList.backgroundColor = [UIColor clearColor];
    [view addSubview:scrollbgViewList];
    
    UILabel *personlab = [[UILabel alloc]init];
    [personlab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
    [personlab setText:@"私人定制"];
    [personlab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [scrollbgViewList addSubview:personlab];
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.directionalLockEnabled = YES;
    scroll.scrollEnabled =YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(btnNum * AdaptationWidth(259) + (btnNum +1)*AdaptationWidth(8) , AdaptationWidth(208));
    [scrollbgViewList addSubview:scroll];
    
    UIView *scrollcontentsizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height)];
    scrollcontentsizeView.backgroundColor = [UIColor clearColor];
    [scroll addSubview:scrollcontentsizeView];
    
    [raiderArry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
        
        UIButton *raiderBtn = [[UIButton alloc]init];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"card"] forState:UIControlStateNormal];
        [raiderBtn setBackgroundImage:[UIImage imageNamed:@"card_p"] forState:UIControlStateHighlighted];
        raiderBtn.tag = idx;
        [raiderBtn addTarget:self action:@selector(raiderBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:raiderBtn];
        
        [raiderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scrollcontentsizeView).offset(AdaptationWidth(8)+ idx*(AdaptationWidth(259)) + idx * AdaptationWidth(8));
            make.top.mas_equalTo(scrollcontentsizeView);
            make.bottom.mas_equalTo(scrollcontentsizeView);
            make.width.mas_equalTo(AdaptationWidth(259));
        }];
        if (idx < 3) {
            self.specialproductModel = [ProductModel mj_objectWithKeyValues:list[idx]];
            UIImageView *topimageView = [[UIImageView alloc]init];
            switch (idx) {
                case 0:
                    topimageView.image = [UIImage imageNamed:@"第一"];
                    break;
                case 1:
                    topimageView.image = [UIImage imageNamed:@"第二"];
                    break;
                case 2:
                    topimageView.image = [UIImage imageNamed:@"第三"];
                    break;
                    
                default:
                    break;
            }
            [raiderBtn addSubview:topimageView];
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.layer.masksToBounds = YES;
            NSURL *imageUrl = [NSURL URLWithString:self.specialproductModel.loan_pro_logo_url];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
            imageView.image = image;
            imageView.layer.cornerRadius = AdaptationWidth(16);
            imageView.backgroundColor = XColorWithRGB(255, 242, 244);
            [raiderBtn addSubview:imageView];
            
            UILabel *btnTitleLab = [[UILabel alloc]init];
            btnTitleLab.textAlignment = NSTextAlignmentLeft;
            btnTitleLab.text = self.specialproductModel.loan_pro_name;
            [btnTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
            [btnTitleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
            [raiderBtn addSubview:btnTitleLab];
            
            
            if (self.specialproductModel.recommend_desc.length) {
                UIView *btnSubTitleLabBgView = [[UIView alloc]init];
                switch (idx) {
                    case 0:
                        btnSubTitleLabBgView.backgroundColor = XColorWithRBBA(255, 242, 244, 1);
                        break;
                    case 1:
                        btnSubTitleLabBgView.backgroundColor = XColorWithRBBA(236, 246, 246, 1);
                        break;
                    case 2:
                        btnSubTitleLabBgView.backgroundColor = XColorWithRBBA(253, 244, 232, 1);
                        break;
                        
                    default:
                        break;
                }
                [btnSubTitleLabBgView setCornerValue:AdaptationWidth(2)];
                [raiderBtn addSubview:btnSubTitleLabBgView];
                
                UILabel *btnSubTitleLab = [[UILabel alloc]init];
                btnSubTitleLab.text = [NSString stringWithFormat: @"%@",self.specialproductModel.recommend_desc];
                [btnSubTitleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
                switch (idx) {
                    case 0:
                        [btnSubTitleLab setTextColor:XColorWithRBBA(252, 93, 109, 1)];
                        break;
                    case 1:
                        [btnSubTitleLab setTextColor:XColorWithRBBA(7, 137, 133, 1)];
                        break;
                    case 2:
                        [btnSubTitleLab setTextColor:XColorWithRBBA(255, 176, 53, 1)];
                        break;
                        
                    default:
                        break;
                }
                [btnSubTitleLabBgView addSubview:btnSubTitleLab];
                
                [btnSubTitleLabBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
                    make.top.mas_equalTo(btnTitleLab.mas_bottom).offset(AdaptationWidth(4));
                    make.height.mas_equalTo(AdaptationWidth(26));
                }];
                [btnSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(4));
                    make.right.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
                    make.top.mas_equalTo(btnSubTitleLabBgView).offset(AdaptationWidth(4));
                    make.bottom.mas_equalTo(btnSubTitleLabBgView).offset(-AdaptationWidth(4));
                }];
                
                [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
                    make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(24));
                    make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(50));
                    make.height.mas_equalTo(AdaptationWidth(30));
                }];
            }else{
                [btnTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(imageView.mas_right).offset(AdaptationWidth(16));
                    make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(24));
                    make.centerY.mas_equalTo(imageView);
                    make.height.mas_equalTo(AdaptationWidth(30));
                }];
            }
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = XColorWithRGB(233, 233, 235);
            [raiderBtn addSubview:line];
            
            UILabel *moneyLab = [[UILabel alloc]init];
            moneyLab.textAlignment = NSTextAlignmentLeft;
            
            moneyLab.text = [NSString stringWithFormat:@"可贷额度 (元)：%@",self.specialproductModel.loan_credit_str];
            [moneyLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
            [moneyLab setTextColor:XColorWithRBBA(34, 58, 80, 0.48)];
            [raiderBtn addSubview:moneyLab];
            
            [topimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(20));
                make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(7));
                make.height.mas_equalTo(AdaptationWidth(42));
                make.width.mas_equalTo(AdaptationWidth(32));
            }];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(24));
                make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(48));
                make.width.height.mas_equalTo(AdaptationWidth(64));
            }];
            


            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(8));
                make.right.mas_equalTo(raiderBtn).offset(-AdaptationWidth(8));
                make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(136));
                make.height.mas_equalTo(0.5);
            }];
            [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(24));
                make.top.mas_equalTo(line).offset(AdaptationWidth(16));
                make.height.mas_equalTo(AdaptationWidth(21));
            }];
        }else{
            UILabel *moreLab = [[UILabel alloc]init];
            moreLab.textAlignment = NSTextAlignmentCenter;
            moreLab.text = @"查看更多";
            [moreLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(20)]];
            [moreLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
            [raiderBtn addSubview:moreLab];
            
            [moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(raiderBtn).offset(AdaptationWidth(86));
                make.top.mas_equalTo(raiderBtn).offset(AdaptationWidth(84));
                make.height.mas_equalTo(AdaptationWidth(30));
                make.width.mas_equalTo(AdaptationWidth(100));
            }];
        }
    }];
    if (imageArry.count == 0 ) {
        [scrollbgViewList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_collectionView.mas_bottom).offset(AdaptationWidth(10));
            make.bottom.mas_equalTo(view);
        }];
    }else{
        [scrollbgViewList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(view);
            make.top.mas_equalTo(_sdcycleScrollView.mas_bottom).offset(AdaptationWidth(12));
            make.bottom.mas_equalTo(view);
        }];
    }
    [personlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollbgViewList).offset(AdaptationWidth(16));
        make.left.mas_equalTo(scrollbgViewList).offset(AdaptationWidth(16));
    }];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollbgViewList);
        make.right.mas_equalTo(scrollbgViewList);
        make.top.mas_equalTo(scrollbgViewList).offset(AdaptationWidth(60));
        make.bottom.mas_equalTo(scrollbgViewList);
    }];
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
            self.dict = @{};
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
            [self prepareDataWithCount:RecommenRequestSpecialEntry];
        }
            break;
        case RecommenRequestSpecialEntry:{
            if (![self.specialEntryModel.md5_hash isEqualToString:response.content[@"md5_hash"]]) {
                [[SpecialEntryModel sharedInstance]saveSpecialEntryModel:response.content];
                [self.collectionView reloadData];
            }
            [self prepareDataWithCount:RecommenRequestSpecialInfo];
            
        }
            break;
        case RecommenRequestSpecialInfo:{
            self.loan_pro_list = response.content[@"loan_pro_list"];
            /*!< 无banner >*/
            if (imageArry.count == 0 ) {
                if (![[UserInfo sharedInstance]isSignIn]) {
                    /*!< 未登录 >*/
                    self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(548))];
                }else{
                    /*!< 登录 >*/
                    if (self.loan_pro_list.count != 0) {
                        /*!< 有推荐数据 >*/
                        self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(574))];
                    }else{
                        /*!< 无推荐数据 >*/
                        self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(302))];
                    }
                }
            }else{
                if (self.loan_pro_list.count == 0 ) {
                    [scrollbgViewList removeFromSuperview];
                    self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(418))];
                }else{
                    self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(684))];
                }
            }
            if(![[UserInfo sharedInstance]isSignIn]){
                if (scrollbgViewUnlogin == nil) {
                    [scrollbgViewList removeFromSuperview];
                    [scrollbgView removeFromSuperview];
                    [self userUnlogin];
                }else{
                    [scrollbgViewUnlogin removeFromSuperview];
                    [self userUnlogin];
                }
            }else if(self.loan_pro_list.count != 0){
                if (scrollbgViewList == nil) {
                    [scrollbgView removeFromSuperview];
                    [scrollbgViewUnlogin removeFromSuperview];
                    [self customize:response.content[@"loan_pro_list_count"] with:self.loan_pro_list];
                }else{
                    [scrollbgViewList removeFromSuperview];
                    [self customize:response.content[@"loan_pro_list_count"] with:self.loan_pro_list];
                }
            }
        }
            break;
        default:
            break;
    }
}
-(void)requestFaildWithDictionary:(XResponse *)response{
    /*!< 无banner >*/
    if (imageArry.count == 0 ) {
        self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(548))];
    }else{
        self.tableView.tableHeaderView = [self creatHeadView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(656))];
    }
    if(![[UserInfo sharedInstance]isSignIn]){
        if (scrollbgViewUnlogin == nil) {
            [scrollbgViewList removeFromSuperview];
            [scrollbgView removeFromSuperview];
            [self userUnlogin];
        }else{
            [scrollbgViewUnlogin removeFromSuperview];
            [self userUnlogin];
        }
    }else{
        if ([response.errCode.description isEqualToString:@"31"] || [response.errCode.description isEqualToString:@"34"]) {
            if (scrollbgView == nil) {
                [scrollbgViewList removeFromSuperview];
                [scrollbgViewUnlogin removeFromSuperview];
                [self customizeWithNoData:response.errMsg];
            }else{
                [scrollbgView removeFromSuperview];
                [self customizeWithNoData:response.errMsg];
            }
        }
   }
   
}

#pragma  mark - 刷新
- (void)headerRefresh{
    [self prepareDataWithCount:RecommenRequestHotInfo];
}

#pragma mark - 懒加载
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
