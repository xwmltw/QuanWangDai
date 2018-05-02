//
//  ProductDetailTableViewCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/16.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ProductDetailTableViewCell.h"

@implementation ProductDetailTableViewCell
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _introduction = [[UILabel alloc] initWithFrame:CGRectMake(24, 5, ScreenWidth-48, 30)];
        [self addSubview:_introduction];
    }
    return self;
}

-(void)setIntroductionText:(NSString*)text{
    
    CGRect frame = [self frame];
    self.introduction.text = text;
    self.introduction.numberOfLines = 0;
    self.introduction.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(15)];
    self.introduction.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    CGSize size = CGSizeMake(ScreenWidth-48, 1000);
    CGSize labelSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    self.introduction.frame = CGRectMake(self.introduction.frame.origin.x, self.introduction.frame.origin.y, labelSize.width, labelSize.height);
//    CGSize textSize = [self.introduction.text boundingRectWithSize:CGSizeMake(ScreenWidth-20, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.introduction.font} context:nil].size;
//    self.introduction.frame = CGRectMake(10, 100, textSize.width, textSize.height);
    frame.size.height = labelSize.height+8;
    self.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
