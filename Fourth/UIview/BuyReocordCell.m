//
//  BuyReocordCell.m
//  QuanWangDai
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "BuyReocordCell.h"
#import "DateHelper.h"
@implementation BuyReocordCell
{
	UILabel *_titlelabel;
	UILabel *_timelabel;
//    UILabel *_typelabel;
	UILabel *_moneylabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){

		_titlelabel = [[UILabel alloc]init];
		[_titlelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(17)]];
		[_titlelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
		[self.contentView addSubview:_titlelabel];
		
		_timelabel = [[UILabel alloc]init];
		[_timelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
		[_timelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.32)];
		[self.contentView addSubview:_timelabel];
		
//        _typelabel = [[UILabel alloc]init];
//        [_typelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
//        [_typelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
//        [self.contentView addSubview:_typelabel];
		
		_moneylabel = [[UILabel alloc]init];
		[_moneylabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)]];
		[_moneylabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
		_moneylabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_moneylabel];
		

		UIView *lineView = [[UIView alloc]init];
		[lineView setBackgroundColor:XColorWithRGB(233, 233, 235)];
		[self.contentView addSubview:lineView];
		
		[_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(16));
			make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
			make.height.mas_equalTo(AdaptationWidth(24));
			make.right.mas_equalTo(_moneylabel.mas_left);
		}];
		[_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(16));
			make.top.mas_equalTo(_titlelabel.mas_bottom).offset(AdaptationWidth(8));
			make.height.mas_equalTo(AdaptationWidth(25));
            make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(16));
		}];
//        [_typelabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.contentView).offset(AdaptationWidth(20));
//            make.top.mas_equalTo(_timelabel.mas_bottom).offset(AdaptationWidth(8));
//            make.height.mas_equalTo(AdaptationWidth(25));
//            make.width.mas_equalTo(AdaptationWidth(230));
//        }];
		[_moneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(self.contentView).offset(-AdaptationWidth(16));
			make.top.mas_equalTo(self.contentView).offset(AdaptationWidth(22));
			make.height.mas_equalTo(AdaptationWidth(20));
			make.width.mas_equalTo(AdaptationWidth(50));
		}];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.mas_equalTo(self.contentView);
			make.right.mas_equalTo(self.contentView);
			make.bottom.mas_equalTo(self.contentView);
			make.height.mas_equalTo(0.5);
		}];
	}
	return self;
}

-(void)setModel:(MoneyListModel *)model{
	_titlelabel.text = model.money_detail_title;
    _timelabel.text = [NSString stringWithFormat:@"交易时间: %@",[DateHelper getDateFromTimeNumber:model.create_time withFormat:@"yyyy/M/d, HH:mm:ss"]];
    _moneylabel.text = [NSString stringWithFormat:@"%.2f",model.actual_amount.floatValue / 100];
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
