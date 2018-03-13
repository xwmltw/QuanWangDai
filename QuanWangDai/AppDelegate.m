//
//  AppDelegate.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/1.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "AppDelegate.h"
#import "XBaseViewController.h"
#import "ServiceURLVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TBCityIconFont.h"
#import "TalkingData.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UserLocation.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>




#define XJDAPP_PLATFORM @"AppStore"

@interface AppDelegate ()<ServiceURLVCDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)UITabBarController *tabVC;//导航栏控制器
@end

@implementation AppDelegate

#pragma mark - 私有方法
/**
 *  懒加载UITabBarController
 */
-(UITabBarController *)tabVC{
    if (!_tabVC) {
        _tabVC = [[UITabBarController alloc]init];
        _tabVC.tabBar.barStyle = UIBarStyleBlack;//设置tabBar类型（也就是颜色 黑，白）
        /*!< 毛玻璃 >*/
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        visualView.frame = _tabVC.tabBar.bounds;
        [_tabVC.tabBar addSubview:visualView];
//        _tabVC.tabBar.translucent = YES;//设置tabBar的半透明度
        _tabVC.tabBar.alpha = 0.96;
        //改变tabbar 线条颜色
        CGRect rect = CGRectMake(0, 0, ScreenWidth, 1);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,
                                       XColorWithRGB(233, 233, 235).CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [ _tabVC.tabBar setShadowImage:img];
        
        CGRect rectc = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
        UIGraphicsBeginImageContext(rectc.size);
        CGContextRef contextc = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(contextc, [UIColor whiteColor].CGColor);
        CGContextFillRect(contextc, rectc);
        UIImage *imagec = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [ _tabVC.tabBar setBackgroundImage:imagec];

    }
    return _tabVC;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.5];
    //第三方配置
    [self addThreeConfig:launchOptions];
    //初始化ttf
    [TBCityIconFont setFontName:@"iconfont"];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ServiceURLVC *vc = [[ServiceURLVC alloc]init];
    [vc getServiceURL:nil];
    vc.delegate = self;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}


- (void)addThreeConfig:(NSDictionary *)launchOptions{
    //键盘
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //网络开启接口打印信息
    [HYBNetworking enableInterfaceDebug:YES];
    [HYBNetworking configRequestType:kHYBRequestTypeJSON
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:TalkingData_AppID withChannelId:XJDAPP_PLATFORM];
    
    //高德
    [AMapServices sharedServices].apiKey = AMapKey;
    [[UserLocation sharedInstance]UserLocation];
    
    // 极光推送
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//清楚badage
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPAppKey
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
}
#pragma mark - ServiceURLVCDelegate
- (void)doNotForceUpdate{
    self.tabVC.viewControllers = [XBaseViewController setAdultTabBar];
    self.window.rootViewController = self.tabVC;
}
#pragma mark - jpush delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    MyLog(@"注册成功 token：%@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    MyLog(@"极光注册失败 With Error: %@", error);
}

    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
   
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//    [WDNotificationCenter postNotificationName:XNotificationAlert object:userInfo];
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

    completionHandler();  // 系统要求执行这个方法
    [WDNotificationCenter postNotificationName:XNotificationAlert object:userInfo];
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

    
    
/**
 *  支付宝返回字段解析
 *
 *  @param AllString            字段
 *  @param FirstSeparateString  第一个分离字段的词
 *  @param SecondSeparateString 第二个分离字段的词
 *
 *  @return 返回字典
 */
-(NSMutableDictionary *)setComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        
    }
    
    return dic;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
        // 其他如支付等SDK的回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                NSString *allString=resultDic[@"result"];
                NSString * FirstSeparateString=@"\"&";
                NSString *  SecondSeparateString=@"=\"";
                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                NSLog(@"ali=%@",dic);
                if ([dic[@"success"]isEqualToString:@"true"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
                }
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:returnStr=@"订单正在处理中";break;
                    case 4000:returnStr=@"订单支付失败";break;
                    case 6001:returnStr=@"订单取消";break;
                    case 6002:returnStr=@"网络连接出错";break;
                    default:break;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
            }
        }];
        return YES;
//    }else {
//
//    }
//    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
        // 其他如支付等SDK的回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
            if (orderState==9000) {
                NSString *allString=resultDic[@"result"];
                NSString * FirstSeparateString=@"\"&";
                NSString *  SecondSeparateString=@"=\"";
                NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
                NSLog(@"ali=%@",dic);
                if ([dic[@"success"]isEqualToString:@"true"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
                }
            }else{
                NSString *returnStr;
                switch (orderState) {
                    case 8000:returnStr=@"订单正在处理中";break;
                    case 4000:returnStr=@"订单支付失败";break;
                    case 6001:returnStr=@"订单取消";break;
                    case 6002:returnStr=@"网络连接出错";break;
                    default:break;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
            }
        }];
        return YES;
//    }
//    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"QuanWangDai"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
