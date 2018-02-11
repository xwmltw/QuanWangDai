//
//  MyDataVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/20.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "MyDataVC.h"
#import "CreditInfoModel.h"
#import "CreditViewController.h"

#import "IdentityAuthenticationVC.h"
#import "CreditInfoModel.h"
#import "ZMAuthenticationVC.h"
#import "BaseInfoVC.h"
#import "OperatorAuthenticationVC.h"
#import "AuthenticationBankVC.h"
#import "CertifiedBankVC.h"

typedef NS_ENUM(NSInteger, MyDataRequest) {
    MyDataRequestInfo,
};
@interface MyDataVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@end

@implementation MyDataVC
static NSString *identifier = @"myDataCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataWithCount:MyDataRequestInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Refresh) name:@"Refresh" object:nil];
}

-(void)Refresh
{
    [self prepareDataWithCount:MyDataRequestInfo];
}
- (void)setUI{
    UILabel *title = [[UILabel alloc]init];
    [title setText:@"我的贷款资料"];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [title setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:title];
    
    UILabel *detail = [[UILabel alloc]init];
    [detail setText:@"完成信用评测，获取专属贷款通道，通过率高"];
    [detail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [detail setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:detail];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(40));
    }];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(title.mas_bottom).offset(AdaptationWidth(4));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(AdaptationWidth(72), AdaptationWidth(73));
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    [self.view addSubview:_collectionView];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(detail.mas_bottom).offset(AdaptationWidth(30));
    }];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(AdaptationWidth(80), AdaptationWidth(81));
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    UIImageView *image = [[UIImageView alloc]init];
    [cell.contentView addSubview:image];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
    [nameLab setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [cell.contentView addSubview:nameLab];
    
    UIImageView *authImage = [[UIImageView alloc]init];
    [cell.contentView addSubview:authImage];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(cell.contentView);
        make.centerX.mas_equalTo(cell.contentView);
        make.bottom.mas_equalTo(nameLab.mas_top).offset(-AdaptationWidth(2));
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(cell.contentView);
    }];
    [authImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(image);
    }];
    switch (indexPath.row) {
        case 0:
            [nameLab setText:@"身份认证"];
            [image setImage:[UIImage imageNamed:@"myData_identity"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconCardInfoP"]];
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case 1:
            if (self.creditInfoModel.zhima_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_authorization"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            [nameLab setText:@"芝麻信用认证"];
            [image setImage:[UIImage imageNamed:@"myData_ZMXY"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconZhimaInfoP"]];
            break;
        case 2:
            if (self.creditInfoModel.base_info_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_edit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            [nameLab setText:@"基本信息认证"];
            [image setImage:[UIImage imageNamed:@"myData_baseInfo"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconBaseInfoP"]];
            break;
        case 3:
            [nameLab setText:@"运营商认证"];
            [image setImage:[UIImage imageNamed:@"myData_YYS"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconOperatorInfoP"]];
            if (self.creditInfoModel.operator_status.integerValue == 1) {
                [authImage setImage:[UIImage imageNamed:@"credit_credit"]];
                authImage.hidden = NO;
            }else{
                authImage.hidden = YES;
            }
            break;
        case 4:
            authImage.hidden = YES;
            [nameLab setText:@"更多认证"];
            [image setImage:[UIImage imageNamed:@"myData_more"]];
            [image setHighlightedImage:[UIImage imageNamed:@"iconMoreP"]];
            break;
            
        default:
            break;
    }
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            IdentityAuthenticationVC *vc = [[IdentityAuthenticationVC alloc]init];
            vc.creditInfoModel = self.creditInfoModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            if (self.creditInfoModel.zhima_status.integerValue == 1) {
                [self setHudWithName:@"芝麻信用已认证" Time:0.5 andType:3];
                return;
            }
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                ZMAuthenticationVC *vc = [[ZMAuthenticationVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
        }
            break;
        case 2:{
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                BaseInfoVC *vc = [[BaseInfoVC alloc]init];
                vc.creditInfoModel = self.creditInfoModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
        }
            break;
        case 3:{
            if (self.creditInfoModel.identity_status.integerValue == 1) {
                if (self.creditInfoModel.base_info_status.integerValue == 1) {
                    OperatorAuthenticationVC *vc = [[OperatorAuthenticationVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self setHudWithName:@"请先完成基本信息认证" Time:0.5 andType:3];
                }
                
            }else{
                [self setHudWithName:@"请先完成身份认证" Time:0.5 andType:3];
            }
            
        }
            break;
        case 4:{
            if (self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 1) {
                self.tabBarController.selectedIndex = 0;
            }else{
                self.tabBarController.selectedIndex = 1;
            }
//            CreditViewController *vc = [[CreditViewController alloc]init];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
            
        default:
            break;
    }
}
#pragma  mark - 网络
- (void)setRequestParams{
    self.cmd = XGetCreditInfo;
    self.dict = @{};
}
-(void)requestSuccessWithDictionary:(XResponse *)response{
    self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.content];
    [self setUI];
    [self.collectionView reloadData];
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel alloc]init];
    }
    return _creditInfoModel;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Refresh" object:nil];
//}

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
