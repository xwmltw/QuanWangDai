//
//  WDWavesView.m
//  WDWavesView-master
//
//  Created by WD on 16/9/25.
//  Copyright © 2016年 WD. All rights reserved.
//  Github  Demo  :https://github.com/Cehae/WDWavesViewDemo-master

#import "WDWavesView.h"

@interface WDWavesView ()

@property (nonatomic, strong) CADisplayLink *timer;

@property (nonatomic, strong) CAShapeLayer *realWaveLayer;

@property (nonatomic, strong) CAShapeLayer *maskWaveLayer;

@property (nonatomic, strong) CAShapeLayer *backWaveLayer;

@property (nonatomic, assign) CGFloat offset;

@end
@implementation WDWavesView
#pragma mark - 初始化
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    //初始化
    self.waveSpeed = 0.2;
    
    self.waveCurvature = 1.5;
    self.firstwaveCurvature = 0.8;
    
    self.waveHeight = 8;
    self.firstwaveHeight = 4;
    self.realWaveColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:84/255.0 alpha:0.76];
    self.maskWaveColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:84/255.0 alpha:0.46];;
    self.backWaveColor = [UIColor colorWithRed:252/255.0 green:120/255.0 blue:84/255.0 alpha:0.2];;
    
    [self.layer addSublayer:self.maskWaveLayer];
    [self.layer addSublayer:self.backWaveLayer];
    [self.layer addSublayer:self.realWaveLayer];
}
#pragma mark - lazyload
- (CAShapeLayer *)realWaveLayer{
    
    if (!_realWaveLayer) {
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height-self.firstwaveHeight;
        frame.size.height = self.firstwaveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
    }
    return _realWaveLayer;
}

- (CAShapeLayer *)maskWaveLayer{
    
    if (!_maskWaveLayer) {
        _maskWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height-self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer.frame = frame;
        _maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer;
}
- (CAShapeLayer *)backWaveLayer{

    if (!_backWaveLayer) {
        _backWaveLayer = [CAShapeLayer layer];
        CGRect frame = self.bounds;
        frame.origin.y = frame.size.height-self.waveHeight;
        frame.size.height = self.waveHeight;
        _backWaveLayer.frame = frame;
        _backWaveLayer.fillColor = self.backWaveColor.CGColor;
    }
    return _backWaveLayer;
}


- (void)setWaveHeight:(CGFloat)waveHeight{
    _waveHeight = waveHeight;
    
    CGRect frame = self.bounds;
//    frame.origin.y = frame.size.height-self.waveHeight;
//    frame.size.height = self.waveHeight;
//    _realWaveLayer.frame = frame;
//
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _maskWaveLayer.frame = frame;
    
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _backWaveLayer.frame = frame;
}
-(void)setFirstwaveHeight:(CGFloat)firstwaveHeight{
    _firstwaveHeight = firstwaveHeight;
    
    CGRect frame = self.bounds;
    frame.origin.y = frame.size.height-self.firstwaveHeight;
    frame.size.height = self.firstwaveHeight;
    _realWaveLayer.frame = frame;
}
#pragma mark - 动画

- (void)startWaveAnimation{
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(wave)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWaveAnimation{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave{
    
    self.offset += self.waveSpeed;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;
    CGFloat firstheight = self.firstwaveHeight;
    //真实浪
    CGMutablePathRef realpath = CGPathCreateMutable();
    CGPathMoveToPoint(realpath, NULL, 0, firstheight);
    CGFloat realY = 0.f;
    //遮罩浪
    CGMutablePathRef maskpath = CGPathCreateMutable();
    CGPathMoveToPoint(maskpath, NULL, 0, height);
    CGFloat maskY = 0.f;
    //遮罩浪
    CGMutablePathRef backpath = CGPathCreateMutable();
    CGPathMoveToPoint(backpath, NULL, 0, height);
    CGFloat backY = 0.f;
    
    for (CGFloat x = 0.f; x <= width ; x++) {
        realY = height * sinf(0.01 * self.firstwaveCurvature * x + self.offset * 0.045);
        CGPathAddLineToPoint(realpath, NULL, x, realY);
        
        maskY = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.045);;
        CGPathAddLineToPoint(maskpath, NULL, x, maskY);
        
        backY = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.060);
        CGPathAddLineToPoint(backpath, NULL, x, backY);

    }
    
    //变化的中间Y值
//    CGFloat centX = self.bounds.size.width/2;
//    CGFloat CentY = height * sinf(0.01 * self.waveCurvature *centX  + self.offset * 0.045);
//    if (self.waveBlock) {
//        self.waveBlock(CentY);
//    }
    
    CGPathAddLineToPoint(realpath, NULL, width, firstheight);
    CGPathAddLineToPoint(realpath, NULL, 0, firstheight);
    CGPathCloseSubpath(realpath);
    //描述路径后利用CAShapeLayer类绘制不规则图形
    self.realWaveLayer.path = realpath;
    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
    CGPathRelease(realpath);
    
    
    CGPathAddLineToPoint(maskpath, NULL, width, height);
    CGPathAddLineToPoint(maskpath, NULL, 0, height);
    CGPathCloseSubpath(maskpath);
    //描述路径后利用CAShapeLayer类绘制不规则图形
    self.maskWaveLayer.path = maskpath;
    self.maskWaveLayer.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskpath);
    

    CGPathAddLineToPoint(backpath, NULL, width, height);
    CGPathAddLineToPoint(backpath, NULL, 0, height);
    CGPathCloseSubpath(backpath);
    //描述路径后利用CAShapeLayer类绘制不规则图形
    self.backWaveLayer.path = backpath;
    self.backWaveLayer.fillColor = self.backWaveColor.CGColor;
    CGPathRelease(backpath);
}

@end
