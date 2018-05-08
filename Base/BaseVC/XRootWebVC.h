//
//  XRootWebVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import <WebKit/WebKit.h>
typedef void(^dismissBlock)(NSString *content);
@interface XRootWebVC : XBaseViewController
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIProgressView *progressView;
@property(nonatomic,copy) NSString *url;
@property (nonatomic,copy) dismissBlock dismissBlock;
@property (nonatomic,assign) BOOL isLunch;
/**
 void
 
 @param url 网址
 */
-(void)createWebViewWithURL:(NSString *)url;

@end
