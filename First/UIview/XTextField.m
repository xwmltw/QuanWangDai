//
//  XTextField.m
//  QuanWangDai
//
//  Created by yanqb on 2017/12/6.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XTextField.h"

@implementation XTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 16, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 16, 0);
}
@end
