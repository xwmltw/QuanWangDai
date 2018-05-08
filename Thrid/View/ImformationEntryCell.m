//
//  ImformationEntryCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/4.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "ImformationEntryCell.h"

@implementation ImformationEntryCell

-(void)setupmodel:(SpecialEntryModel *)model indexpath:(NSInteger)row{
    self.miantitle.text = model.special_entry_list[row][@"special_entry_title"];
    self.miantitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    if (model.special_entry_list[row][@"special_entry_icon"] != nil) {
        [self.entry_image sd_setImageWithURL:[NSURL URLWithString:model.special_entry_list[row][@"special_entry_icon"]]];
    }else{
        self.entry_image.image = [UIImage imageNamed:@"loading_page"];
    }
//    self.subdiscrition.text = model.special_entry_list[row][@"special_entry_desc"];
    if ([model.special_entry_list[row][@"special_entry_desc"] length]) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.special_entry_list[row][@"special_entry_desc"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.subdiscrition.attributedText = attrStr;
        self.subdiscrition.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(14)];
    }else{
        self.subdiscrition.hidden = YES;
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
