
//
//  PersonalTailorVC.m
//  QuanWangDai
//
//  Created by yanqb on 2018/1/31.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "PersonalTailorVC.h"
#import "JSDropDownMenu.h"
#import "LoanTypeInfo.h"
#import "ProductListModel.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "XRootWebVC.h"

typedef NS_ENUM(NSInteger ,PersonalTailorRequest) {
    PersonalTailorRequestProductList,
    PersonalTailorRequestProductLuoDi,
    HalfWithAllProduct,
};

@interface PersonalTailorVC ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>
@property (nonatomic ,strong) JSDropDownMenu *dropDownMenu;
@property (nonatomic ,strong) JSDropDownMenu *dropDownMenu2;
@property (nonatomic ,strong) LoanTypeInfo *loanTypeInfo;
@property (nonatomic ,strong) ProductListModel *productListModel;
@property (nonatomic ,strong) QueryParamModel *queryParamModel;
@property (nonatomic ,strong) RecommendTableViewCell *cell;
@property (nonatomic ,strong) NSMutableArray *speedArray, *lineArray;//极速快贷，线上网贷
@property (nonatomic ,strong) NSNumber *speedOrLine;//产品合作方式：1落地页 2注册信息对接 3商户后台
@end
@implementation PersonalTailorVC
{
    NSMutableArray *typeArry,*quotaArry,*dateArry,*returnArry,*titleArry,*goToArry;
    BOOL tpyeSelect,quotaSelect,dataSelect,sortSelect;
    BOOL isFirstCome;//第一次进入当前页面是否显示提示框
    UISegmentedControl *segment;
    BOOL isFirst;

}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"【产品推荐】页"];
    
    if (self.isAllProduct.integerValue == 1) {
        [self prepareDataWithCount:PersonalTailorRequestProductList];
        [self createTableViewWithFrame:CGRectZero];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(45);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }else{
        [self prepareDataWithCount:HalfWithAllProduct];
        [self createTableViewWithFrame:CGRectZero];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer.hidden = NO;
    
    
}
- (void)setData{

//    typeArry = [NSMutableArray arrayWithArray:self.loanTypeInfo.loan_classify_list];
//    [typeArry insertObject:@{@"loan_classify_name":@"不限"} atIndex:0];
    titleArry = [NSMutableArray arrayWithObjects:@"可贷额度",@"借款期限",@"贷前回访",@"到店办理", nil];
    quotaArry = [NSMutableArray arrayWithObjects:@"不限",@"2000元以下",@"2001~5000元",@"5001~10000元",@"10001~50000元",@"50001元以上", nil];
    dateArry = [NSMutableArray arrayWithObjects:@"不限",@"1个月内",@"1~6个月",@"6~12个月",@"超过12个月", nil];
    returnArry = [NSMutableArray arrayWithObjects:@"不限",@"无需回访", nil];
    goToArry = [NSMutableArray arrayWithObjects:@"不限",@"无需到店", nil];
    [self.view addSubview:self.dropDownMenu];
    if (self.speedOrLine.integerValue == 3) {
        self.dropDownMenu2.hidden = YES;
    }
    [self.view addSubview:self.dropDownMenu2];
   
}
-(void)setBackNavigationBarItem
{
    if(self.isAllProduct.integerValue == 2){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 124, 44)];
        view.userInteractionEnabled = YES;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 104, 44);
        button.tag = 9999;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
        [button setTitle:@"为您推荐" forState:UIControlStateNormal];
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
    }else{
        if (self.speedArray.count && self.lineArray.count) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 84, 44)];
            view.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 64, 44);
            button.tag = 9999;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            UIView *lineview  = [[UIView alloc] initWithFrame:CGRectMake(36, (button.frame.size.height- AdaptationWidth(16)) / 2, 0.5 , AdaptationWidth(16))];
            lineview.backgroundColor  = XColorWithRGB(233, 233, 235);
            [button addSubview:lineview];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
            self.navigationItem.leftBarButtonItem = item;
        }else{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 144, 44)];
            view.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 144, 44);
            button.tag = 9999;
            button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
            [button setTitle:@"专属产品推荐" forState:UIControlStateNormal];
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
    }
    
}
- (void)BarbuttonClick:(UIButton *)btn{
    [WDNotificationCenter postNotificationName:@"Refresh" object:self userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)creatSegmentedControl{
    segment = [[UISegmentedControl alloc]initWithItems:@[@"极速贷",@"线上网贷"]];
    segment.selectedSegmentIndex = self.speedOrLine.integerValue == 1 ? 1 : 0;
    segment.frame =CGRectMake(0, 0, AdaptationWidth(152), AdaptationWidth(29));
    segment.tintColor = XColorWithRBBA(7, 137, 133, 1);
    [segment addTarget:self action:@selector(segmentOnClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
}
#pragma  mark -btn
- (void)btnOnClick:(UIButton *)btn{
    [CreditState selectCreaditState:self with:nil];
}
- (void)segmentOnClick:(UISegmentedControl *)sender{
    self.typeIndex = 0;
    self.quotaIndex = 0;
    self.dataIndex = 0;
    self.sortIndex = 0;
    quotaSelect = NO;
    dataSelect = NO;
    self.productListModel = nil;
    if (sender.selectedSegmentIndex == 0) {
        [TalkingData trackEvent:@"【专属产品推荐-极速贷】页"];
        self.dropDownMenu.hidden = NO;
        self.dropDownMenu2.hidden = YES;
        self.speedOrLine = @3;
    }else{
        self.dropDownMenu.hidden = YES;
        self.dropDownMenu2.hidden = NO;
        
        [TalkingData trackEvent:@"【专属产品推荐-线上网贷】页"];
        self.speedOrLine = @1;
    }

    [self prepareDataWithCount:PersonalTailorRequestProductList];
}
#pragma mark - tableView Delegate
- (UIView *)creatFooterView{
    if ( self.isAllProduct.integerValue == 1 && self.speedArray.count == 0 && self.lineArray.count == 0) {
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
    
    if (self.isAllProduct.integerValue == 2 && self.dataSourceArr.count){
        UIView * Footerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(101))];
        Footerview.backgroundColor = [UIColor clearColor];
        UILabel *lab = [[UILabel alloc]init];
        [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
        [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(14)]];
        [Footerview addSubview:lab];
         [lab setText:@"没有满意的产品？"];
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

        [btn setTitle:@"完善资料，100%下款" forState:UIControlStateNormal];

        CGSize imageSize = btn.currentImage.size;
        CGSize titleSize = btn.titleLabel.intrinsicContentSize;
        btn.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width, 0, -(titleSize.width));
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
        
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [Footerview addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(16));
            make.centerX.mas_equalTo(Footerview);
            make.width.mas_equalTo(AdaptationWidth(194));
            make.height.mas_equalTo(AdaptationWidth(41));
        }];
        return Footerview;
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setText:@"以下产品成功率高达100%"];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
    [lab setTextColor:XColorWithRBBA(184, 192, 199, 1)];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.bottom.mas_equalTo(view.mas_bottom).offset(AdaptationWidth(-8));
    }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return AdaptationWidth(42);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isAllProduct.integerValue == 1) {
        if (self.speedOrLine.integerValue == 3) {
            return self.speedArray.count;
        }else{
            return self.lineArray.count;
        }
    }
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
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    _cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    if (self.isAllProduct.integerValue == 1) {
        if (self.speedOrLine.integerValue == 3) {
            _cell.model =[ProductModel mj_objectWithKeyValues:self.speedArray[indexPath.row]] ;
        }else{
            _cell.model =[ProductModel mj_objectWithKeyValues:self.lineArray[indexPath.row]] ;
        }
    }else{
        _cell.model =[ProductModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]] ;
    }
    
    
    _cell.appState.hidden = YES;
    [_cell setDetailColor:sortSelect quotaSelect:quotaSelect dataSelect:dataSelect];
    return _cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//    if(![[UserInfo sharedInstance]isSignIn]){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self getBlackLogin:self];//判断是否登录状态
//        });
//        return;
//    }
//    //是否名额已满
//    NSInteger row = [self.dataSourceArr[indexPath.row][@"apply_is_full"]integerValue];
//    if (row == 1) {
//        [self setHudWithName:@"名额已满" Time:0.5 andType:1];
//        return;
//    }
    
        ProductDetailVC *vc = [[ProductDetailVC alloc]init];
    
    if(self.isAllProduct.integerValue == 2){
        vc.loan_pro_id = self.dataSourceArr[indexPath.row][@"loan_pro_id"];
    }else{
        if (self.speedOrLine.integerValue == 3) {
            vc.loan_pro_id = self.speedArray[indexPath.row][@"loan_pro_id"];
        }else{
            vc.loan_pro_id = self.lineArray[indexPath.row][@"loan_pro_id"];
        }
    }
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
- (JSDropDownMenu *)dropDownMenu2{
    if (!_dropDownMenu2) {
        _dropDownMenu2 = [[JSDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:45];
        _dropDownMenu2.indicatorColor = XColorWithRBBA(34, 58, 80, 0.48);
        _dropDownMenu2.indicatorHightColor = XColorWithRGB(7, 137, 133);
        _dropDownMenu2.separatorColor = XColorWithRGB(233, 233, 235);
        _dropDownMenu2.textColor = XColorWithRBBA(34, 58, 80, 0.48);
        _dropDownMenu2.textHightColor = XColorWithRGB(7, 137, 133);
        _dropDownMenu2.dataSource = self;
        _dropDownMenu2.delegate = self;
    }
    return _dropDownMenu2;
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
  
    if (menu == self.dropDownMenu) {
        return 4;
    }else{
        return 2;
    }
    
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
    if (self.speedOrLine.integerValue != 3) {
        switch (column) {
            case 0:
                return self.quotaIndex;
                break;
            case 1:
                return self.dataIndex;
                break;
            default:
                break;
        }
    }else{
        switch (column) {
            case 0:
                return self.quotaIndex;
                break;
            case 1:
                return self.dataIndex;
                break;
            case 2:
                return self.sortIndex;
                break;
            case 3:
                return self.typeIndex;
                break;
            default:
                break;
        }
    }
    return 0;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{

        if (self.speedOrLine.integerValue != 3) {
            switch (column) {
                case 0:
                    return quotaArry.count;
                    break;
                case 1:
                    return dateArry.count;
                    break;
                default:
                    break;
            }
        }else{
            switch (column) {
                case 0:
                    return quotaArry.count;
                    break;
                case 1:
                    return dateArry.count;
                    break;
                case 2:
                    return returnArry.count;
                    break;
                case 3:
                    return goToArry.count;
                    break;
                default:
                    break;
            }
        }
    return 0;
}

-(NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
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
                return returnArry[indexPath.row];
                break;
            case 3:
                return goToArry[indexPath.row];
                break;
            default:
                break;
        }
    
    
    return @"xwm";
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{

        switch (indexPath.column) {
            case 0:
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
                if (indexPath.row == 0) {
                   
                    self.productListModel.pre_loan_visit = nil;
                }else{
                    
                    self.productListModel.pre_loan_visit = @0;
                }
                self.sortIndex = indexPath.row;
                break;
            case 3:{
                if (indexPath.row == 0) {
                    self.productListModel.shop_visit = nil;
                }else{
                    self.productListModel.shop_visit = @0;
                }
                self.typeIndex = indexPath.row;
            }
                break;
            default:
                break;
        }
    //需要初始化条件
    [self.speedArray removeAllObjects];
    [self.lineArray removeAllObjects];
    self.queryParamModel.page_num = @(1);
    isFirstCome = YES;
    [self prepareDataWithCount:PersonalTailorRequestProductList];
    
}
- (void)showNoDataAlertView{
    [XAlertView alertWithTitle:@"温馨提示" message:@"您所在的城市与该类产品的经营区域不符合，无法申请。" cancelButtonTitle:@"知道了" confirmButtonTitle:nil viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case PersonalTailorRequestProductList:
            self.cmd = XGetRecommendLoanProList;
            self.productListModel.query_param = self.queryParamModel;
            self.productListModel.query_entry_type = @(1);
            self.productListModel.cooperation_type = @(3);
            self.dict = [self.productListModel mj_keyValues];
            break;
        case PersonalTailorRequestProductLuoDi:
            self.cmd = XGetRecommendLoanProList;
            self.productListModel.query_param = self.queryParamModel;
            self.productListModel.query_entry_type = @(1);
            self.productListModel.cooperation_type = @(1);
            self.dict = [self.productListModel mj_keyValues];
            break;

        case HalfWithAllProduct:{
            self.cmd  = XGetSpecialLoanProList;
            self.dict =@{@"query_type":self.isAllProduct};
        }
            break;
        default:
            break;
    }
}

- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case PersonalTailorRequestProductList:{
  
            
            [self.speedArray addObjectsFromArray:response.content[@"loan_pro_list"]];

            [self prepareDataWithCount:PersonalTailorRequestProductLuoDi];
        }
            break;
        case PersonalTailorRequestProductLuoDi:{
            
            [self.lineArray addObjectsFromArray:response.content[@"loan_pro_list"]];
            
            if (self.speedArray.count == 0 && self.lineArray.count == 0) {
                self.tableView.tableFooterView = [self creatFooterView];
//                if (!isFirstCome) {
//                    [self showNoDataAlertView];
//                }
                
            }else{
                self.tableView.tableFooterView = [self creatFooterView];
            }
            
           
            if (self.lineArray.count && self.speedArray.count) {
                [self creatSegmentedControl];
            }
            if (!isFirst) {
                if (self.speedArray.count) {
                    self.speedOrLine = @3;
                }else{
                    self.speedOrLine = @1;
                }
                [self setBackNavigationBarItem];
                isFirst = YES;
            }
            
            [self setData];
            [self.tableView reloadData];
        }
            break;
        case HalfWithAllProduct:{
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
            self.tableView.tableFooterView = [self creatFooterView];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}
- (void)headerRefresh{
    [self.tableView.mj_header endRefreshing];
}
- (void)footerRefresh{
    if (self.isAllProduct.integerValue == 1) {
        self.queryParamModel.page_num = @(self.queryParamModel.page_num.integerValue+1);
        [self prepareDataWithCount:PersonalTailorRequestProductList];
    }else{
        [self.dataSourceArr removeAllObjects];
        [self prepareDataWithCount:HalfWithAllProduct];
    }
    
    
}
- (NSMutableArray *)speedArray{
    if (!_speedArray) {
        _speedArray = [NSMutableArray array];
    }
    return _speedArray;
}
- (NSMutableArray *)lineArray{
    if (!_lineArray) {
        _lineArray = [NSMutableArray array];
    }
    return _lineArray;
}
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
- (LoanTypeInfo *)loanTypeInfo{
    if (!_loanTypeInfo) {
        _loanTypeInfo = [[LoanTypeInfo sharedInstance]getLoanTypeInfo];
    }
    return _loanTypeInfo;
}


@end
