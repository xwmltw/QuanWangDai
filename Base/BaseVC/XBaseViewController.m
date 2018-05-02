//
//  XBaseViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/2.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "RecommendViewController.h"
#import "CreditViewController.h"
#import "InformationViewController.h"
#import "MyViewController.h"
#import "XSessionMgr.h"
#import "UserInfo.h"
#import "LoginVC.h"
#import "ServiceURLVC.h"
#import <UIImage+GIF.h>
#import <FLAnimatedImage.h>


@interface XBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoRM;
@end

@implementation XBaseViewController
{

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.interactivePopGestureRecognizer.delegate= self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(self.navigationController.childViewControllers.count <= 1){
        return NO;
    }
    return YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.获取系统interactivePopGestureRecognizer对象的target对象
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    //2.创建滑动手势，taregt设置interactivePopGestureRecognizer的target，所以当界面滑动的时候就会自动调用target的action方法。
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
//    [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
//    pan.delegate = self;
//    //3.添加到导航控制器的视图上
//    [self.navigationController.view addGestureRecognizer:pan];
//    //4.禁用系统的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//
    
    if (@available(iOS 11.0, *)) {//适配
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupControllerNavigation];
    [self setBackNavigationBarItem];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
#ifdef DEBUG
    UIViewController *viewCtrl = [XControllerViewHelper getTopViewController];
    NSLog(@"栈顶控制器为%@\n当前显示控制器为%@", [viewCtrl class], [self class]);
#endif
//    NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
//    [TalkingData trackPageBegin:title];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
//    [TalkingData trackPageEnd:title];
}
/**
 *  点击屏幕空白区域，放弃桌面编辑状态
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif

- (void)setupControllerNavigation{
    self.navigationController.navigationBar.translucent = NO;//导航栏底色会闪一下，是黑色一闪而过
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}



#pragma mark -网络请求
/**
 网络请求数据的处理,供子类调用
 
 @param count 标示数据请求的
 */
-(void)prepareDataWithCount:(int)count{
    self.requestCount = count;
    [self setRequestParams];
    [self prepareDataGetUrlWithModel:self.cmd andparmeter:self.dict];
}
/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams{}
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
/**
 网络操作成功
 
 @param response 成功之后的数据
 */
-(void)requestSuccessWithDictionary:(XResponse *)response{}

/**
 网络操作失败
 
 @param response 失败之后的数据
 */
-(void)requestFaildWithDictionary:(XResponse *)response{
    if (response.errCode.integerValue == 34 || response.errCode.integerValue == 31) {//申请人资质没填,信息不完善
        return;
    }
    [self setHudWithName:response.errMsg Time:2 andType:1];
}
/**  网络请求
 *   string:表示请求的cmd dict:表示请求的参数
 */
-(void)prepareDataGetUrlWithModel:(id)model andparmeter:(NSDictionary *)dict{
    
    MBProgressHUD *hud = nil;

    if ([model isEqual:XGetOperatorInfo] || [model isEqual:XPostOperatorVerify] ) {
        UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
        UIViewController *appRootVC = topWindow.rootViewController;
        hud = [MBProgressHUD showHUDAddedTo:appRootVC.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [UIColor clearColor];
//            hud.minShowTime = 3;
//            hud.removeFromSuperViewOnHide = YES;
//            hud.detailsLabel.text = @"加载中...";
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//            imageView.animatedImage = image;
//            hud.color = [UIColor clearColor];
//            hud.color = [hud.color colorWithAlphaComponent:1];
//            hud.customView = imageView;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:model forKey:@"service"];
    NSMutableDictionary *content = [[[BaseInfoPM alloc]init] mj_keyValues];
    [content addEntriesFromDictionary:dict];
    [params setObject:content forKey:@"content"];
    [params setObject:[[XSessionMgr sharedInstance]getLatestSessionId] forKey:@"sessionId"];
    
    NSString *changeString = [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:params]];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SERVICEURL]];
    [request setHTTPMethod:@"POST"];
    //requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //[request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
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
            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
//                [self prepareDataWithCount:self.requestCount];
//            }];
//
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
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
            if(response.errCode.integerValue ==15 && ![self.cmd  isEqual: XGetSpecialLoanProList] && ![self.cmd  isEqual: XGetSpecialEntryList] ) {//登录失效
                [XAlertView alertWithTitle:@"温馨提示" message:response.errMsg cancelButtonTitle:@"取消" confirmButtonTitle:@"去登录" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        LoginVC *vc = [[LoginVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
            [self getDataSourceWithObject:response];
//            if (response.errCode.integerValue == 1) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self getBlackLogin:self];//判断是否登录状态
//                });
//                return;
//            }
        }
    }];
    [tesk resume];
}
-(void)refreshButtonClick
{
    [self prepareDataWithCount:self.requestCount];
    _bgView.hidden = YES;
    [_bgView removeFromSuperview];
}

#pragma end mark
/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type{
    //记录当前的self.navigationController.view，当回到主线程且页面消失，当前的self.navigationController.view可能会消失
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    UIView *superView = appRootVC.view;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.delegate = self;
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabel.text = name;
        hud.contentColor = XColorWithRBBA(34, 58, 80, 0.8);
        hud.bezelView.backgroundColor = XColorWithRBBA(34, 58, 80, 0.8);
        [hud hideAnimated:YES afterDelay:time];
    });
}
#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}
/** 创建TabBar的类方法
 *  返回值是一个数组，数组中的元素是控制器对象
 */
-(NSArray *)setAdultTabBar{
    if (self.clientGlobalInfoRM.recomment_entry_hide.integerValue == 1) {
        NSArray *arr = [self setTabBarWithDict:@{@"controller":@[
                                                         [CreditViewController new],
                                                         [InformationViewController new],
                                                         [MyViewController new]],
                                                 @"title":@[@"信用助手",@"资讯",@"我的"],
                                                 @"imageName":@[@"credit",@"messages",@"mine"]
                                                 }];
         return arr;
    }else{
        NSArray *arr = [self setTabBarWithDict:@{@"controller":@[[RecommendViewController new],
                                                             [CreditViewController new],
                                                             [InformationViewController new],
                                                             [MyViewController new]],
                                             @"title":@[@"推荐",@"信用助手",@"资讯",@"我的"],
                                             @"imageName":@[@"recommend",@"credit",@"messages",@"mine"]
                                             }];
         return arr;
    }
   
}



+(NSArray *)setAdultTabBar{
    XBaseViewController *vc = [XBaseViewController new];
    
    return [vc setAdultTabBar];
}
- (NSArray *)setTabBarWithDict:(NSDictionary *)dict{
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0;i < [dict[@"controller"] count] ; i ++) {
        [mArr addObject:[[UINavigationController alloc]initWithRootViewController:dict[@"controller"][i]]];
    }
    for (int i = 0; i < [dict[@"title"] count]; i++) {
        UIViewController *vc = dict[@"controller"][i];
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:dict[@"title"][i] image:[[UIImage imageNamed:[NSString stringWithFormat:@"%@",dict[@"imageName"][i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",dict[@"imageName"][i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:XColorWithRBBA(34, 58, 80, 0.64),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(10)]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:XColorWithRGB(255, 97, 142),NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(10)]} forState:UIControlStateSelected];
        vc.tabBarItem = item;
    }
    return mArr;
}


#pragma mark - 手势区

-(void)setTapGuestureWithView:(UIView *)view andTapNumber:(int)tapNumber{
    UITapGestureRecognizer *tapGue = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGuesture:)];
    tapGue.numberOfTapsRequired = tapNumber;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGue];
}
/** 点击手势的点击事件
 *  通过 guesture.view 获取点击手势添加的视图
 */
-(void)tapGuesture:(UITapGestureRecognizer *)guesture{}
#pragma mark - tableView

/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
}
/**
 *  返回分区数目(默认为1)
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 *  返回每个分区的个数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh{}

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh{}


/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_back"]];
    imageV.frame = CGRectMake(0, 8, 28, 28);
    imageV.userInteractionEnabled = YES;
    [view addSubview:imageV];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 44);
    button.tag = 9999;
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
    UIView *ringhtV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:ringhtV];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
   
}
/**
     隐藏显示tabbar
 */
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
}

- (void)showTabBar{
    if (self.tabBarController.tabBar.hidden == NO)return;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 是否 登录
 */
- (void)getBlackLogin:(UIViewController *)controller{
            [XAlertView alertWithTitle:@"提示" message:@"您还没有登录唷~请前往登录!" cancelButtonTitle:@"取消" confirmButtonTitle:@"登录" viewController:controller completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    LoginVC *vc = [[LoginVC alloc]init];
                    vc.loginblock = ^(id result) {
    
                        [self showAlertView:nil];
                    };
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
}

- (void)showAlertView:(XBlock)block{
    [XAlertView alertWithTitle:@"温馨提示" message:@"在使用过程中，全网贷会为您推荐相应的贷款产品，您部分必要的个人信息（包括但不限于手机号、工作信息等）可能会根据您的需求，匹配给对应的第三方机构。" cancelButtonTitle:@"不同意" confirmButtonTitle:@"同意授权" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
        self.requestCount = 100;
        if (buttonIndex == 1) {
            XBlockExec(block, nil);
            [[UserInfo sharedInstance]savePhone:nil password:nil userId:nil grantAuthorization:@(1)];
            [self prepareDataGetUrlWithModel:XGrantAuthorization andparmeter:@{@"opt_type":@"1"}];
        }
        if (buttonIndex == 0) {
            
            [[UserInfo sharedInstance]savePhone:nil password:nil userId:nil grantAuthorization:@(2)];
            [self prepareDataGetUrlWithModel:XGrantAuthorization andparmeter:@{@"opt_type":@"2"}];
        }
    }];
}
#pragma mark 懒加载
/**
数据数组的全局变量

@return 数据数组
*/
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
}
- (ClientGlobalInfoRM *)clientGlobalInfoRM{
    if (!_clientGlobalInfoRM) {
        _clientGlobalInfoRM = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoRM;
}
//- (void)dealloc{
//    [WDNotificationCenter removeObserver:self];
//}
@end
