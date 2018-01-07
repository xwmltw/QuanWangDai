//
//  XResponse.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/15.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XResponse.h"

@implementation XResponse

- (BOOL)success{
    return self.errCode.intValue == 0;
}
@end
