//
//  XWMCodeImageView.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCodeImageView.h"
#import "XBaseViewController.h"

@interface XWMCodeImageView : UIView

@property (weak, nonatomic) IBOutlet UITextField *ImageTextField;
@property (nonatomic ,strong) XCodeImageView *codeImage;
@property (copy ,nonatomic) XBlock block;

- (instancetype)initWithFrame:(CGRect)frame withController:(XBaseViewController*)controller;
@end
