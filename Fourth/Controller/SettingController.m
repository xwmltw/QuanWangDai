//
//  SettingController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "SettingController.h"
#import "ModifyPwdVC.h"
#import "AuthorizationVC.h"
#import "LoginVC.h"
#import "XCacheHelper.h"
typedef NS_ENUM(NSInteger ,SettingCell) {
    SettingCellModifyPwd,
    SettingCellAuthorition,
    SettingCellLoginOut,
};
typedef NS_ENUM(NSInteger ,SettingRequest) {
    SettingRequestGetOut,
};
@interface SettingController ()
@property (nonatomic,strong) UILabel *phoneLab;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@end

@implementation SettingController
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tableView.tableHeaderView = [self createheadView];
    [self.dataSourceArr removeAllObjects];
    [self.dataSourceArr addObject:@(SettingCellModifyPwd)];
    if (self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 0) {
        [self.dataSourceArr addObject:@(SettingCellAuthorition)];
    }
    if ([[UserInfo sharedInstance]isSignIn] ) {
        [self.dataSourceArr addObject:@(SettingCellLoginOut)];
    }
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Login:) name:@"Login" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    


}
-(void)Login:(NSNotification *)notification{
    if([[UserInfo sharedInstance]isSignIn] ){
        NSString *str = [NSString stringWithFormat:@"%@",notification.userInfo[@"login"]];
        _phoneLab.text = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _phoneLab.hidden = NO;
    }
}

-(UIView *)createheadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(89))];
    
    UILabel *TitleLabel = [[UILabel alloc]init];
    [TitleLabel setText:@"设置"];
    [TitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [TitleLabel setTextColor:XColorWithRBBA(77, 96, 114, 1)];
    [headView addSubview:TitleLabel];
    
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(24));
    }];
    
    return headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(64);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * stringID = [NSString stringWithFormat:@"QustionsCell%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringID];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
//    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
    
    UILabel *lab = [[UILabel alloc]init];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [cell addSubview:lab];
    
    UIImageView *Image = [[UIImageView alloc]init];
    [cell addSubview:Image];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(233, 233, 235);
    [cell addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(cell);
    }];
    
    _phoneLab = [[UILabel alloc]init];
    [_phoneLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [_phoneLab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    _phoneLab.hidden = YES;
    [cell addSubview:_phoneLab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.top.mas_equalTo(cell).offset(AdaptationWidth(20));
    }];
    [Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(cell);
    }];
    
    SettingCell row = [self.dataSourceArr[indexPath.row]integerValue];
    switch (row) {
        case SettingCellModifyPwd:{
            [lab setText:@"修改密码"];
            [Image setImage:[UIImage imageNamed:@"mine_modifyPwd"]];
        }
            break;
        case SettingCellAuthorition:{
            [lab setText:@"授权设置"];
            [Image setImage:[UIImage imageNamed:@"mine_Authorization"]];
        }
            break;
        case SettingCellLoginOut:{
            if([[UserInfo sharedInstance]isSignIn] ){
                NSString *str = [UserInfo sharedInstance].phoneName;
                _phoneLab.text = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                _phoneLab.hidden = NO;
            }
            [lab mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell).offset(AdaptationWidth(10));
            }];
            [_phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lab);
                make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(3));
            }];
            [lab setText:@"退出账号"];
            [Image setImage:[UIImage imageNamed:@"mine_getOut"]];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    SettingCell row = [self.dataSourceArr[indexPath.row]integerValue];
    switch (row) {
        case SettingCellModifyPwd:{
            if(![[UserInfo sharedInstance]isSignIn] ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
            ModifyPwdVC *vc = [[ModifyPwdVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SettingCellAuthorition:{
            if(![[UserInfo sharedInstance]isSignIn] ){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getBlackLogin:self];//判断是否登录状态
                });
                return;
            }
            AuthorizationVC *vc = [[AuthorizationVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SettingCellLoginOut:{
            dispatch_async(dispatch_get_main_queue(), ^{
                [XAlertView alertWithTitle:@"温馨提示" message:@"是否退出登录" cancelButtonTitle:@"取消" confirmButtonTitle:@"退出" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self prepareDataWithCount:SettingRequestGetOut];
                    }
                }];
            });
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 网络
- (void)setRequestParams{
    if(self.requestCount == SettingRequestGetOut){
        self.cmd = XUserLogout;
        self.dict = [NSDictionary dictionary];
        return;
    }
}
-(void)requestSuccessWithDictionary:(XResponse *)response{
    if(self.requestCount == SettingRequestGetOut){
        [self setHudWithName:@"退出成功" Time:0.5 andType:3];
        
        //清空时间状态
        [WDUserDefaults setValue:@"xwm" forKey:@"UserName"];
        [WDUserDefaults setValue:@"xwm" forKey:@"tadayDate"];
        [WDUserDefaults synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
        [XCacheHelper clearCacheFolder];
        LoginVC *vc = [[LoginVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isModifyPwd = @(1);
        vc.loginblock = ^(id result) {
            [self showAlertView:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
}
- (void)headerRefresh{
    [self.tableView.mj_header endRefreshing];
}
-(void)dealloc{
    
}

@end
