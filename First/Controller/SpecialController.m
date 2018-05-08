//
//  SpecialController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/4/23.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "SpecialController.h"
#import "JSDropDownMenu.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "ProductListModel.h"
#import "LoanTypeInfo.h"
#import "ReconmendCollectionCell.h"
#import "XRootWebVC.h"
#import "SpecailCollectionViewFlowLayout.h"
#import "SpecialDetailController.h"
#import <FLAnimatedImage.h>
#import "SpecailPageControl.h"
typedef NS_ENUM(NSInteger ,SpecialViewRequest) {
    SpecialViewRequestProductList,
    SpecialViewRequestProductDetail,
    SpecialViewRequestProductType,
    SpecialViewRequestSpecialEntry,
};
@interface SpecialController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UIView * headerView;
}
@property (nonatomic ,strong) JSDropDownMenu *dropDownMenu;
@property (nonatomic ,strong) ProductListModel *productListModel;
@property (nonatomic ,strong) QueryParamModel *queryParamModel;
@property (nonatomic ,strong) RecommendTableViewCell *cell;
@property (nonatomic ,strong) JSIndexPath *jsIndexPath;
@property (nonatomic ,strong) LoanTypeInfo *loanTypeInfo;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) SpecailCollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) SpecailPageControl *pageCtr;;
@end

@implementation SpecialController
{
    NSMutableArray *typeArry,*quotaArry,*dateArry,*sortArry,*titleArry;
    NSArray *specialArry;
    BOOL tpyeSelect,quotaSelect,dataSelect,sortSelect;
}
- (void)viewWillAppear:(BOOL)animated{
    if (self.typeIndex == 3 || self.typeIndex == 4) {
        self.productListModel.loan_pro_type = @(self.typeIndex);
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self.dataSourceArr removeAllObjects];
    self.queryParamModel.page_num = @(1);
    [self prepareDataWithCount:SpecialViewRequestProductType];
    
    [self createTableViewWithFrame:CGRectZero];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer.hidden = NO;
}
-(void)createTableViewWithFrame:(CGRect )frame{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = XColorWithRGB(255, 255, 255);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    /***
     在iOS11中如果不实现 -tableView: viewForHeaderInSection:和-tableView: viewForFooterInSection: ，则-tableView: heightForHeaderInSection:和- tableView: heightForFooterInSection:不会被调用，导致它们都变成了默认高度，这是因为tableView在iOS11默认使用Self-Sizing，tableView的estimatedRowHeight、estimatedSectionHeaderHeight、 estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension,就是实现对应方法或把这三个属性设为0。
     ***/
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(ScreenWidth/2-20, 20, 40.0, 40.0);
    [header addSubview:imageView];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_footer.hidden = YES;
    [self.view addSubview:self.tableView];
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
- (void)setData{
    typeArry = [NSMutableArray array];
    if (self.loan_product_type.integerValue) {//特色入口贷款类型id
        
        if (self.loan_classify_ids_str.length > 1) {
            
             specialArry = [self.loan_classify_ids_str componentsSeparatedByString:@","];
            if (specialArry.count > 1) {
                
                [self.loanTypeInfo.loan_classify_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    for (int i = 0; specialArry.count > i; i++) {
                        if ([specialArry[i] isEqualToString:[NSString stringWithFormat:@"%@",obj[@"loan_classify_id"]]]) {
                            
                            [typeArry addObject:obj];
                        }
                    }
                }];
            }
            
        }else{
            if (self.list_properties.integerValue != 1) {
                    //   全部类型
                typeArry  = [NSMutableArray arrayWithArray:self.loanTypeInfo.loan_classify_list];
            } 
        }

    }else{
        if (self.list_properties.integerValue != 1) {
            //   全部类型
            typeArry  = [NSMutableArray arrayWithArray:self.loanTypeInfo.loan_classify_list];
        }
    }

    
    quotaArry = [NSMutableArray arrayWithObjects:@"不限",@"2000元以下",@"2001~5000元",@"5001~10000元",@"10001~50000元",@"50001元以上", nil];
    dateArry = [NSMutableArray arrayWithObjects:@"不限",@"1个月内",@"1~6个月",@"6~12个月",@"超过12个月", nil];
    sortArry = [NSMutableArray arrayWithObjects:@"默认排序",@"贷款利率", nil];
    
    if (typeArry.count < 1 ) {
//        self.tableView.tableHeaderView = nil;
    }else if(typeArry.count <= 4){
        self.tableView.tableHeaderView = [self creatHeaderView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(107))];
    }else{
        self.tableView.tableHeaderView = [self creatHeaderView:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(201))];
    }
    
}
#pragma mark - tableView Delegate
- (UIView *)creatFooterView{
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"暂无合适的产品"];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:lab];
    
    UILabel *lab2 = [[UILabel alloc]init];
    [lab2 setText:@"逛逛其他地方先，玩命补货中…"];
    [lab2 setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [lab2 setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [view addSubview:lab2];
    
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"allDK_notData"]];
    [view addSubview:image];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(view).offset(AdaptationWidth(64));
    }];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab.mas_bottom).offset(4);
    }];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(lab2.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(327));
        make.height.mas_equalTo(AdaptationWidth(161));
    }];
    return view;
}
-(UIView *)creatHeaderView:(CGRect)rect{
    headerView = [[UIView alloc]initWithFrame:rect];
    headerView.backgroundColor = [UIColor clearColor];
    
    _flowLayout = [[SpecailCollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = -1;
    _flowLayout.itemCountPerRow = 4;
    if(typeArry.count < 4){
        _flowLayout.rowCount = 1;
    }else{
        _flowLayout.rowCount = 2;
    }
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (typeArry.count <= 4) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 0, ScreenWidth - AdaptationWidth(32), AdaptationWidth(91)) collectionViewLayout:_flowLayout];
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:_collectionView];
        if (typeArry.count  <= 8) {
            for (NSInteger i = 0; i < 8 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }else if(typeArry.count  > 8 && typeArry.count <= 16 ){
            for (NSInteger i = 0; i < 16 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }else{
            for (NSInteger i = 0; i < 24 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }
    }else{
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, 0, ScreenWidth - AdaptationWidth(32), AdaptationWidth(182)) collectionViewLayout:_flowLayout];
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:_collectionView];
        if (typeArry.count  <= 8) {
            for (NSInteger i = 0; i < 8 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }else if(typeArry.count  > 8 && typeArry.count  <= 16 ){
            for (NSInteger i = 0; i < 16 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }else{
            for (NSInteger i = 0; i < 24 ; i++) {
                NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",i];
                [_collectionView registerClass:[ReconmendCollectionCell class] forCellWithReuseIdentifier:stringID];
            }
        }
        
        // 分页控制器
        _pageCtr = [[SpecailPageControl alloc] init];
        _pageCtr.hidesForSinglePage = YES;
        CGFloat a = (double)(typeArry.count ) / 8;
        _pageCtr.numberOfPages = ceilf(a);
        [_pageCtr setValue:[UIImage imageNamed:@"pageImage"] forKeyPath:@"_pageImage"];
        [_pageCtr setValue:[UIImage imageNamed:@"currentPageImage"] forKeyPath:@"_currentPageImage"];
        [headerView addSubview:_pageCtr];
        [_pageCtr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(headerView).offset(-AdaptationWidth(6));
            make.centerX.mas_equalTo(headerView);
            make.height.mas_equalTo(AdaptationWidth(4));
            make.width.mas_equalTo(AdaptationWidth(1));
        }];
    }
    
    return headerView;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isMemberOfClass:[UICollectionView class]]){

        if (scrollView.contentOffset.x < ScreenWidth - AdaptationWidth(32)) {
            _pageCtr.currentPage = 0;
        }else if (scrollView.contentOffset.x == ScreenWidth - AdaptationWidth(32)){
            
            _pageCtr.currentPage = 1;
            
        }else{
            _pageCtr.currentPage = 2;
        }
    }
}

#pragma mark - 一一一一一 <* UICollectionViewDataSource *> 一一一一一
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (typeArry.count  == 0) {
        return 0;
    }else if (typeArry.count <= 8) {
        return 8;
    }else if(typeArry.count > 8 && typeArry.count <= 16 ){
        return 16;
    }
    return 24;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     NSString * stringID = [NSString stringWithFormat:@"ReconmendCollectionCell%ld",indexPath.row];
    ReconmendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringID forIndexPath:indexPath];
    [cell SpecialconfigureWith:typeArry indexPath:indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (typeArry.count <= indexPath.row) {
        return;
    }
    [TalkingData trackEvent:[NSString stringWithFormat:@"特色入口】-贷款类型%ld",(long)indexPath.row]];
    SpecialDetailController *vc = [[SpecialDetailController alloc]init];
    vc.productListModel = self.productListModel;
    vc.productListModel.loan_classify_id =typeArry[indexPath.row][@"loan_classify_id"];
    vc.productListModel.special_entry_id = self.special_entry_id;
    vc.titleStr = typeArry[indexPath.row][@"loan_classify_name"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
// 选中高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self fixSlitWith:self.collectionView.bounds colCount:4 space:AdaptationWidth(0.01)], AdaptationWidth(91));
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


#pragma mark - 一一一一一 <* UITableViewDataSource *> 一一一一一
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    return self.dropDownMenu;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 127;
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
    [_cell setDetailColor:sortSelect quotaSelect:quotaSelect dataSelect:dataSelect];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if(![[UserInfo sharedInstance]isSignIn]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
    //是否名额已满
    NSInteger row = [self.dataSourceArr[indexPath.row][@"apply_is_full"]integerValue];
    if (row == 1) {
        [self setHudWithName:@"名额已满" Time:0.5 andType:1];
        return;
    }
    [TalkingData trackEvent:@"【特色入口】-点击产品"];
    ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - dropDownMenu
- (JSDropDownMenu *)dropDownMenu{
    if (!_dropDownMenu) {
       
        _dropDownMenu = [[JSDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:45];
        _dropDownMenu.indicatorColor = XColorWithRBBA(34, 58, 80, 0.48);
        _dropDownMenu.indicatorHightColor = XColorWithRGB(7, 137, 133);
        _dropDownMenu.separatorColor = XColorWithRGB(233, 233, 235);
        _dropDownMenu.textColor = XColorWithRBBA(34, 58, 80, 0.48);
        _dropDownMenu.textHightColor = XColorWithRGB(7, 137, 133);
        _dropDownMenu.dataSource = self;
        _dropDownMenu.delegate = self;
    }
    return _dropDownMenu;
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
    
    return 3;
    
}
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    return NO;
}
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    return 1;
}
- (NSInteger)currentLeftSelectedRow:(NSInteger)column{
   self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.frame.size.height);
        switch (column) {
                
            case 0:
                return _quotaIndex;
                break;
            case 1:
                return _dataIndex;
                break;
            case 2:
                return _sortIndex;
                break;
                
            default:
                break;
        }
    
    return 0;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
        switch (column) {
                
            case 0:
                return quotaArry.count;
                break;
            case 1:
                return dateArry.count;
                break;
            case 2:
                return sortArry.count;
                break;
                
            default:
                break;
        }
    
    return 0;
}

-(NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    titleArry = [NSMutableArray arrayWithObjects:@"可贷额度",@"借款期限",@"排序", nil];
    return titleArry[column];
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath{
    
    
    
        switch (indexPath.column) {
            case 0:
                return quotaArry[indexPath.row];
                break;
            case 1:
                return dateArry[indexPath.row];
                break;
            case 2:
                return sortArry[indexPath.row];
                break;
                
            default:
                break;
        }
    
    
    return @"xwm";
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{
    
        switch (indexPath.column) {
                
            case 0:
                [TalkingData trackEvent:@"【特色入口】-可贷额度"];
                if (indexPath.row == 0) {
                    quotaSelect = NO;
                    self.productListModel.loan_credit = nil;
                }else{
                    quotaSelect = YES;
                    self.productListModel.loan_credit = @(indexPath.row);
                }
                self.quotaIndex = indexPath.row;
                break;
            case 1:
                [TalkingData trackEvent:@"【特色入口】-借款期限"];
                if (indexPath.row == 0) {
                    dataSelect = NO;
                    self.productListModel.loan_deadline = nil;
                }else{
                    dataSelect = YES;
                    self.productListModel.loan_deadline = @(indexPath.row);
                }
                self.dataIndex = indexPath.row;
                break;
            case 2:
                [TalkingData trackEvent:@"【特色入口】-排序"];
                if (indexPath.row == 0) {
                    sortSelect = NO;
                    self.productListModel.order_type = nil;
                }else{
                    sortSelect = YES;
                    self.productListModel.order_type = @(indexPath.row);
                }
                self.sortIndex = indexPath.row;
                break;
                
            default:
                break;
        }
    
    //需要初始化条件
    [self.dataSourceArr removeAllObjects];
    self.queryParamModel.page_num = @(1);
    
    if (self.loan_product_type.integerValue) {
        [self prepareDataWithCount:SpecialViewRequestSpecialEntry];;
    }else{
        [self prepareDataWithCount:SpecialViewRequestProductList];
    }
}

- (void)showNoDataAlertView{
    [XAlertView alertWithTitle:@"温馨提示" message:@"您所在的城市与该类产品的经营区域不符合，无法申请。" cancelButtonTitle:@"知道了" confirmButtonTitle:nil viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case SpecialViewRequestProductList:
            self.cmd = XGetLoanProList;
            self.productListModel.query_param = self.queryParamModel;
            self.dict = [self.productListModel mj_keyValues];
            break;
        case SpecialViewRequestProductType:{
            self.cmd = XGetLoanClassifyList;
            if (self.loanTypeInfo.md5_hash.length) {
                self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.loanTypeInfo.md5_hash,@"md5_hash", nil];
            }else{
                self.dict = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"md5_hash", nil];
            }
        }
            break;
        case SpecialViewRequestSpecialEntry:{
            self.cmd = XQuerySpecialEntryLoanProductList;
            
            //            self.dict =@{@"special_entry_id":self.special_entry_id,
            //                         @"query_param":[self.queryParamModel mj_keyValues]
            //                         };
            self.productListModel.special_entry_id = self.special_entry_id;
            self.productListModel.query_param = self.queryParamModel;
            self.dict = [self.productListModel mj_keyValues];
        }
            return;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case SpecialViewRequestProductList:{
            
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
            if (!self.dataSourceArr.count) {
                self.tableView.tableFooterView = [self creatFooterView];
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            
        }
            break;
        case SpecialViewRequestProductType:{
            if (![self.loanTypeInfo.md5_hash isEqualToString:response.content[@"md5_hash"]]) {
                [[LoanTypeInfo sharedInstance]saveLoanTypeInfo:[LoanTypeInfo mj_objectWithKeyValues:response.content]];
            }
            
            [self setData];

            if (self.loan_product_type.integerValue) {
                [self prepareDataWithCount:SpecialViewRequestSpecialEntry];
            }else{
                [self prepareDataWithCount:SpecialViewRequestProductList];
            }
        }
            break;
        case SpecialViewRequestSpecialEntry:{
            
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
            if (!self.dataSourceArr.count) {
                self.tableView.tableFooterView = [self creatFooterView];
//                [self showNoDataAlertView];
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
        }
            return;
        default:
            break;
    }
}

- (void)headerRefresh{
    [self.tableView.mj_header endRefreshing];
}
- (void)footerRefresh{
    if (self.loan_product_type.integerValue) {
        self.queryParamModel.page_num = @(self.queryParamModel.page_num.integerValue+1);
        [self prepareDataWithCount:SpecialViewRequestSpecialEntry];
    }else{
        self.queryParamModel.page_num = @(self.queryParamModel.page_num.integerValue+1);
        [self prepareDataWithCount:SpecialViewRequestProductList];
    }
}
//- (UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//    }
//}
- (ProductListModel *)productListModel{
    if (!_productListModel) {
        _productListModel = [[ProductListModel alloc]init];
    }
    return _productListModel;
}
- (QueryParamModel *)queryParamModel{
    if (!_queryParamModel) {
        _queryParamModel = [[QueryParamModel alloc]init];
    }
    return _queryParamModel;
}
- (JSIndexPath *)jsIndexPath{
    if (!_jsIndexPath) {
        _jsIndexPath = [[JSIndexPath alloc]init];
        _jsIndexPath.column = 0;
    }
    return _jsIndexPath;
}
- (LoanTypeInfo *)loanTypeInfo{
    if (!_loanTypeInfo) {
        _loanTypeInfo = [[LoanTypeInfo sharedInstance]getLoanTypeInfo];
    }
    return _loanTypeInfo;
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

