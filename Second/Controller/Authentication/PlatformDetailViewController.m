//
//  PlatformDetailViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "PlatformDetailViewController.h"
// model
#import "PlatformModel.h"


@interface PlatformDetailViewController ()<UITextFieldDelegate>
/** 账号和密码输入框 */
@property (nonatomic,strong) UITextField *inputText;
@end

@implementation PlatformDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 创建头视图 */
    [self createTableViewHeadView];
    /** 创建尾视图 */
    [self createTableViewFooterView];
    
    /** 表视图 */
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createTableViewHeadView];
    self.tableView.tableFooterView = [self createTableViewFooterView];
    
    /** 数据源 */
    NSArray *array = [self.name componentsSeparatedByString:@"信"];
    self.dataSourceArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@账号",array[0]],[NSString stringWithFormat:@"%@密码",array[0]], nil];
}

/** 创建头视图 */
-(UIView *)createTableViewHeadView
{
    // UI
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    headView.backgroundColor = [UIColor clearColor];
    
    UILabel *mianlabel = [[UILabel alloc]init];
    [mianlabel setText:self.name];
    [mianlabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [mianlabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    
    // addSubview
    [headView addSubview:mianlabel];
    
    // Constraints
    [mianlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(24));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(16));
        make.height.mas_equalTo(42);
        make.right.mas_equalTo(ScreenWidth/2);
    }];
    
    return headView;
}

/** 创建尾视图 */
-(UIView *)createTableViewFooterView
{
    // UI
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(17)];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = AdaptationWidth(4);
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitBtn];
    
    // Constraints
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.left.mas_equalTo(footerView).offset(AdaptationWidth(24));
        make.width.mas_equalTo(AdaptationWidth(327));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    return footerView;
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"platformCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // UI
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.text = self.dataSourceArr[indexPath.row];
    [titlelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    [titlelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [cell addSubview:titlelabel];
    
    /** 输入框 */
    self.inputText = [[UITextField alloc]init];
    NSArray *array = [self.name componentsSeparatedByString:@"信"];
    NSArray *placearr = @[[NSString stringWithFormat:@"您的%@账号",array[0]],[NSString stringWithFormat:@"您的%@密码",array[0]]];
    if (self.model.plat_account.length > 0 && self.model.plat_account_pwd.length > 0) {
        NSArray *text = @[self.model.plat_account, self.model.plat_account_pwd];
        self.inputText.text = text[indexPath.row];
    }
    self.inputText.placeholder = placearr[indexPath.row];
    self.inputText.backgroundColor = [UIColor clearColor];
    self.inputText.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    self.inputText.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    self.inputText.delegate = self;
    self.inputText.tag = indexPath.row + 1000;
    self.inputText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputText.keyboardType = UIKeyboardTypeDecimalPad;
    if (indexPath.row == 1) {
        self.inputText.secureTextEntry = YES;
    }
    [cell addSubview:self.inputText];
    
    /** 分割线 */
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
    lineView.layer.masksToBounds = YES;
    lineView.layer.cornerRadius = 2;
    [cell addSubview:lineView];
    
    // Constraints
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.top.mas_equalTo(cell).offset(AdaptationWidth(20));
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
    }];
    
    [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.top.mas_equalTo(cell).offset(AdaptationWidth(44));
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24)) ;
        make.height.mas_equalTo(25);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell).offset(AdaptationWidth(24));
        make.right.mas_equalTo(cell).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(cell).offset(AdaptationWidth(0));
        make.height.mas_equalTo(1);
    }];
    
    return cell;
}
-(void)footerRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - click
-(void)submitClick:(UIButton *)button
{
    if (self.inputText.text.length == 0) {
        [self setHudWithName:@"请输入正确的账号和密码" Time:1 andType:1];
        return;
    }
    [self prepareDataWithCount:1];
}

#pragma  mark - 网络
- (void)setRequestParams
{
    self.cmd  = XPostLoanPlatInfo;
    UITextField *account = [self.view viewWithTag:1000];
    UITextField *password = [self.view viewWithTag:1001];
    self.dict = @{@"plat_account"    :account.text,
                  @"plat_account_pwd":password.text,
                  @"plat_type"       :self.model.plat_type,
                  @"plat_info_id"    :self.model.plat_info_id > 0 ? self.model.plat_info_id : @""
                  };
}
- (void)requestSuccessWithDictionary:(XResponse *)response
{
    /** 弹出提示 */
    [self setHudWithName:response.errMsg Time:1 andType:1];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
-(UITextField *)inputText
{
    if (!_inputText) {
        _inputText = [[UITextField alloc]init];
    }
    return _inputText;
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
