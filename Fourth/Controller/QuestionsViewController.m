//
//  QuestionsViewController.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "QuestionsViewController.h"
#import "OpinionFeedBackVC.h"
#import "QustionsCell.h"
#import "ContactUsController.h"
#import "QuestionModel.h"
typedef NS_ENUM(NSInteger , QuestionsRequest) {
    QuestionsRequestInfo,
};
@interface QuestionsViewController ()<QustionsCellDelegate>
{
    NSMutableArray *indexPaths;
}
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) QuestionModel *questionModel;
@property (nonatomic,strong) NSMutableArray *middleArr;
@end

@implementation QuestionsViewController
-(QuestionModel *)questionModel{
    if (!_questionModel) {
        _questionModel = [[QuestionModel alloc]init];
    }
    return _questionModel;
}
-(NSMutableArray *)middleArr{
    if (!_middleArr) {
        _middleArr = [NSMutableArray array];
    }
    return _middleArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *problemBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(65), AdaptationWidth(30))];
    problemBtn.tag = 200;
    [problemBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
    [problemBtn setTitleColor:XColorWithRGB(34, 58, 80) forState:UIControlStateNormal];
    [problemBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
    [problemBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:problemBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(56));
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self createheadView];
    [self prepareDataWithCount:QuestionsRequestInfo];
    [self createBottomBTN];
    indexPaths = [NSMutableArray array];
}
-(void)btnOnClick:(UIButton *)button{
    switch (button.tag) {
        case 200:{
            OpinionFeedBackVC *vc = [[OpinionFeedBackVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 100:
        case 101:{
            ContactUsController *vc = [[ContactUsController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(UIView *)createheadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(89))];
    
    UILabel *TitleLabel = [[UILabel alloc]init];
    [TitleLabel setText:@"常见问题"];
    [TitleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [TitleLabel setTextColor:XColorWithRBBA(77, 96, 114, 1)];
    [headView addSubview:TitleLabel];
    
    [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(AdaptationWidth(32));
        make.top.mas_equalTo(headView).offset(AdaptationWidth(24));
    }];
    
    return headView;
}
-(void)createBottomBTN{
    UIButton *btnContinue = [[UIButton alloc]init];
    btnContinue.tag = 100;
    [btnContinue setTitle:@"官方 Q 群" forState:UIControlStateNormal];
    [btnContinue setBackgroundColor:XColorWithRGB(255, 255, 255)];
    [btnContinue setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [btnContinue addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnContinue];
    
    UIButton *btnBack = [[UIButton alloc]init];
    btnBack.tag = 101;
    [btnBack setTitle:@"微信公众号" forState:UIControlStateNormal];
    [btnBack setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [btnBack  setTitleColor:XColorWithRBBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    [btnContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
    
    [btnBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(188));
        make.height.mas_equalTo(AdaptationWidth(56));
    }];
}
#pragma mark - 一一一一一 <* QustionsCellDelegate *> 一一一一一
-(void)isSelectedOrNot:(UIButton *)button{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.questionModel = [QuestionModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    if (self.questionModel.isExpand == YES){
        if ([indexPaths containsObject:indexPath]) {
            NSString *textStr = self.dataSourceArr[indexPath.row][@"help_content"];
            CGFloat fontSize = 14.0;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
             CGSize size = [textStr boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(48), 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            CGFloat f = size.height + 62 ;
            return f;
        }
    }else{
        if ([indexPaths containsObject:indexPath]) {
            NSString *textStr = self.dataSourceArr[indexPath.row][@"help_content"];
            CGFloat fontSize = 14.0;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
            CGSize size = [textStr boundingRectWithSize:CGSizeMake(ScreenWidth - AdaptationWidth(48), 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            CGFloat f = size.height + 62 ;
            return f;
        }
    }
    return 62;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * stringID = [NSString stringWithFormat:@"QustionsCell%ld",(long)indexPath.row];
    QustionsCell *cell = [tableView dequeueReusableCellWithIdentifier:stringID];
    if (!cell) {
        cell = [[QustionsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringID];
    }
    cell.model = self.middleArr[indexPath.row];
    cell.tipButton.tag = indexPath.row;
//    for (int i = 0; i < self.middleArr.count; i ++) {
//        if (i == indexPath.row) {
//            CABasicAnimation *rotationAnimation;
//            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI/2.0];
//            rotationAnimation.duration = 0.5;
//            rotationAnimation.repeatCount = 1;
//            [cell.tipImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
//        }
//    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if ([indexPaths containsObject:indexPath]) {
        [indexPaths removeObject:indexPath];
        for (int i = 0; i < self.dataSourceArr.count; i ++) {
            if (i == indexPath.row) {
                self.questionModel = self.middleArr[i];
                self.questionModel.isExpand = NO;
            }
        }
    }else{
        [indexPaths addObject:indexPath];
        for (int i = 0; i < self.dataSourceArr.count; i ++) {
            if (i == indexPath.row) {
                self.questionModel = self.middleArr[i];
                self.questionModel.isExpand = YES;
            }
        }
    }
    [UIView transitionWithView: self.tableView
                      duration: 0.3f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void){
         [self.tableView reloadData];
     }completion: ^(BOOL isFinished){
     }];
}

#pragma  mark - request
- (void)setRequestParams{
    switch (self.requestCount) {
        case QuestionsRequestInfo:
            self.cmd = XGetHelpCenterList;
            self.dict =[NSDictionary new];
            break;
            
        default:
            break;
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case QuestionsRequestInfo:{
            self.dataSourceArr = response.content[@"help_list"];
            [self.dataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                self.questionModel = [QuestionModel mj_objectWithKeyValues:obj];
                [self.middleArr addObject:self.questionModel];
            }];
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)headerRefresh{
    [self prepareDataWithCount:QuestionsRequestInfo];
}
@end
