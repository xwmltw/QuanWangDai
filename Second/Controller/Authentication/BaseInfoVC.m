//
//  BaseInfoVC.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/24.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "BaseInfoVC.h"
#import "BaseInfoCellText.h"
#import "BaseInfoCellView.h"
#import "XChooseCityView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import "BaseInfoModel.h"
#import "XChooseBankView.h"
#import "AuthorizationView.h"
#import "XRootWebVC.h"
typedef NS_ENUM(NSInteger ,BaseInfoRequest) {
    BaseInfoRequestPostInfo,
    BaseInfoRequestGetInfo,
};
@interface BaseInfoVC ()<BaseInfoCellTextDelegate,BaseInfoCellViewDelegate,XChooseCityViewDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,XChooseBankPickerViewDelegate>
//从通讯录拿到的数据
@property (nonatomic, strong) NSMutableArray *allContactArray;
@property (nonatomic, strong) NSMutableDictionary *allContactDic;
@property (nonatomic, strong) BaseInfoModel *baseInfoModel;
@property (nonatomic, strong) ShipModel *parentModel;
@property (nonatomic, strong) ShipModel *contactModel;
@property (nonatomic, strong) ClientGlobalInfoRM *clientGlobalInfoModel;
@property (nonatomic, strong) AuthorizationView *authView;
@end

@implementation BaseInfoVC
{
    
    NSMutableDictionary *titleDic;
    NSArray *dataArry;
    XChooseCityView *cityView;
    XChooseBankView *pickerView;
    NSInteger parentRow;
    NSInteger pickerRow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.tableHeaderView = [self creatHeaderView];
    self.tableView.tableFooterView = [self creatFooderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerClass:[BaseInfoCellView class] forCellReuseIdentifier:NSStringFromClass([BaseInfoCellView class])];
    [self.tableView registerClass:[BaseInfoCellText class] forCellReuseIdentifier:NSStringFromClass([BaseInfoCellText class])];
    
    [self prepareDataWithCount:BaseInfoRequestGetInfo];
    
}
- (void)setData{
    self.allContactArray = [NSMutableArray array];
    self.allContactDic = [NSMutableDictionary dictionary];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellMarriage)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellCity)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellMyAddress)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellRelative)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellParentsPhone)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellRelativeCity)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellRelativeAddress)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellContactRelation)];
    [self.dataSourceArr addObject:@(BaseInfoTableViewCellContactPhone)];
    

    dataArry = @[@[@"已婚",@"未婚",@"其他"],@[],@[],@[@"父母",@"配偶"],@[],@[],@[],@[@"同事",@"朋友",@"亲戚",@"其他"],@[]];
    
}
#pragma  mark - tableView
- (UIView *)creatHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(70))];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"基本信息认证";
    [titleLab setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [titleLab setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)]];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.top.mas_equalTo(view).offset(AdaptationWidth(16));
    }];

    return view;
}
- (UIView *)creatFooderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(132))];
    
    self.authView = [[AuthorizationView alloc]init];
    [self.authView.AgreementBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.authView.TickBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.authView];
    
    
    UIButton *sureBtn  = [[UIButton alloc]init];
    sureBtn.tag = 100;
    [sureBtn setCornerValue:5];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    [sureBtn setBackgroundColor:XColorWithRGB(252, 93, 109)];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureBtn];
    
    if (self.creditInfoModel.base_info_status.integerValue == 1 || self.clientGlobalInfoModel.recomment_entry_hide.integerValue == 1) {//判断是否认证过
        self.authView.hidden = YES;
        view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(80));
    }
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(view).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(view).offset(-AdaptationWidth(16));
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view);
        make.right.mas_equalTo(view);
        make.bottom.mas_equalTo(sureBtn.mas_top);
        make.height.mas_equalTo(AdaptationWidth(68));
    }];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(89);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseInfoTableViewCell row = [self.dataSourceArr[indexPath.row]integerValue];
    switch (row) {
        case BaseInfoTableViewCellMarriage:
        case BaseInfoTableViewCellCity:
        case BaseInfoTableViewCellRelative:
        case BaseInfoTableViewCellParentsPhone:
        case BaseInfoTableViewCellRelativeCity:
        case BaseInfoTableViewCellContactRelation:
        case BaseInfoTableViewCellContactPhone:{
            
            BaseInfoCellView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoCellView class]) forIndexPath:indexPath];
            cell.delegate = self;
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
            cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
            [cell setDataModel:self.baseInfoModel with:indexPath.row];
    
            return cell;
        }
            break;
        case BaseInfoTableViewCellMyAddress:
        case BaseInfoTableViewCellRelativeAddress:{
            BaseInfoCellText *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaseInfoCellText class])forIndexPath:indexPath];
            
            cell.delegate = self;
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
            cell.selectedBackgroundView.backgroundColor = XColorWithRGB(248, 249, 250);
            [cell setDataModel:self.baseInfoModel with:indexPath.row];

            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseInfoTableViewCell row = [self.dataSourceArr[indexPath.row]integerValue];
    switch (row) {
        case BaseInfoTableViewCellMarriage:
        case BaseInfoTableViewCellRelative:
        case BaseInfoTableViewCellContactRelation:{
            [self selectOnClick:row];
        }
            break;
        case BaseInfoTableViewCellParentsPhone:
        case BaseInfoTableViewCellContactPhone:{
            parentRow = row;
            [self getContactPermission];
        }
            break;
        case BaseInfoTableViewCellCity:
        case BaseInfoTableViewCellRelativeCity:{
            cityView = [[XChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            cityView.tag = row;
            cityView.delegate = self;
            [cityView showView];
        }
            break;
            
        default:
            break;
    }
}
#pragma  mark - delegate
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(XChooseCityView *)chooseView{
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", province, city, town];
    switch (chooseView.tag) {
        case BaseInfoTableViewCellCity:{
            if (town.length) {
                self.baseInfoModel.home_province = province;
                self.baseInfoModel.home_city = city;
                self.baseInfoModel.home_town = town;
            }else{
                self.baseInfoModel.home_province = province;
                self.baseInfoModel.home_city = province;
                self.baseInfoModel.home_town = city;
            }
            
            
            
        }
            break;
        case BaseInfoTableViewCellRelativeCity:{
            self.parentModel.ship_province_city_town = address;
            
        }
            break;
            
        default:
            break;
    }

    
    [self.tableView reloadData];
}
- (void)ViewBtnOnClick:(UITextField *)textField{
    switch (textField.tag) {
        case BaseInfoTableViewCellParentsPhone:
            self.parentModel.ship_name = textField.text;
            break;
        case BaseInfoTableViewCellContactPhone:
            self.contactModel.ship_name = textField.text;
            break;
            
        default:
            break;
    }
}
- (void)selectOnClick:(NSInteger)tag{
    switch (tag) {
        case BaseInfoTableViewCellMarriage:
        case BaseInfoTableViewCellContactRelation:
        case BaseInfoTableViewCellRelative:{
            pickerRow = tag;
            pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            pickerView.delegate = self;
            pickerView.chooseThings = dataArry[tag];
            [pickerView showView];
//            [YBPopupMenu showRelyOnView:btn titles:dataArry[btn.tag] icons:nil menuWidth:AdaptationWidth(100) delegate:self];
        }
            break;
        case BaseInfoTableViewCellParentsPhone:
        case BaseInfoTableViewCellContactPhone:{
            parentRow = tag;
            [self getContactPermission];
        }
            break;
        default:
            break;
    }
}
- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row{
    switch (pickerRow) {
        case BaseInfoTableViewCellMarriage:
            self.baseInfoModel.is_marry = dataArry[pickerRow][row];
            break;
        case BaseInfoTableViewCellContactRelation:{
            self.contactModel.ship_type = @(1);
            self.contactModel.relationship = dataArry[pickerRow][row];
            break;
        }
        case BaseInfoTableViewCellRelative:{
            self.parentModel.ship_type = @(0);
            self.parentModel.relationship = dataArry[pickerRow][row];
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}
- (void)textBtnOnClick:(UITextField *)textField{
    switch (textField.tag) {
        case BaseInfoTableViewCellMyAddress:
            self.baseInfoModel.home_address = textField.text;
            break;
        case BaseInfoTableViewCellRelativeAddress:
            self.parentModel.ship_address = textField.text;
            break;
            
        default:
            break;
    }
}
//#pragma mark - YBPopupMenu
//- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
//    switch (YPBtn) {
//        case BaseInfoTableViewCellMarriage:
//            self.baseInfoModel.is_marry = dataArry[YPBtn][index];
//            break;
//        case BaseInfoTableViewCellContactRelation:{
//            self.contactModel.ship_type = @(index);
//            self.contactModel.relationship = dataArry[YPBtn][index];
//            break;
//        }
//        case BaseInfoTableViewCellRelative:{
//            self.parentModel.ship_type = @(index);
//            self.parentModel.relationship = dataArry[YPBtn][index];
//        }
//            break;
//        default:
//            break;
//    }
//    [self.tableView reloadData];
//}
#pragma  mark - 获取本地联系方式
- (void)getContactPermission{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
                ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
                nav.peoplePickerDelegate = self;
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录按钮"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        
                    }
                }
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self presentContactController];
            }];
        }else {
            [self presentContactController];
        }
    }
}

- (void)presentContactController
{
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        CNContactPickerViewController *contactPickerVc = [CNContactPickerViewController new];
        
        contactPickerVc.delegate = self;
        
        [self presentViewController:contactPickerVc animated:YES completion:^{
            [self getAllContactsAuthorization];
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusDenied) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录按钮"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)getAllContactsAuthorization
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self getAllContacts];
            }];
        }else {
            [self getAllContacts];
        }
    }
}

- (void)getAllContacts
{
    if (_allContactArray.count > 0) {
        return;
    }
    [_allContactArray removeAllObjects];
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        //如果被授权访问通讯录,进行访问相关操作
        CNContactStore *contactStore = [CNContactStore new];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]];
        
        NSError *error = nil;
        
        BOOL result = [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *phoneName = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
            NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
            NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:charactersToEscape];
            phoneName = [phoneName stringByTrimmingCharactersInSet:allowedCharacters];
            NSString *phone = @"";
            int i = 0;
            for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                ++i;
                if (i<contact.phoneNumbers.count) {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }else {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }
               
            }
            if (phoneName.length) {
                NSDictionary *contactDict = @{@"phone_name":phoneName, @"phone":phone};
                [_allContactArray addObject:contactDict];
            }
            
        }];
        
        if (!result) {
            NSLog(@"读取失败,error:%@",error);
            return;
        }
        NSLog(@"读取成功");
        self.baseInfoModel.phone_name_list = _allContactArray;
    }
}

#pragma mark - 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    CNContact *contact = contactProperty.contact;
    
    if ([contactProperty.value isKindOfClass:[NSString class]]) {
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
  
    switch (parentRow) {
        case BaseInfoTableViewCellParentsPhone:
        {
            self.parentModel.ship_name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            self.parentModel.ship_contact = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        }
            break;
        case BaseInfoTableViewCellContactPhone:
        {
            self.contactModel.ship_name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            self.contactModel.ship_contact = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    
    
    
    
//    if ([_whichPhone isEqualToString:@"parent"]) {
//        if (_needToChangeName) {
//            _parentNameText.text = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
//        }
//        _parentPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
//        _parentPhoneLabel.textColor = XColorWithRGB(34, 58, 80);
//        _parentPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
//    }else if ([_whichPhone isEqualToString:@"friend"]) {
//        if (_needToChangeName) {
//            _friendNameText.text = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
//        }
//        _friendPhoneLabel.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
//        _friendPhoneLabel.textColor = XColorWithRGB(34, 58, 80);
//        _friendPhoneStr = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
//    }
}

- (NSString *)phoneStringWithNoSpaceAndDash:(NSString *)string
{
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if(filteredStr.length == 13 ){//去除86开头
        filteredStr = [filteredStr substringFromIndex:2];
    }
    return filteredStr;
}

- (BOOL)phoneStringWithNSPredicate:(NSString *)string{
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
#pragma mark - 支持iOS9以下获取通讯录
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    //获取联系人名称和电话号码
    switch (parentRow) {
        case BaseInfoTableViewCellParentsPhone:
        {
            self.parentModel.ship_name = phoneName;
            self.parentModel.ship_contact = [self phoneStringWithNoSpaceAndDash:phoneNO];
        }
            break;
        case BaseInfoTableViewCellContactPhone:
        {
            self.contactModel.ship_name = phoneName;
            self.contactModel.ship_contact = [self phoneStringWithNoSpaceAndDash:phoneNO];
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    [_allContactArray removeAllObjects];
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneString = @"";
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if (k < ABMultiValueGetCount(phone)-1) {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }else {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }
            
        }
        NSDictionary *contactDict = @{@"phone_name":phoneName, @"phone":phoneString};
        [_allContactArray addObject:contactDict];
        
    }
    self.baseInfoModel.phone_name_list = _allContactArray;
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    
    if (self.baseInfoModel.is_marry.length == 0) {
        [self setHudWithName:@"请填写婚姻状况" Time:0.5 andType:1];
        return;
    }
    if (self.baseInfoModel.home_province.length == 0) {
        [self setHudWithName:@"请填写所在城市" Time:0.5 andType:1];
        return;
    }
    if (self.baseInfoModel.home_address.length <= 6) {
        [self setHudWithName:@"请填写详细地址(地址填写应不少于6个字)" Time:2 andType:1];
        return;
    }
    if (self.parentModel.relationship.length == 0) {
        [self setHudWithName:@"请填写亲属关系" Time:0.5 andType:1];
        return;
    }
    if (self.parentModel.ship_name.length == 0 && self.parentModel.ship_contact.length == 0) {
        [self setHudWithName:@"请填写亲属姓名及电话" Time:0.5 andType:1];
        return;
    }
    if (self.parentModel.ship_province_city_town.length == 0) {
        [self setHudWithName:@"请填写亲属所在城市" Time:0.5 andType:1];
        return;
    }
    if (self.parentModel.ship_address.length <= 6) {
        [self setHudWithName:@"请填写亲属现居地的详细地址(地址填写应不少于6个字)" Time:2 andType:1];
        return;
    }
    if (self.contactModel.relationship.length == 0) {
        [self setHudWithName:@"请填写联系人关系" Time:0.5 andType:1];
        return;
    }
    if (self.contactModel.ship_name.length == 0 && self.contactModel.ship_contact.length == 0) {
        [self setHudWithName:@"请填写联系人姓名及电话" Time:0.5 andType:1];
        return;
    }
    if (![self phoneStringWithNSPredicate:self.parentModel.ship_contact]) {
        [self setHudWithName:@"亲属手机号码格式有误" Time:0.5 andType:1];
        return;
    }
    if (![self phoneStringWithNSPredicate:self.contactModel.ship_contact]) {
        [self setHudWithName:@"联系人手机号码格式有误" Time:0.5 andType:1];
        return;
    }
    if (!self.authView.AgreementBtn.selected && self.creditInfoModel.base_info_status.integerValue == 0) {
        [XAlertView alertWithTitle:@"温馨提示" message:@"请您认真阅读《全网贷个人信息收集授权书》，若无异议请先勾选“我已同意《全网贷个人信息收集授权书》”，再重新提交资料" cancelButtonTitle:nil confirmButtonTitle:@"知道了" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {}];
        return;
    }
    [self prepareDataWithCount:BaseInfoRequestPostInfo];
}
-(void)buttonClick:(UIButton*)button{
    switch (button.tag) {
        case AuthorizationBtnOnClickAgreement:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.clientGlobalInfoModel.wap_url_list.collect_info_grant_authorization_url;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case AuthorizationBtnOnClickTick:
            button.selected = !button.selected;
            self.authView.AgreementBtn.selected = button.selected;
            break;
            
        default:
            break;
    }
}

#pragma  mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case BaseInfoRequestPostInfo:{
            
            self.cmd = XPostContactInfo;
            self.dict = [self.baseInfoModel mj_keyValues];
        }
            break;
        case BaseInfoRequestGetInfo:{
            self.cmd = XGetContactInfo;
            self.dict = @{};
        }
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case BaseInfoRequestPostInfo:{
            [self setHudWithName:@"提交成功" Time:1 andType:0];
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:self userInfo:nil];
        }
            break;
        case BaseInfoRequestGetInfo:{
            BaseInfoModel *model = [BaseInfoModel mj_objectWithKeyValues:response.content];
            if (model.contacts.count) {
                self.baseInfoModel = model;
                self.parentModel = model.contacts[0];
                self.contactModel = model.contacts[1];
            }
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
- (BaseInfoModel *)baseInfoModel{
    if (!_baseInfoModel) {
        _baseInfoModel = [[BaseInfoModel alloc]init];
        _baseInfoModel.contacts  = [NSArray arrayWithObjects:self.parentModel,self.contactModel, nil];
    }
    return _baseInfoModel;
}
- (ShipModel*)parentModel{
    if (!_parentModel) {
        _parentModel = [[ShipModel alloc]init];
    }
    return _parentModel;
}
- (ShipModel *)contactModel{
    if (!_contactModel) {
        _contactModel = [[ShipModel alloc]init];
    }
    return _contactModel;
}
-(ClientGlobalInfoRM *)clientGlobalInfoModel{
    if (!_clientGlobalInfoModel) {
        _clientGlobalInfoModel = [ClientGlobalInfoRM getClientGlobalInfoModel];
    }
    return _clientGlobalInfoModel;
}
- (void)headerRefresh{
    [self prepareDataWithCount:BaseInfoRequestGetInfo];
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
