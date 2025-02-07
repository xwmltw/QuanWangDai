//
//  ServiceURLVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ServiceURLVC.h"
#import "ParamModel.h"
#import "XSessionMgr.h"
#import "RsaHelper.h"
#import "NSString+NSHash.h"
#import <AdSupport/AdSupport.h>
#import "XDeviceHelper.h"
#import "UpdateView.h"
#import "FeRollingLoader.h"
#import "LLFullScreenAdView.h"
#import "UIImageView+WebCache.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSInteger ,SeviceURLRequest) {
    SeviceURLRequestSignIn,
    SeviceURLRequestGlobalInfo,
    SeviceURLRequestPostDevInfo,
};
@interface ServiceURLVC ()

@property (nonatomic,strong) UIView *bgView;;
@property (nonatomic ,strong) ClientGlobalInfoRM *clientGlobalModel;
@property (nonatomic,strong) UIView *launchView;
@property (nonatomic,strong) LLFullScreenAdView *adView;
@end

@implementation ServiceURLVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您手机系统版本过低，该应用只支持iOS8.0以上使用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
    /*!< 加载首屏 >*/
    [self loadlaunchView];
}

#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case SeviceURLRequestSignIn:
            self.cmd = XUserLogin;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:
                         [[UserInfo sharedInstance]getUserInfo].phoneName,@"username",
                         [[[NSString stringWithFormat:@"%@%@",[[UserInfo sharedInstance]getUserInfo].password,[XSessionMgr sharedInstance].challenge]MD5] uppercaseString],@"password", nil];
            break;
        case SeviceURLRequestGlobalInfo:
            self.cmd = XClientGlobalInfo;
            self.dict = [NSDictionary new];
            break;
        case SeviceURLRequestPostDevInfo:{
           NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            self.cmd = XPostIosDevInfo;
            self.dict = @{@"system":[XDeviceHelper getSysVersionString],
                          @"uid":[XDeviceHelper getUUID],
                          @"dev_name":[XDeviceHelper getPlatformString],
                          @"idfa":idfaStr,
                          @"mac":[XDeviceHelper getIPAddress:YES]
                          };
        }
            break;
        default:
            break;
    }
    
}

-(void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case SeviceURLRequestSignIn:{
            [[UserInfo sharedInstance]savePhone:nil password:nil userId:response.content[@"id"] grantAuthorization:response.content[@"has_grant_authorization"]];
            [self prepareDataWithCount:SeviceURLRequestGlobalInfo];

        }
            break;
        case SeviceURLRequestGlobalInfo:{
            _clientGlobalModel = [ClientGlobalInfoRM mj_objectWithKeyValues:response.content];
            [_clientGlobalModel setClientGlobalInfoModel];
            [self prepareDataWithCount:SeviceURLRequestPostDevInfo];
            //    NSString *urlString = @"http://s8.mogucdn.com/p2/170223/28n_4eb3la6b6b0h78c23d2kf65dj1a92_750x1334.jpg";
            self.clientGlobalModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
            [self.adView reloadAdImageWithUrl:self.clientGlobalModel.open_screen_ad_list[0][@"img_url"]];
            __weak ServiceURLVC *weakself = self;
            self.adView.dismissImageBlock = ^(NSString *content) {// 广告消失事件
                NSLog(@"%@", content);
                /*!< 是否需要更新 >*/
                [weakself isNeedUpdate];

            };
        }
            break;
            
        default:
            break;
    }
}
-(void)loadlaunchView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    self.launchView = viewController.view;
    [self.launchView removeAllSubviews];
    [self.view addSubview:self.launchView];
    
    self.adView = [[LLFullScreenAdView alloc] init];
    self.adView.tag = 199;
    self.adView.duration = 5;
    self.adView.skipType = SkipButtonTypeNormalTimeAndText;
    __weak ServiceURLVC *weakself = self;
    self.adView.adImageTapBlock = ^(NSString *content) {  // 广告点击事件
        NSLog(@"%@", content);
        weakself.clientGlobalModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
        switch ([weakself.clientGlobalModel.open_screen_ad_list[0][@"ad_type"] integerValue]) {
            case 1:{  /*!< 应用内打开 >*/
                XRootWebVC *vc = [[XRootWebVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.url = weakself.clientGlobalModel.open_screen_ad_list[0][@"ad_detail_url"];
                vc.isLunch = YES;
                vc.dismissBlock = ^(NSString *content){
                    [weakself isNeedUpdate];
                };
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{  /*!< 应用外打开 >*/
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:weakself.clientGlobalModel.open_screen_ad_list[0][@"ad_detail_url"]]];
            }
                break;
            case 3:{  /*!< 文章页打开 >*/
                
            }
                break;
                
            default:
                break;
        }

    };
    [self.launchView addSubview:self.adView];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"slogan_logo"];
    [self.launchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(- AdaptationWidth(32));
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(56);
    }];
    [self.view bringSubviewToFront:self.adView];
    [self.view bringSubviewToFront:imageView];
}
- (void)requestFaildWithDictionary:(XResponse *)response{
    
}

- (void)getServiceURL:(XBlock)block{

    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    [allParams setObject:@"qwd_createSession" forKey:@"service"];
    NSMutableDictionary *content = [[[BaseInfoPM alloc]init] mj_keyValues];
    [allParams setObject:content forKey:@"content"];
    //加密
    NSString *changeString = [SecurityUtil encryptAESData:[SecurityUtil dictionaryToJson:allParams]];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//响应格式
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//返回格式
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/javascript", @"text/html", nil];//接受类型
//    [manager POST:SERVICEURL parameters:changeString progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *data = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        //解密
//        NSString *base64String = [SecurityUtil decryptAESData:data];
//        NSDictionary *keyDict = [SecurityUtil dictionaryWithJsonString:base64String];
//        MyLog(@"网络请求返回数据%@",keyDict);
//
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         MyLog(@"网络请求失败%@",error);
//    }];
    
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
        
        if (error) {
            MyLog(@"网络请求失败返回数据%@",error);
            if (!(_bgView == nil)) {
                _bgView.hidden = YES;
                [_bgView removeFromSuperview];
            }
            _bgView = [[UIView alloc]init];
            _bgView.backgroundColor = [UIColor whiteColor];

            UILabel *titlelabel = [[UILabel alloc]init];
            titlelabel.text = @"咦, 网络似乎断了";
            titlelabel.textColor = XColorWithRBBA(34, 58, 80, 0.8);
            titlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
            titlelabel.textAlignment = NSTextAlignmentLeft;

            UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unconneted"]];

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
            XResponse *response = [XResponse mj_objectWithKeyValues:keyDict];
            XSessionMgr *model = [XSessionMgr mj_objectWithKeyValues:response.content];
            
            [RsaHelper setPublicKey:model.pub_key_base64];
            [model setLatestSessionId:response.content[@"sessionId"]];
            XBlockExec(block,nil);
            ;
            if ([[UserInfo sharedInstance] isSignIn2] ) {
                [self prepareDataWithCount:SeviceURLRequestSignIn];
            }else{
                [self prepareDataWithCount:SeviceURLRequestGlobalInfo];
            }

        }
    }];
    [tesk resume];
}
-(void)refreshButtonClick{
    [self getServiceURL:nil];
    _bgView.hidden = YES;
    [_bgView removeFromSuperview];
}

- (void)isNeedUpdate{
    ClientVersionModel *model = _clientGlobalModel.version_info;
    if ([model.need_force_update isEqualToString:@"1"]) {
        //强制更新
        UpdateView *view = [[UpdateView alloc]initWithTitle:@"轻点更新,美梦成真" content:model.version_desc imgUrlStr:@"Update_img" cancel:@"cancel_btn" commit:@"更新"  block:^(NSInteger block) {
            switch (block) {
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.url]];
                    break;
                case 0:{
                    //强制关闭应用
                    exit(0);

                }
                default:
                    break;
            }
        }];
        [[[UIApplication sharedApplication] keyWindow]addSubview:view];
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(doNotForceUpdate)]) {
            [_delegate doNotForceUpdate];
        }
    }
    
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
