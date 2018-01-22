//
//  XAlertView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/8.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XAlertView.h"
@interface XAlertView()<UIAlertViewDelegate>
@property (nonatomic, copy) XAlertViewBlock block;
@end
@implementation XAlertView


+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(XAlertViewBlock)completion{
    XAlertView* alert = [[XAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle completion:completion];
    [alert show];
}

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle viewController:(UIViewController *)vc completion:(XAlertControllerBlock)completion{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSAssert(NO, @"systemVersion must >= 8.0");
        return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [alert.view.layer addAnimation:animation forKey:nil];
//
//    for (UIView *bgView in [alert.view subviews]){
//        if ([bgView class] == [UIImageView class]){
//            bgView.backgroundColor = [UIColor whiteColor];
//            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(self);
//                make.height.mas_equalTo(AdaptationWidth(175));
//                make.width.mas_equalTo(AdaptationWidth(272));
//            }];
//        }
//    }
    
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    [titleText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(16)] range:NSMakeRange(0, title.length)];
    [titleText addAttribute:NSForegroundColorAttributeName value:XColorWithRGB(34, 58, 80) range:NSMakeRange(0, title.length)];
    [alert setValue:titleText forKey:@"attributedTitle"];
    // 使用富文本来改变alert的message字体大小和颜色
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message];
    [messageText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)] range:NSMakeRange(0, message.length)];
    [messageText addAttribute:NSForegroundColorAttributeName value:XColorWithRBBA(34, 58, 80, 0.64) range:NSMakeRange(0, message.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];

//    UIView *subView1 = alert.view.subviews[0];
//    UIView *subView2 = subView1.subviews[0];
//    UIView *subView3 = subView2.subviews[0];
//    UIView *subView4 = subView3.subviews[0];
//    UIView *subView5 = subView4.subviews[0];
//    //取title和message：
//    UILabel *title1 = subView5.subviews[0];
//    UILabel *message1 = subView5.subviews[1];
//    //比如设置message内容居左：
//    message1.textAlignment = NSTextAlignmentLeft;
//    title1.textAlignment = NSTextAlignmentLeft;
    if (cancelButtonTitle.length) {
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 0);
        }];
        [cancleAction setValue:XColorWithRGB(252, 93, 109) forKey:@"titleTextColor"];
        [alert addAction:cancleAction];
    }
    if (confirmButtonTitle.length) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:confirmButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completion(action, 1);
        }];
        [confirmAction setValue:XColorWithRGB(252, 93, 109) forKey:@"titleTextColor"];
        [alert addAction:confirmAction];
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle completion:(XAlertViewBlock)completion{
    
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:confirmButtonTitle, nil];
    if (self) {
        self.block = completion;
    }

    return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(alertView, buttonIndex);
    }
}

@end
