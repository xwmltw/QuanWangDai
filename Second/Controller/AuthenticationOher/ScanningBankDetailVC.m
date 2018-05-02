//
//  ScanningBankDetailVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ScanningBankDetailVC.h"
#import "XChooseBankView.h"
#import "UITextField+ExtendRange.h"
#import "AuthenticationBankVC.h"
typedef NS_ENUM(NSInteger ,ScanningBankDetailRequest) {
    ScanningBankDetailRequestBankList,
    ScanningBankDetailRequestSupport,
    ScanningBankDetailRequestPostInfo,
};
@interface ScanningBankDetailVC ()<XChooseBankPickerViewDelegate,UITextFieldDelegate>

@end

@implementation ScanningBankDetailVC
{
    UIImageView *image;
    UILabel *bankName;
    UITextField *bankNumer;
    XChooseBankView *chooseBankView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareDataWithCount:ScanningBankDetailRequestBankList];
    
    [self setUI];
}
- (void)setUI{
    UILabel *lblLogin = [[UILabel alloc]init];
    [lblLogin setText:@"银行卡扫描"];
    [lblLogin setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:30]];
    [lblLogin setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:lblLogin];
    
    [lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
    
    }];
    
    image = [[UIImageView alloc]init];
    [image setImage:_bankImage];
    [self.view addSubview:image];
    
    UILabel *detail = [[UILabel alloc]init];
    [detail setText:@"请核对卡号和签发行信息，确认无误。"];
    [detail setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    [detail setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    [self.view addSubview:detail];
    
    UILabel *scanBank = [[UILabel alloc]init];
    [scanBank setText:@"签发银行"];
    [scanBank setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [scanBank setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:scanBank];
    
    bankName = [[UILabel alloc]init];
    [bankName setText:self.model.bank_name];
    [bankName setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18]];
    [bankName setTextColor:XColorWithRGB(7, 137, 133)];
    [self.view addSubview:bankName];
    
    UIButton *selectBank = [[UIButton alloc]init];
    selectBank.tag = 101;
    [selectBank setImage:[UIImage imageNamed:@"credit_expand"] forState:UIControlStateNormal];
    [selectBank addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBank];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:line1];
    
    UILabel *cardBank = [[UILabel alloc]init];
    [cardBank setText:@"银行卡号"];
    [cardBank setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
    [cardBank setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.view addSubview:cardBank];
    
    bankNumer = [[UITextField alloc]init];
    [bankNumer setTextColor:XColorWithRGB(34, 58, 80)];
    bankNumer.text = self.model.bank_card_no;
    bankNumer.clearButtonMode = UITextFieldViewModeAlways;
    bankNumer.backgroundColor = [UIColor whiteColor];
    bankNumer.borderStyle = UITextBorderStyleNone;
    bankNumer.font = [UIFont fontWithName:@"SciFly-Sans" size:AdaptationWidth(18)];
    bankNumer.delegate = self;
    bankNumer.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:bankNumer];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = XColorWithRGB(233, 233, 235);
    [self.view addSubview:line2];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.tag = 102;
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setCornerValue:4];
    [sureBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [sureBtn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    UIButton *againBtn = [[UIButton alloc]init];
    againBtn.tag = 103;
    [againBtn setTitle:@"重新扫描" forState:UIControlStateNormal];
    [againBtn setTitleColor:XColorWithRGB(252, 93, 109) forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againBtn];
    
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(lblLogin.mas_bottom).offset(AdaptationWidth(32));
        make.height.mas_equalTo(AdaptationWidth(80));
    }];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(image.mas_bottom).offset(AdaptationWidth(8));
    }];
    [scanBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(detail.mas_bottom).offset(AdaptationWidth(32));
    }];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(scanBank.mas_bottom).offset(AdaptationWidth(8));
    }];
    [selectBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.centerY.mas_equalTo(bankName);
        make.width.height.mas_equalTo(AdaptationWidth(28));
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(bankName.mas_bottom).offset(AdaptationWidth(15));
        make.height.mas_equalTo(AdaptationWidth(0.5));
    }];
    
    [cardBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(line1.mas_bottom).offset(AdaptationWidth(15));
    }];
    [bankNumer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(cardBank.mas_bottom).offset(AdaptationWidth(8));
        make.height.mas_equalTo(AdaptationWidth(35));
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(bankNumer.mas_bottom).offset(AdaptationWidth(15));
        make.height.mas_equalTo(AdaptationWidth(0.5));
    }];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(line2.mas_bottom).offset(AdaptationWidth(15));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    [againBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sureBtn);
        make.top.mas_equalTo(sureBtn.mas_bottom).offset(AdaptationWidth(15));
    }];
    
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:{
            [self showBankPickerView];
        }
            break;
        case 102:{
            if (bankNumer.text.length == 0) {
                [self setHudWithName:@"请输入银行卡号" Time:0.5 andType:1];
                return;
            }
            [self prepareDataWithCount:ScanningBankDetailRequestSupport];
            
        }
            break;
        case 103:{
            [self startBankCardOCR];//开始扫描银行卡
        }
            break;
            
        default:
            break;
    }
}
- (void)showBankPickerView
{
    
    NSMutableArray *bankNameArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in self.dataSourceArr) {
        [bankNameArray addObject:dic[@"bank_name"]];
    }
    chooseBankView = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    chooseBankView.delegate = self;
    chooseBankView.chooseThings = bankNameArray;
    [chooseBankView showView];
}

- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row
{
    bankName.text = thing;
}

#pragma mark - UITextFieldDelegate

static NSInteger const kGroupSize = 4;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == bankNumer) {
        
        NSString *text = textField.text;
        NSString *beingString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *cardNo = [self removingSapceString:beingString];
        //校验卡号只能是数字，且不能超过20位
        if ( (string.length != 0 && ![self isValidNumbers:cardNo]) || cardNo.length > 20) {
            [self setHudWithName:@"银行卡卡号只能是数字，且不能超过20位"Time:1 andType:1];
            return NO;
        }
        //获取【光标右侧的数字个数】
        NSInteger rightNumberCount = [self removingSapceString:[text substringFromIndex:textField.selectedRange.location + textField.selectedRange.length]].length;
        //输入长度大于4 需要对数字进行分组，每4个一组，用空格隔开
        if (beingString.length > kGroupSize) {
            textField.text = [self groupedString:beingString];
        } else {
            textField.text = beingString;
        }
        text = textField.text;
        /**
         * 计算光标位置(相对末尾)
         * 光标右侧空格数 = 所有的空格数 - 光标左侧的空格数
         * 光标位置 = 【光标右侧的数字个数】+ 光标右侧空格数
         */
        NSInteger rightOffset = [self rightOffsetWithCardNoLength:cardNo.length rightNumberCount:rightNumberCount];
        NSRange currentSelectedRange = NSMakeRange(text.length - rightOffset, 0);
        
        //如果光标左侧是一个空格，则光标回退一格
        if (currentSelectedRange.location > 0 && [[text substringWithRange:NSMakeRange(currentSelectedRange.location - 1, 1)] isEqualToString:@" "]) {
            currentSelectedRange.location -= 1;
        }
        [textField setSelectedRange:currentSelectedRange];
        return NO;
    }else {
        return NO;
    }
}
//pragma mark - Helper
/**
 *  计算光标相对末尾的位置偏移
 *
 *  @param length           卡号的长度(不包括空格)
 *  @param rightNumberCount 光标右侧的数字个数
 *
 *  @return 光标相对末尾的位置偏移
 */
- (NSInteger)rightOffsetWithCardNoLength:(NSInteger)length rightNumberCount:(NSInteger)rightNumberCount {
    NSInteger totalGroupCount = [self groupCountWithLength:length];
    NSInteger leftGroupCount = [self groupCountWithLength:length - rightNumberCount];
    NSInteger totalWhiteSpace = totalGroupCount -1 > 0? totalGroupCount - 1 : 0;
    NSInteger leftWhiteSpace = leftGroupCount -1 > 0? leftGroupCount - 1 : 0;
    return rightNumberCount + (totalWhiteSpace - leftWhiteSpace);
}

/**
 *  校验给定字符串是否是纯数字
 *
 *  @param numberStr 字符串
 *
 *  @return 字符串是否是纯数字
 */
- (BOOL)isValidNumbers:(NSString *)numberStr {
    NSString* numberRegex = @"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberPre evaluateWithObject:numberStr];
}

/**
 *  去除字符串中包含的空格
 *
 *  @param str 字符串
 *
 *  @return 去除空格后的字符串
 */
- (NSString *)removingSapceString:(NSString *)str {
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
}

/**
 *  根据长度计算分组的个数
 *
 *  @param length 长度
 *
 *  @return 分组的个数
 */
- (NSInteger)groupCountWithLength:(NSInteger)length {
    return (NSInteger)ceilf((CGFloat)length /kGroupSize);
}

/**
 *  给定字符串根据指定的个数进行分组，每一组用空格分隔
 *
 *  @param string 字符串
 *
 *  @return 分组后的字符串
 */
- (NSString *)groupedString:(NSString *)string {
    NSString *str = [self removingSapceString:string];
    NSInteger groupCount = [self groupCountWithLength:str.length];
    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < groupCount; i++) {
        if (i*kGroupSize + kGroupSize > str.length) {
            [components addObject:[str substringFromIndex:i*kGroupSize]];
        } else {
            [components addObject:[str substringWithRange:NSMakeRange(i*kGroupSize, kGroupSize)]];
        }
    }
    NSString *groupedString = [components componentsJoinedByString:@" "];
    return groupedString;
}

- (void)textFieldDidChange:(UITextField *)textField{
    UITextRange *selectedRange = textField.markedTextRange;
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        // 没有高亮选择的字
        // 1. 过滤非汉字、字母、数字字符
        textField.text = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
    } else {
        // 有高亮选择的字 不做任何操作
    }
}

// 过滤字符串中的非汉字、字母、数字
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSLog(@"regex is %@", regex);
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    NSLog(@"result is %@", result);
    
    return result;
}
/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name
{
    MyLog(@"%s", __func__);
    self.model.bank_card_no = bank_num;
    self.model.bank_name = bank_name;
    self.model.true_name = card_name;
    [bankName setText:self.model.bank_name];
    bankNumer.text = self.model.bank_card_no;
}
/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage
{
    [image setImage:BankCardImage];
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case ScanningBankDetailRequestBankList:
            self.cmd = XGetSupportedBankList;
            self.dict = [NSDictionary dictionary];
            break;
        case ScanningBankDetailRequestSupport:
            self.cmd = XGetBankIsSupported;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:bankName.text,@"bank_name", nil];
            
            
            break;
        case ScanningBankDetailRequestPostInfo:
//            self.cmd = XGetSupportedBankList;
//            self.dict = @{};
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ScanningBankDetailRequestBankList:
            self.dataSourceArr = response.content[@"bank_list"];
            break;
        case ScanningBankDetailRequestSupport:{
            
            XBlockExec(self.block,bankName.text,bankNumer.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case ScanningBankDetailRequestPostInfo:
            
            break;
            
        default:
            break;
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
