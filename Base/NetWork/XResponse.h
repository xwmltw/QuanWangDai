//
//  XResponse.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/15.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XResponse : NSObject

@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) NSNumber *errCode;
@property (nonatomic, copy) NSDictionary *content;
//@property (nonatomic, copy) NSDictionary *originData;

- (BOOL)success;
@end
