//
//  ServiceURLVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"

@protocol ServiceURLVCDelegate<NSObject>
- (void)doNotForceUpdate;
@end
@interface ServiceURLVC : XBaseViewController
@property (nonatomic, weak) id <ServiceURLVCDelegate> delegate;

- (void)getServiceURL:(XBlock)block;
@end
