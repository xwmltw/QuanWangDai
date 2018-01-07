//
//  PlatTableViewCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2017/12/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "PlatTableViewCell.h"
@implementation PlatTableViewCell
{
    UILabel *_titlelabel;
    UILabel *_marklabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    /** 信息文本 */
    _titlelabel = [[UILabel alloc]init];
//    _titlelabel.text = self.title;
    [_titlelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
    [_titlelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
    [self.contentView addSubview:_titlelabel];
    
    _marklabel = [[UILabel alloc]init];
//    _marklabel.text = self.marktile;

    [_marklabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
    _marklabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_marklabel];
    
    /** 分割线 */
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
    lineView.layer.masksToBounds = YES;
    lineView.layer.cornerRadius = 2;
    [self.contentView addSubview:lineView];
        
    UIImageView *image = [[UIImageView alloc]init];
    [image setImage:[UIImage imageNamed:@"entre"]];
        [self.contentView addSubview:image];
        
    
    /** Constraints */
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(_marklabel.mas_left);
//        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(ScreenWidth/2);
    }];
    [_marklabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(image.mas_left);
//        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(ScreenWidth/3);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(self.contentView).offset(AdaptationWidth(0));
        make.height.mas_equalTo(0.5);
    }];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(28);
    }];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titlelabel.text = title;
}
-(void)setMarktile:(NSString *)marktile
{
    _marktile = marktile;
    _marklabel.text = marktile;
    if ([_marklabel.text isEqualToString:@"0"]) {
        _marklabel.text = @"未填写";
        _marklabel.textColor = XColorWithRGB(7,137,133);
    }else{
        _marklabel.text = @"已填写";
        [_marklabel setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
