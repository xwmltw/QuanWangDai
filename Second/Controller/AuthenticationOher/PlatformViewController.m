//
//  PlatformViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "PlatformViewController.h"
// controller
#import "PlatformDetailViewController.h"
// model
#import "PlatformModel.h"
#import "PlatTableViewCell.h"
@interface PlatformViewController ()
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *modelArr;
/** 状态数组 */
@property (nonatomic,strong) NSMutableArray *statusArr;
/** 中转String*/
@property (nonatomic,strong) NSString *changeString;
@property (nonatomic,strong) PlatformModel *model;
@end

@implementation PlatformViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    /** 请求数据 */
    [self prepareDataWithCount:1];
    /** 表视图 */
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createTableViewHeadView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(already) name:@"already" object:nil];
}
-(void)already
{
    [self headerRefresh];
}

/** 创建头视图 */
-(UIView *)createTableViewHeadView
{
    // UI
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 138)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *mianlabel = [[UILabel alloc]init];
    [mianlabel setText:@"借贷信息"];
    [mianlabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [mianlabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
    UILabel *sublabel = [[UILabel alloc]init];
    [sublabel setNumberOfLines:2];
    [sublabel setText:@"完善借贷信息将极大地提升您的额度，提高贷款通过率。"];
    [sublabel setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [sublabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];

    // addSubview
    [headView addSubview:mianlabel];
    [headView addSubview:sublabel];
    
    // Constraints
    [mianlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(16));
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(- ScreenWidth/2);
    }];
    
    [sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(62));
        make.right.mas_equalTo(headView).offset(-AdaptationWidth(31));
    }];
    
    return headView;
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"";
    PlatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PlatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.title = self.modelArr[indexPath.row];
    cell.marktile = self.statusArr[indexPath.row];
//    /** 信息文本 */
//    UILabel *titlelabel = [[UILabel alloc]init];
//    titlelabel.text = self.modelArr[indexPath.row];
//    [titlelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
//    [titlelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//    [cell addSubview:titlelabel];
//
//    UILabel *marklabel = [[UILabel alloc]init];
//    marklabel.text = self.statusArr[indexPath.row];
//    if ([marklabel.text isEqualToString:@"0"]) {
//        marklabel.text = @"未填写";
//        marklabel.textColor = XColorWithRGB(7,137,133);
//    }else{
//        marklabel.text = @"已填写";
//        [marklabel setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
//    }
//    [marklabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
//    marklabel.textAlignment = NSTextAlignmentRight;
//    [cell addSubview:marklabel];
//
//    /** 分割线 */
//    UIView *lineView = [[UIView alloc]init];
//    [lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
//    lineView.layer.masksToBounds = YES;
//    lineView.layer.cornerRadius = 2;
//    [cell addSubview:lineView];
//
//    /** Constraints */
//    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
//        make.top.mas_equalTo(cell).offset(AdaptationWidth(20));
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(ScreenWidth/2);
//    }];
//    [marklabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(cell).offset(-AdaptationWidth(34));
//        make.top.mas_equalTo(cell).offset(AdaptationWidth(20));
//        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(ScreenWidth/3);
//    }];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
//        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
//        make.bottom.mas_equalTo(cell).offset(AdaptationWidth(0));
//        make.height.mas_equalTo(0.5);
//    }];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlatformDetailViewController *detail = [[PlatformDetailViewController alloc]init];
    detail.name = self.modelArr[indexPath.row];
    detail.model = self.model.loan_plat_list[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)headerRefresh{
    [self prepareDataWithCount:1];
    if (self.dataSourceArr.count) {
        [self.dataSourceArr removeAllObjects];
        [self.modelArr removeAllObjects];
        [self.statusArr removeAllObjects];
    }
}

#pragma  mark - 网络
- (void)setRequestParams
{
    self.cmd = XGetLoanPlatInfo;
    self.dict = @{};
}
- (void)requestSuccessWithDictionary:(XResponse *)response
{
    self.model = [PlatformModel mj_objectWithKeyValues:response.content];
    [self.dataSourceArr addObjectsFromArray:response.content[@"loan_plat_list"]];
    [self.tableView reloadData];
    for (NSDictionary *dic in self.dataSourceArr)
    {
        if (self.dataSourceArr.count )
        {
            switch ([dic[@"plat_type"] integerValue])
            {
                case 1:
                    self.changeString = @"借贷宝信息";
                    break;
                case 2:
                    self.changeString = @"今借到信息";
                    break;
                case 3:
                    self.changeString = @"无忧借条信息";
                    break;
                case 4:
                    self.changeString = @"米房借条信息";
                    break;
                    
                default:
                    break;
            }
            if (self.modelArr.count < 4){
                [self.modelArr addObject:self.changeString];
            }else{
                [self.modelArr removeAllObjects];
            }
        }
    }
    for (NSDictionary *dic in self.dataSourceArr)
    {
        if (self.dataSourceArr.count)
        {
            if (self.statusArr.count < 4) {
                NSString *status = [NSString stringWithFormat:@"%@",dic[@"plat_status"]];
                [self.statusArr addObject:status];
            } else {
                [self.statusArr removeAllObjects];
            }
        }
    }
    
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr =[NSMutableArray array];
    }
    return _modelArr;
}
-(NSMutableArray *)statusArr
{
    if (!_statusArr) {
        _statusArr = [NSMutableArray array];
    }
    return _statusArr;
}

//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"already" object:nil];
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
