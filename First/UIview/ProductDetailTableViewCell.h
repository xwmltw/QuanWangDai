//
//  ProductDetailTableViewCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/16.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailTableViewCell : UITableViewCell

@property(nonatomic,retain) UILabel *introduction;

-(void)setIntroductionText:(NSString*)text;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
