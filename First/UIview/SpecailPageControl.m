//
//  SpecailPageControl.m
//  QuanWangDai
//
//  Created by yanqb on 2018/4/24.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "SpecailPageControl.h"
#define dotW 12
#define magrin 1

@implementation SpecailPageControl
- (void)layoutSubviews{
    [super layoutSubviews];

    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, dotW /3);
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;

    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage) {
            [dot setFrame:CGRectMake(i * marginX - dotW /2, dot.frame.origin.y, dotW, dotW /3)];
            dot.image = activeImage;
        }else {
            [dot setFrame:CGRectMake(i * marginX - dotW /6, dot.frame.origin.y, dotW /3, dotW /3)];
            dot.image = inactiveImage;
        }
    }
}

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    activeImage = [UIImage imageNamed:@"currentPageImage"];
    inactiveImage = [UIImage imageNamed:@"pageImage"] ;
    return self;
}

-(void) updateDots{
    
    //计算圆点间距
    CGFloat marginX = dotW + magrin;
    //计算整个pageControll的宽度
    CGFloat newW = (self.subviews.count - 1 ) * marginX;
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, 4);
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;

    for (int i = 0; i < [self.subviews count]; i++){
        UIImageView* dot = [self.subviews objectAtIndex:i];
        if (i == self.currentPage){
            CGSize size;
            size.height = 4;
            size.width = 12;
            dot.image = activeImage;
            UIImageView* subview = [self.subviews objectAtIndex:i];
            [subview setFrame:CGRectMake(i * marginX - size.width/ 2, subview.frame.origin.y, size.width,size.height)];
        }else{
            CGSize size;
            size.height = 4;
            size.width = 4;
            dot.image = inactiveImage;
            UIImageView* subview = [self.subviews objectAtIndex:i];
            [subview setFrame:CGRectMake(i * marginX - size.width/ 2, subview.frame.origin.y, size.width,size.height)];
        }
    }
}

-(void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
