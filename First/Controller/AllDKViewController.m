//
//  AllDKViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/10.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "AllDKViewController.h"
#import "JSDropDownMenu.h"
#import "RecommendTableViewCell.h"
#import "ProductDetailVC.h"
#import "ProductListModel.h"
#import "LoanTypeInfo.h"

typedef NS_ENUM(NSInteger ,AllDKViewRequest) {
    AllDKViewRequestProductList,
    AllDKViewRequestProductDetail,
    AllDKViewRequestProductType,
    AllDKViewRequestSpecialEntry,
};
@interface AllDKViewController ()<JSDropDownMenuDelegate,JSDropDownMenuDataSource>
@property (nonatomic ,strong) JSDropDownMenu *dropDownMenu;
@property (nonatomic ,strong) ProductListModel *productListModel;
@property (nonatomic ,strong) QueryParamModel *queryParamModel;
@property (nonatomic ,strong) RecommendTableViewCell *cell;
@property (nonatomic ,strong) JSIndexPath *jsIndexPath;
@property (nonatomic ,strong) LoanTypeInfo *loanTypeInfo;
@end

@implementation AllDKViewController
{
    NSMutableArray *typeArry,*quotaArry,*dateArry,*sortArry,*titleArry;
    NSArray *specialArry;
    BOOL tpyeSelect,quotaSelect,dataSelect,sortSelect;
}
- (void)viewWillAppear:(BOOL)animated{
    if (self.typeIndex == 3 || self.typeIndex == 4) {
        self.productListModel.loan_pro_type = @(self.typeIndex);
    }
    [self.dataSourceArr removeAllObjects];
    self.queryParamModel.page_num = @(1);
    [self prepareDataWithCount:AllDKViewRequestProductType];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //talkingdata
    [TalkingData trackEvent:@"【贷款大全】页"];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(45);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_footer.hidden = NO;
    
    
}

-(void)setBackNavigationBarItem
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 124, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 104, 44);
    button.tag = 9999;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    if (self.loan_product_type) {
        [button setTitle:self.titleStr forState:UIControlStateNormal];
    }else{
        [button setTitle:@"贷款大全" forState:UIControlStateNormal];
    }
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
        if (self.loan_classify_ids_str.length) {
            specialArry = [self.loan_classify_ids_str componentsSeparatedByString:@","];
            [self.loanTypeInfo.loan_classify_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                for (int i = 0; specialArry.count > i; i++) {
                    if ([specialArry[i] isEqualToString:[NSString stringWithFormat:@"%@",obj[@"loan_classify_id"]]]) {
                        [typeArry addObject:obj];
                    }
                }
            }];
        }
        if (typeArry.count > 1) {
            [typeArry insertObject:@{@"loan_classify_name":@"不限"} atIndex:0];
            titleArry = [NSMutableArray arrayWithObjects:@"贷款类型",@"可贷额度",@"借款期限",@"排序", nil];
        }else{
            titleArry = [NSMutableArray arrayWithObjects:@"可贷额度",@"借款期限",@"排序", nil];
        }
    }else{
        typeArry = [NSMutableArray arrayWithArray:self.loanTypeInfo.loan_classify_list];
        if (typeArry.count > 1) {
            [typeArry insertObject:@{@"loan_classify_name":@"不限"} atIndex:0];
            titleArry = [NSMutableArray arrayWithObjects:@"贷款类型",@"可贷额度",@"借款期限",@"排序", nil];
        }else{
            titleArry = [NSMutableArray arrayWithObjects:@"可贷额度",@"借款期限",@"排序", nil];
        }
    }

    quotaArry = [NSMutableArray arrayWithObjects:@"不限",@"2000元以下",@"2001~5000元",@"5001~10000元",@"10001~50000元",@"50001元以上", nil];
    dateArry = [NSMutableArray arrayWithObjects:@"不限",@"1个月内",@"1~6个月",@"6~12个月",@"超过12个月", nil];
    sortArry = [NSMutableArray arrayWithObjects:@"默认排序",@"贷款利率", nil];
    [self.view addSubview:self.dropDownMenu];
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
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    if (titleArry.count > 3) {
        return 4;
    }else{
        return 3;
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
    if (titleArry.count > 3) {
        switch (column) {
            case 0:
                return _typeIndex;
                break;
            case 1:
                return _quotaIndex;
                break;
            case 2:
                return _dataIndex;
                break;
            case 3:
                return _sortIndex;
                break;
                
            default:
                break;
        }
    }else{
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
    }
    return 0;
}
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    if (titleArry.count > 3) {
        switch (column) {
            case 0:
                return typeArry.count;
                break;
            case 1:
                return quotaArry.count;
                break;
            case 2:
                return dateArry.count;
                break;
            case 3:
                return sortArry.count;
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
                return sortArry.count;
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
    if (titleArry.count > 3) {
        switch (indexPath.column) {
            case 0:
                return typeArry[indexPath.row][@"loan_classify_name"];
                break;
            case 1:
                return quotaArry[indexPath.row];
                break;
            case 2:
                return dateArry[indexPath.row];
                break;
            case 3:
                return sortArry[indexPath.row];
                break;
                
            default:
                break;
        }
    }else{
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
    }
    
    return @"xwm";
}
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{
    if (titleArry.count > 3) {
        switch (indexPath.column) {
            case 0:
                if (indexPath.row == 0) {
                    self.productListModel.loan_pro_type = nil;
                    self.productListModel.loan_classify_id = nil;
                    tpyeSelect = NO;
                }else{
                    self.productListModel.loan_pro_type = @(indexPath.row);
                    self.productListModel.loan_classify_id = typeArry[indexPath.row][@"loan_classify_id"];
                    tpyeSelect = YES;
                }
                
                
                self.typeIndex = indexPath.row;
                break;
            case 1:
                if (indexPath.row == 0) {
                    quotaSelect = NO;
                    self.productListModel.loan_credit = nil;
                }else{
                    quotaSelect = YES;
                    self.productListModel.loan_credit = @(indexPath.row);
                }
                self.quotaIndex = indexPath.row;
                break;
            case 2:
                if (indexPath.row == 0) {
                    dataSelect = NO;
                    self.productListModel.loan_deadline = nil;
                }else{
                    dataSelect = YES;
                    self.productListModel.loan_deadline = @(indexPath.row);
                }
                self.dataIndex = indexPath.row;
                break;
            case 3:
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
    }else{
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
    }
    //需要初始化条件
    [self.dataSourceArr removeAllObjects];
    self.queryParamModel.page_num = @(1);
    
    if (self.loan_product_type.integerValue) {
        [self prepareDataWithCount:AllDKViewRequestSpecialEntry];
    }else{
        [self prepareDataWithCount:AllDKViewRequestProductList];
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
        case AllDKViewRequestProductList:
            self.cmd = XGetLoanProList;
            self.productListModel.query_param = self.queryParamModel;
            self.dict = [self.productListModel mj_keyValues];
            break;
        case AllDKViewRequestProductType:{
            self.cmd = XGetLoanClassifyList;
            if (self.loanTypeInfo.md5_hash.length) {
                self.dict = @{@"md5_hash":self.loanTypeInfo.md5_hash};
            }else{
                self.dict = @{@"md5_hash":@""};
            }
        }
            break;
        case AllDKViewRequestSpecialEntry:{
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
        case AllDKViewRequestProductList:{
            
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
            if (!self.dataSourceArr.count) {
                self.tableView.tableFooterView = [self creatFooterView];
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            
        }
            break;
        case AllDKViewRequestProductType:{
            if (![self.loanTypeInfo.md5_hash isEqualToString:response.content[@"md5_hash"]]) {
                [[LoanTypeInfo sharedInstance]saveLoanTypeInfo:[LoanTypeInfo mj_objectWithKeyValues:response.content]];
            }
            
            [self setData];
            if (self.loan_product_type.integerValue) {
                [self prepareDataWithCount:AllDKViewRequestSpecialEntry];
            }else{
                [self prepareDataWithCount:AllDKViewRequestProductList];
            }
        }
            break;
        case AllDKViewRequestSpecialEntry:{
           
            [self.dataSourceArr addObjectsFromArray:response.content[@"loan_pro_list"]];
            if (!self.dataSourceArr.count) {
                self.tableView.tableFooterView = [self creatFooterView];
                [self showNoDataAlertView];
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
        [self prepareDataWithCount:AllDKViewRequestSpecialEntry];
    }else{
        self.queryParamModel.page_num = @(self.queryParamModel.page_num.integerValue+1);
        [self prepareDataWithCount:AllDKViewRequestProductList];
    }
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
