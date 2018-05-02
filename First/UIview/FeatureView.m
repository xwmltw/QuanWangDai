//
//  FeatureView.m
//  QuanWangDai
//
//  Created by yanqb on 2018/4/17.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "FeatureView.h"

@implementation FeatureView


- (void)drawRect:(CGRect)rect {
    for (int i= 0; i < self.imageArry.count; i++) {
        RecommentTopBtn *btn = [[RecommentTopBtn alloc]init];
        [self addSubview:btn];
        
        dispatch_queue_t xrQueue = dispatch_queue_create("loadImage", NULL); // 创建GCD线程队列
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArry[i]]]];
        dispatch_async(xrQueue, ^{
            [btn setImage:image forState:UIControlStateNormal];
        });
        btn.btnTitle = self.titleArry[i];
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 300+i;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(AdaptationWidth(16)+AdaptationWidth(86)*i);
            make.width.mas_equalTo(AdaptationWidth(86));
            make.height.mas_equalTo(AdaptationWidth(91));
        }];
    }
}
- (void)btnOnClick:(RecommentTopBtn *)btn{
    
}

@end
