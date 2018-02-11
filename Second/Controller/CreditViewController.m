//
//  CreditViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "CreditViewController.h"
#import "AllDKViewController.h"
#import "CreditSectionHeaderView.h"
#import "CreditInfoCell.h"
#import "CreditChannelCell.h"
#import "CreditMaterialCell.h"
#import "ParamModel.h"
#import "XSessionMgr.h"
#import "LoginVC.h"
#import "ServiceURLVC.h"
#import "IdentityAuthenticationVC.h"
#import "CreditInfoModel.h"
#import "ZMAuthenticationVC.h"
#import "BaseInfoVC.h"
#import "OperatorAuthenticationVC.h"
#import "AuthenticationBankVC.h"
#import "CertifiedBankVC.h"
#import "PlatformViewController.h"
#import "WorkInfoVC.h"
#import "ApplicantManVC.h"
#import "PersonalTailorVC.h"
typedef NS_ENUM(NSInteger, SectionType) {
    SectionInfo,
    SectionChannel,
    SectionBorrow,
    SectionImprove,
    SectionCount
};
typedef NS_ENUM(NSInteger ,CreditRequest) {
    CreditRequestDetailInfo,
    CreditRequestLoanProList,
};
@interface CreditViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CreditPassDelegate>
{
    CreditInfoModel *creditModel;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSDictionary *borrowDic;
@property (nonatomic, strong) NSDictionary *improveDic;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation CreditViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //talkingdata
    [TalkingData trackEvent:@"【信用助手】页"];
    [self getData];
    [self setupInterface];

    
}
-(void)Refresh{
    [self prepareDataWithCount:CreditRequestDetailInfo];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Refresh) name:@"Refresh" object:nil];
    [self prepareDataWithCount:CreditRequestDetailInfo];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self showTabBar];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = XColorWithRGB(255, 201, 179);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor whiteColor];
}

- (void)getData{
    self.borrowDic = @{@"name":@[@"身份认证",@"芝麻信用认证",@"基本信息认证",@"运营商认证"],@"image":@[@"myData_identity",@"myData_ZMXY",@"myData_baseInfo",@"myData_YYS"],@"selectedimage":@[@"iconCardInfoP",@"iconZhimaInfoP",@"iconBaseInfoP",@"iconOperatorInfoP"]};
    
    if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1) {
        self.improveDic = @{@"name":@[@"银行卡",@"工作信息",@"申请人资质"],@"image":@[@"myData_bank",@"myData_workInfo",@"iconAuthorizationP"],@"selectedimage":@[@"iconBankInfoP",@"iconWorkInfoP",@"iconIdInfoP"]};
    }else{
        self.improveDic = @{@"name":@[@"银行卡",@"借贷平台信息",@"工作信息",@"申请人资质"],@"image":@[@"myData_bank",@"myData_JieDaiInfo",@"myData_workInfo",@"iconAuthorizationP"],@"selectedimage":@[@"iconBankInfoP",@"iconLoanPlatformP",@"iconWorkInfoP",@"iconIdInfoP"]};
    }
}

- (void)setupInterface {

    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = -1;

    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10,ScreenWidth , ScreenHeight-44) collectionViewLayout:_flowLayout];
    _collectionView.scrollEnabled = NO;
    _collectionView.delaysContentTouches = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    _collectionView.mj_header = nil;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [self.view addSubview:_collectionView];
    
    // register SectionHeader
    [_collectionView registerClass:[CreditSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CreditSectionHeaderView class])];
    
    // register cell
    [_collectionView registerClass:[CreditInfoCell class] forCellWithReuseIdentifier:NSStringFromClass([CreditInfoCell class])];
    [_collectionView registerClass:[CreditChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([CreditChannelCell class])];
    [_collectionView registerClass:[CreditMaterialCell class] forCellWithReuseIdentifier:NSStringFromClass([CreditMaterialCell class])];
    
//    [self prepareDataWithCount:CreditRequestDetailInfo];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return SectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 1;
    switch (section) {
        case SectionBorrow:
            count = 4;
            break;
        case SectionImprove:
            if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1){
               count = 3;
            }else{
               count = 4;
            }
            
            break;
        default:
            break;
    }
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case SectionInfo:
        {
            CreditInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CreditInfoCell class]) forIndexPath:indexPath];
            cell.backgroundColor = XColorWithRGB(255, 201, 179);
            [cell configureWith:creditModel];
            return cell;
        }
        case SectionChannel:
        {
            CreditChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CreditChannelCell class]) forIndexPath:indexPath];
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"信用助手"];
            cell.backgroundView = image;
            cell.delegate = self;
            if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1) {
                cell.btn.hidden = YES;
                cell.lab.hidden = YES;
                [self.tableView reloadData];
            }
            return cell;
        }
        case SectionBorrow:{
            CreditMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CreditMaterialCell class]) forIndexPath:indexPath];
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@"信用助手3"];
            cell.backgroundView = image;
            [cell configureWithFirst:self.borrowDic indexPath:indexPath.row model:creditModel];
            return cell;
        }
            break;
        case SectionImprove:{
    
            CreditMaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CreditMaterialCell class]) forIndexPath:indexPath];
            UIImageView *image = [[UIImageView alloc]init];
            image.image = [UIImage imageNamed:@""];
            cell.backgroundView = image;
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
            [cell configureWith:self.improveDic indexPath:indexPath.row model:creditModel];

            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        CreditSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([CreditSectionHeaderView class]) forIndexPath:indexPath];
        if (indexPath.section == 2) {
            headerView.imageView.image = [UIImage imageNamed:@"信用助手2"];
            headerView.titleLabe.text = @"借款资料(必填)";
        }else if (indexPath.section == 3){
            headerView.imageView.image = [UIImage imageNamed:@""];
            headerView.backgroundColor = [UIColor whiteColor];
            headerView.titleLabe.text = @"提额资料";
        }
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [super prepareDataWithCount:CreditRequestDetailInfo];
    if(![[UserInfo sharedInstance]isSignIn]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if(indexPath.section == SectionBorrow){
        switch (indexPath.row) {
            case 0:{
                IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
                vc.creditInfoModel = creditModel;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:{
                if (creditModel.zhima_status.integerValue == 1) {
                    [self setHudWithName:@"芝麻信用已认证" Time:0.5 andType:3];
                    return;
                }
                if (creditModel.identity_status.integerValue == 1) {
                    ZMAuthenticationVC *vc = [[ZMAuthenticationVC alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
                }
            }
                break;
            case 2:{
                if (creditModel.identity_status.integerValue == 1) {
                    BaseInfoVC *vc = [[BaseInfoVC alloc]init];
                    vc.creditInfoModel = creditModel;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
                }
               
            }
                break;
            case 3:{
                if (creditModel.identity_status.integerValue == 1) {
                    if (creditModel.base_info_status.integerValue == 1) {
                        OperatorAuthenticationVC *vc = [[OperatorAuthenticationVC alloc]init];
                        vc.creditInfoModel = creditModel;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        [self setHudWithName:@"请先完成基本信息认证" Time:0.5 andType:3];
                    }
                } else {
                    [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
                }
                
            }
                break;
            default:
                break;
        }
    }
    if(indexPath.section == SectionImprove){
        if (creditModel.identity_status.integerValue == 1) {
            switch (indexPath.row) {
                case 0:{
                    if (creditModel.bank_status.integerValue == 1) {
                        CertifiedBankVC *vc = [[CertifiedBankVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        AuthenticationBankVC *vc = [[AuthenticationBankVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                }
                    break;
                case 1:{
                    if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1){
                        WorkInfoVC *vc = [[WorkInfoVC alloc]init];
                        vc.creditInfoModel = creditModel;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        PlatformViewController *plat = [[PlatformViewController alloc]init];
                        plat.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:plat animated:YES];
                    }
                }
                    
                    break;
                case 2:{
                    if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1){
                        ApplicantManVC *vc = [[ApplicantManVC alloc]init];
                        vc.creditInfoModel = creditModel;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        WorkInfoVC *vc = [[WorkInfoVC alloc]init];
                        vc.creditInfoModel = creditModel;
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                    break;
                case 3:{
                    ApplicantManVC *vc = [[ApplicantManVC alloc]init];
                    vc.creditInfoModel = creditModel;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        } else {
            [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
        }
    }
}

// 选中高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor lightGrayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SectionBorrow:
            return CGSizeMake(self.collectionView.bounds.size.width, AdaptationWidth(20));
        case SectionImprove:
            return CGSizeMake(self.collectionView.bounds.size.width, AdaptationWidth(20));
        default: 
            return CGSizeZero;
    }
}
- (CGFloat)fixSlitWith:(CGRect)rect colCount:(CGFloat)colCount space:(CGFloat)space {
    CGFloat totalSpace = (colCount - 1) * space;//总共留出的距离
    CGFloat itemWidth = (rect.size.width - totalSpace) / colCount;// 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    CGFloat fixValue = 1 / [UIScreen mainScreen].scale; //(1px=0.5pt,6Plus为3px=1pt)
    CGFloat realItemWidth = floor(itemWidth) + fixValue;//取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    if (realItemWidth < itemWidth) {// 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue;
    }
    CGFloat realWidth = colCount * realItemWidth + totalSpace;//算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    CGFloat pointX = (realWidth - rect.size.width) / 2; //偏移距离
    rect.origin.x = -pointX;//向左偏移
    rect.size.width = realWidth;
    return (rect.size.width - totalSpace) / colCount; //每个cell的真实宽度
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionInfo:
            return CGSizeMake(self.collectionView.bounds.size.width, AdaptationWidth(189));
        case SectionChannel:
            return CGSizeMake(self.collectionView.bounds.size.width, AdaptationWidth(151));
        case SectionBorrow:
        case SectionImprove:
            return CGSizeMake([self fixSlitWith:self.collectionView.bounds colCount:4 space:0], AdaptationWidth(111));
        default:
            return CGSizeZero;
    }
}

#pragma mark - CreditChannelCell-delegate
- (void)pushAllDK{
    [super prepareDataWithCount:CreditRequestDetailInfo];
    if(![[UserInfo sharedInstance]isSignIn]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBlackLogin:self];//判断是否登录状态
        });
        return;
    }
    if (_clientGlobalInfoRM.recomment_entry_hide.integerValue == 1) {
        [self setHudWithName:@"暂未开发，敬请期待！" Time:0.5 andType:1];
        return;
    }
//    if ([creditModel.credit_level isEqualToString:@"E"] || [creditModel.credit_level isEqualToString:@"D"]) {
//        [self setHudWithName:@"您的信用信息太少，小贷无法给您推荐合适的产品。请先完善信息~" Time:2 andType:3];
//    }else if ([creditModel.credit_level isEqualToString:@"C"] || [creditModel.credit_level isEqualToString:@"B"] || [creditModel.credit_level isEqualToString:@"A"]){
//        AllDKViewController *vc = [[AllDKViewController alloc]init];
//        if ([creditModel.credit_level isEqualToString:@"C"]) {
//            vc.typeIndex = 3;
//        }else{
//            vc.typeIndex = 4;
//        }
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if ([creditModel.identity_status.description isEqual:@"0"] || [creditModel.base_info_status.description isEqual:@"0"] || [creditModel.zhima_status.description isEqual:@"0"] ||[creditModel.operator_status.description isEqual:@"0"] ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信用信息太少，小贷无法给您推荐合适的产品。请先完善信息~" preferredStyle:UIAlertControllerStyleAlert];
        UIView *subView1 = alertController.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
        UILabel *message = subView5.subviews[1];
        message.textAlignment = NSTextAlignmentLeft;
        [message setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
        message.textColor = XColorWithRBBA(34, 58, 80, 0.32);
        UILabel *title = subView5.subviews[0];
        title.textAlignment = NSTextAlignmentLeft;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction *confrmlAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:confrmlAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(creditModel.applicant_qualification_status.integerValue == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信用等级不错哦，适合您的产品很多。试试一键定制吧~" preferredStyle:UIAlertControllerStyleAlert];
        UIView *subView1 = alertController.view.subviews[0];
        UIView *subView2 = subView1.subviews[0];
        UIView *subView3 = subView2.subviews[0];
        UIView *subView4 = subView3.subviews[0];
        UIView *subView5 = subView4.subviews[0];
        UILabel *message = subView5.subviews[1];
        message.textAlignment = NSTextAlignmentLeft;
        [message setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
        message.textColor = XColorWithRBBA(34, 58, 80, 0.32);
        UILabel *title = subView5.subviews[0];
        title.textAlignment = NSTextAlignmentLeft;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
       
        [alertController addAction:cancelAction];
        UIAlertAction *confrmlAction = [UIAlertAction actionWithTitle:@"去定制" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            ApplicantManVC *vc = [[ApplicantManVC alloc]init];
            vc.comeFrom = @(1);
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertController addAction:confrmlAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if( self.dataSourceArr.count > 0){
        //判断是否有可推荐的产品
        PersonalTailorVC *vc = [[PersonalTailorVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
       
    }else{
        
        AllDKViewController *vc = [[AllDKViewController alloc]init];
        if ([creditModel.credit_level isEqualToString:@"C"]) {
            vc.typeIndex = 3;
        }else{
            vc.typeIndex = 4;
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case CreditRequestDetailInfo:
            self.cmd = XGetCreditInfo;
            self.dict = @{};
            break;
        case CreditRequestLoanProList:{
            self.cmd = XGetRecommendLoanProList;
            self.dict =@{@"query_param":@{@"page_size":@(1),
                                          @"page_num":@(1)
                                          },
                         @"query_entry_type":@(2)
                         };
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    
    switch (self.requestCount) {
        case CreditRequestDetailInfo:{
//            [_collectionView.mj_header endRefreshing];
            creditModel = nil;
            creditModel = [CreditInfoModel mj_objectWithKeyValues:response.content];
            [self.collectionView reloadData];
            [self prepareDataWithCount:CreditRequestLoanProList];
        }
            break;
        case CreditRequestLoanProList:{
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
           
        }
            break;
        default:
            break;
    }
}
/**  网络请求
 *   string:表示请求的cmd dict:表示请求的参数
 */
-(void)prepareDataGetUrlWithModel:(id)model andparmeter:(NSDictionary *)dict{
    
    MBProgressHUD *hud = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.cmd forKey:@"service"];
    NSMutableDictionary *content = [[[BaseInfoPM alloc]init] mj_keyValues];
    [content addEntriesFromDictionary:dict];
    [params setObject:content forKey:@"content"];
    [params setObject:[[XSessionMgr sharedInstance]getLatestSessionId] forKey:@"sessionId"];
    
    NSString *changeString = [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:params]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SERVICEURL]];
    [request setHTTPMethod:@"POST"];
    // 此处设置请求体 (即将参数加密后的字符串,转为data)
    [request setHTTPBody: [changeString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask * tesk = [requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
            MyLog(@"网络请求失败返回数据%@",error);
            if (!(_bgView == nil)) {
                _bgView.hidden = YES;
                [_bgView removeFromSuperview];
            }
            _bgView = [[UIView alloc]init];
            _bgView.backgroundColor = [UIColor whiteColor];
            
            UILabel *titlelabel = [[UILabel alloc]init];
            [titlelabel setText:@"咦, 网络似乎断了"];
            titlelabel.textColor = XColorWithRBBA(34, 58, 80, 0.8);
            titlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
            titlelabel.textAlignment = NSTextAlignmentLeft;
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unconneted"]];
            //
            UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refreshButton.layer.cornerRadius = 4;
            refreshButton.clipsToBounds = YES;
            refreshButton.backgroundColor = XColorWithRGB(252, 93, 109);
            [refreshButton setTitle:@"刷新试试" forState:UIControlStateNormal];
            [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [refreshButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
            refreshButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
            [refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            
            [_bgView addSubview:titlelabel];
            [_bgView addSubview:imageView];
            [_bgView addSubview:refreshButton];
            [self.view addSubview:_bgView];
            
            [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(self.view);
            }];
            [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_bgView).offset(AdaptationWidth(128));
                make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
                make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
                make.height.mas_equalTo(AdaptationWidth(42));
            }];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(AdaptationWidth(161));
                make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
                make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
                make.top.mas_equalTo(titlelabel.mas_bottom).offset(AdaptationWidth(32));
            }];
            [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(AdaptationWidth(48));
                make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
                make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
                make.top.mas_equalTo(imageView.mas_bottom).offset(AdaptationWidth(48));
            }];
            
        }else{
            
            NSString *base64String = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *base64String2 = [SecurityUtil decryptAESData:base64String];
            NSDictionary *keyDict = [SecurityUtil dictionaryWithJsonString:base64String2];
            MyLog(@"网络请求成功返回数据%@",keyDict);
            
            XResponse *response = [XResponse mj_objectWithKeyValues:keyDict];
            if (response.errCode.integerValue == 2) {//session过期或者失效
                ServiceURLVC *vc = [[ServiceURLVC alloc]init];
                [vc getServiceURL:^(id result) {
                    [self prepareDataWithCount:self.requestCount];
                }];
                return ;
            }
            if(response.errCode.integerValue ==15 ) {//登录失效

            }
            [self getDataSourceWithObject:response];
        }
    }];
    [tesk resume];
}

/**  网络请求成功之后调用,子类重写
 *   object 是网络请求的结果
 */
-(void)getDataSourceWithObject:(XResponse *)response {
    if (response.errCode.integerValue == 0) {
        [self requestSuccessWithDictionary:response];
    }else{
        [self requestFaildWithDictionary:response];
    }
}
-(void)refreshButtonClick
{
    [self prepareDataWithCount:self.requestCount];
    _bgView.hidden = YES;
    [_bgView removeFromSuperview];
}

- (void)requestFaildWithDictionary:(XResponse *)response{
//    [super requestFaildWithDictionary:response];
    [self.collectionView reloadData];
}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refresh" object:nil];
//}
- (void)headerRefresh{
    [self prepareDataWithCount:CreditRequestDetailInfo];
}

@end
