//
//  MyViewController.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/9.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "MyViewController.h"
#import "OpinionFeedBackVC.h"
#import "ModifyPwdVC.h"
#import "LoginVC.h"
#import "MyDataVC.h"
#import "ParamModel.h"
#import "XRootWebVC.h"
#import "XDeviceHelper.h"
#import "AuthorizationVC.h"
#import "XCacheHelper.h"
#import "AutoScrollLabel.h"
#import "ApplyRecordController.h"
#import "BuyRecordController.h"
#import "ContactUsController.h"
#import "QuestionsViewController.h"
#import "SettingController.h"
typedef NS_ENUM(NSInteger ,MineTableViewCell) {
    MineTableViewCellApplyRecord,
    MineTableViewCellBuyRecord,
};
typedef NS_ENUM(NSInteger ,MineTableViewCell2) {
    MineTableViewCellContact,
    MineTableViewCellTip,
};
typedef NS_ENUM(NSInteger ,MineTableViewCell3) {
    MineTableViewCellSetting,
    MineTableViewCellAboutMe,
};
//typedef NS_ENUM(NSInteger ,MineRequest) {
//    MineRequestGetOut,
//};
typedef NS_ENUM(NSInteger,MineBtnOnClick) {
    MineBtnOnClickLogin,
    MineBtnOnClickLookData,
    MineBtnOnClickEnter,
};
@interface MyViewController ()
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic,strong) NSMutableArray *recordArr;
@property (nonatomic,strong) NSMutableArray *middleArr;
@end

@implementation MyViewController
{
    UIImageView *bgImage;
}
-(NSMutableArray *)recordArr{
	if (!_recordArr) {
		_recordArr = [NSMutableArray array];
	}
	return _recordArr;
}
-(NSMutableArray *)middleArr{
    if (!_middleArr) {
        _middleArr = [NSMutableArray array];
    }
    return _middleArr;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tableView.tableHeaderView = [self creatHeadView];
    [self getData];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TalkingData trackEvent:@"【我的】页"];
    [self getData];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)getData{
	[self.recordArr removeAllObjects];
    if (self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 0) {
        [self.recordArr addObject:@(MineTableViewCellApplyRecord)];
        [self.recordArr addObject:@(MineTableViewCellBuyRecord)];
    }
    [self.middleArr removeAllObjects];
    [self.middleArr addObject:@(MineTableViewCellContact)];
    [self.middleArr addObject:@(MineTableViewCellTip)];

    [self.dataSourceArr removeAllObjects];
    [self.dataSourceArr addObject:@(MineTableViewCellSetting)];
    [self.dataSourceArr addObject:@(MineTableViewCellAboutMe)];


}
#pragma mark - tableview
- (UIView *)creatHeadView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(272))];
//    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIButton *bgBtn = [[UIButton alloc]init];
    bgBtn.tag = MineBtnOnClickLookData;
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"mine_card"] forState:UIControlStateNormal];
    [bgBtn setBackgroundImage:[UIImage imageNamed:@"mine_selectCard"] forState:UIControlStateHighlighted];
    [bgBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(4));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(4));
        make.bottom.mas_equalTo(view).offset(-AdaptationWidth(4));
        make.height.mas_equalTo(AdaptationWidth(204));
    }];
    
    
    if (self.clientGlobalInfoModel.notice_manage_list.count) {
        AutoScrollLabel *autoScrollLabel = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(AdaptationWidth(44), AdaptationWidth(28), ScreenWidth - AdaptationWidth(69), AdaptationWidth(30))];
        NSMutableArray *noticeArr = [NSMutableArray array];
        for (NSDictionary *noticeDic in self.clientGlobalInfoModel.notice_manage_list) {
            if (noticeDic.count) {
                [noticeArr addObject:noticeDic[@"notice_manage_content"]];
            }
        };
        NSString *noticeStr = [noticeArr componentsJoinedByString:@","];
        autoScrollLabel.text = noticeStr;
        autoScrollLabel.textColor = XColorWithRGB(252, 93, 109);
        //            autoScrollLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
        [view addSubview:autoScrollLabel];
        
        UIImageView *leftImage = [[UIImageView alloc]init];
        [leftImage setImage:[UIImage imageNamed:@"hue_left"]];
        [view addSubview:leftImage];
        
        UIImageView *broadImage = [[UIImageView alloc]init];
        [broadImage setImage:[UIImage imageNamed:@"broadcast"]];
        broadImage.backgroundColor = [UIColor clearColor];
        [leftImage addSubview:broadImage];
        
        UIImageView *rightImage = [[UIImageView alloc]init];
        [rightImage setImage:[UIImage imageNamed:@"hue_right"]];
        [view addSubview:rightImage];
        
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view);
            make.top.mas_equalTo(view).offset(AdaptationWidth(28));
            make.height.mas_equalTo(AdaptationWidth(30));
            make.width.mas_equalTo(AdaptationWidth(49));
        }];
        
        [broadImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(leftImage).offset(-AdaptationWidth(5));
            make.top.mas_equalTo(leftImage).offset(AdaptationWidth(1));
            make.height.width.mas_equalTo(AdaptationWidth(28));
        }];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view);
            make.top.mas_equalTo(view).offset(AdaptationWidth(28));
            make.height.mas_equalTo(AdaptationWidth(30));
            make.width.mas_equalTo(AdaptationWidth(49));
        }];
    }
    
    if ([[UserInfo sharedInstance]isSignIn] ) {
        UILabel *lab = [[UILabel alloc]init];
        [lab setText:@"嗨, 欢迎回来"];
        [lab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
        [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [view addSubview:lab];
        
        UIImageView *tatooImage = [[UIImageView alloc]init];
        [tatooImage setImage:[UIImage imageNamed:@"tatoo"]];
        [view addSubview:tatooImage];
        
        UILabel *myDataBtn = [[UILabel alloc]init];
        [myDataBtn setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
        [myDataBtn setText:@"查看贷款资料"];
        [myDataBtn setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [view addSubview:myDataBtn];
        
        UILabel *enterBtn = [[UILabel alloc]init];
        [enterBtn setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)]];
        [enterBtn setText:@"戳我！提升贷款通过率" ];
        [enterBtn setTextColor:XColorWithRGB(7, 137, 133) ];
        [view addSubview:enterBtn];
        
        
        UIImageView *cardImage = [[UIImageView alloc]init];
        [cardImage setImage:[UIImage imageNamed:@"mine_file"]];
        [view addSubview:cardImage];
        
        [cardImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgBtn).offset(-AdaptationWidth(28));
            make.bottom.mas_equalTo(bgBtn.mas_bottom).offset(-AdaptationWidth(32));
            make.width.height.mas_equalTo(AdaptationWidth(28));
        }];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgBtn).offset(AdaptationWidth(28));
            make.bottom.mas_equalTo(bgBtn.mas_bottom).offset(-AdaptationWidth(35));
        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgBtn).offset(AdaptationWidth(32));
            make.left.mas_equalTo(bgBtn).offset(AdaptationWidth(28));
            
        }];
        [myDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgBtn).offset(AdaptationWidth(28));
            make.top.mas_equalTo(lab.mas_bottom).offset(AdaptationWidth(4));
        }];
        [tatooImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bgBtn).offset(-AdaptationWidth(16));
            make.top.mas_equalTo(bgBtn).offset(AdaptationWidth(22));
            make.width.height.mas_equalTo(AdaptationWidth(88));
        }];
        
    }else{

        UIButton *lab = [[UIButton alloc]init];
        lab.tag = MineBtnOnClickLogin;
        [lab.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
        [lab setTitle:@"立即登录" forState:UIControlStateNormal];
        [lab setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
        [lab addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:lab];
        
        UIImageView *avatarImage = [[UIImageView alloc]init];
        [avatarImage setImage:[UIImage imageNamed:@"mine_avatar"]];
        [view addSubview:avatarImage];
        
        UIImageView *tatooImage = [[UIImageView alloc]init];
        [tatooImage setImage:[UIImage imageNamed:@"tatoo"]];
        [view addSubview:tatooImage];
        
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(bgImage);
            make.top.mas_equalTo(bgBtn.mas_top).offset(AdaptationWidth(70));
            make.left.mas_equalTo(view).offset(AdaptationWidth(32));
        }];
        
        [avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lab.mas_right).offset(2);
            make.centerY.mas_equalTo(lab);
            make.width.height.mas_equalTo(AdaptationWidth(42));
        }];
        
        [tatooImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view).offset(-AdaptationWidth(20));
            make.centerY.mas_equalTo(lab);
            make.width.height.mas_equalTo(AdaptationWidth(88));
        }];
    }
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView *view = [UIView new];
	view.backgroundColor = XColorWithRBBA(248, 249, 250, 1);
	return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 0.1;
	}
	return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	UIView *view = [UIView new];
	return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	if (section == 0) {
		return 1;
	}
	return 0.1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) {
		return self.recordArr.count;
	}else if (section == 1){
		return self.middleArr.count;
    }else{
        return self.dataSourceArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(64);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mineCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
	
    UILabel *lab = [[UILabel alloc]init];
    [lab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [lab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [cell addSubview:lab];
    
    UIImageView *Image = [[UIImageView alloc]init];
    [cell addSubview:Image];
    
    if ((indexPath.section == 0 && indexPath.row !=1) || indexPath.section == 1) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = XColorWithRGB(233, 233, 235);
        [cell addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
            make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(cell);
        }];
    }
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.top.mas_equalTo(cell).offset(AdaptationWidth(20));
    }];
    [Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(cell);
    }];

	if (indexPath.section == 0) {
		MineTableViewCell row = [self.recordArr[indexPath.row]integerValue];
		switch (row) {
			case MineTableViewCellApplyRecord:{
				[lab setText:@"申请记录"];
				[Image setImage:[UIImage imageNamed:@"icon_recommand_record"]];
			}
				break;
			case MineTableViewCellBuyRecord:{
				[lab setText:@"交易记录"];
				[Image setImage:[UIImage imageNamed:@"icon_trade_record"]];
			}
				break;
				
			default:
				break;
		}
	}else if(indexPath.section == 1){
		MineTableViewCell2 row = [self.middleArr[indexPath.row]integerValue];
		switch (row) {
			case MineTableViewCellContact:{
				[lab setText:@"联系我们"];
				[Image setImage:[UIImage imageNamed:@"icon_contact_us"]];
			}
				break;
            case MineTableViewCellTip:{
                [lab setText:@"攻略与反馈"];
                [Image setImage:[UIImage imageNamed:@"mine_help"]];
            }
                break;
			default:
				break;
        }
	}else{
        MineTableViewCell3 row = [self.dataSourceArr[indexPath.row]integerValue];
        switch (row) {
            case MineTableViewCellSetting:{
                [lab setText:@"设置"];
                [Image setImage:[UIImage imageNamed:@"icon_setting"]];
            }
                break;
            case MineTableViewCellAboutMe:{
                [lab setText:@"关于全网贷"];
                [Image setImage:[UIImage imageNamed:@"mine_aboutMe"]];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
	
	if (indexPath.section == 0 ) {
        if(![[UserInfo sharedInstance]isSignIn] ){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getBlackLogin:self];//判断是否登录状态
            });
            return;
        }
		MineTableViewCell row = [self.recordArr[indexPath.row]integerValue];
		switch (row) {
			case MineTableViewCellApplyRecord:{
                [TalkingData trackEvent:@"【申请记录】页"];
				ApplyRecordController *vc = [[ApplyRecordController alloc]init];
				vc.hidesBottomBarWhenPushed = YES;
				[self.navigationController pushViewController:vc animated:YES];
			}
				break;
			case MineTableViewCellBuyRecord:{
                [TalkingData trackEvent:@"【交易记录】页"];
				BuyRecordController *vc = [[BuyRecordController alloc]init];
				vc.hidesBottomBarWhenPushed = YES;
				[self.navigationController pushViewController:vc animated:YES];
			}
				break;
				
			default:
				break;
		}
	}else if (indexPath.section == 1){
		MineTableViewCell2 row2 = [self.dataSourceArr[indexPath.row]integerValue];
		switch (row2) {
				
			case MineTableViewCellContact:{
				
				ContactUsController *vc = [[ContactUsController alloc]init];
				vc.hidesBottomBarWhenPushed = YES;
				[self.navigationController pushViewController:vc animated:YES];
			}
				
				break;
            case MineTableViewCellTip:{
                
                QuestionsViewController *vc = [[QuestionsViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                
                break;
			default:
				break;
		}
    }else{
        MineTableViewCell3 row3 = [self.dataSourceArr[indexPath.row]integerValue];
        switch (row3) {
            case MineTableViewCellSetting:{
                SettingController *vc = [[SettingController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case MineTableViewCellAboutMe:{
                
                XRootWebVC *vc = [[XRootWebVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                NSString * about_qwd_url = self.clientGlobalInfoModel.wap_url_list.about_qwd_url;
                NSString *version = [XDeviceHelper getAppBundleVersion];
                NSString * about_qwd_url2 = [about_qwd_url stringByAppendingFormat:@"?version=%@&clientType=2",version];
                vc.url = about_qwd_url2;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
         }
    }
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    
    if ([[UserInfo sharedInstance]isSignIn] ) {
        
        [TalkingData trackEvent:@"【我的】-提升贷款通过率"];
        MyDataVC *vc = [[MyDataVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoginVC *vc = [[LoginVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.loginblock = ^(id result) {
            [self showAlertView:nil];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//#pragma mark - 网络
//- (void)setRequestParams{
//    if(self.requestCount == MineRequestGetOut){
//        self.cmd = XUserLogout;
//        self.dict = [NSDictionary dictionary];
//        return;
//    }
//}
//-(void)requestSuccessWithDictionary:(XResponse *)response{
//    if(self.requestCount == MineRequestGetOut){
//        [self setHudWithName:@"退出成功" Time:0.5 andType:3];
//
//        //清空时间状态
//        [WDUserDefaults setValue:@"xwm" forKey:@"UserName"];
//        [WDUserDefaults setValue:@"xwm" forKey:@"tadayDate"];
//        [WDUserDefaults synchronize];
//
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
//        [XCacheHelper clearCacheFolder];
//        LoginVC *vc = [[LoginVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.loginblock = ^(id result) {
//
//            [self showAlertView:nil];
//        };
//        [self.navigationController pushViewController:vc animated:YES];
//
//        return;
//    }
//
//}
- (void)headerRefresh{
    [self.tableView.mj_header endRefreshing];
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
