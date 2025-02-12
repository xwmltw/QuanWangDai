//
//  ApplicantManVC.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/1/16.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "CreditInfoModel.h"
typedef NS_ENUM(NSInteger , ApplicantCellCell) {
    ApplicantCellCellUse,
    ApplicantCellCellProfession,
    ApplicantCellCellSalary,
    ApplicantCellCellWorking_years,
    ApplicantCellCellreserved_funds,
    ApplicantCellCellSocial_security,
    ApplicantCellCellHouse,
    ApplicantCellCellRelativeHouse,
    ApplicantCellCellCar,
    ApplicantCellCellCredit,
    ApplicantCellCellChit,
    ApplicantCellCellEducation,
};
@interface ApplicantManVC : XBaseViewController
@property (nonatomic, strong)CreditInfoModel *creditInfoModel;
@property (nonatomic, copy) NSNumber *comeFrom; //1信用助手中心
@property (nonatomic ,copy) NSNumber *isBlock;
@end
