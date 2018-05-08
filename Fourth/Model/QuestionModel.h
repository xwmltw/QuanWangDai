//
//  QuestionModel.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property (nonatomic, copy) NSString *help_title;
@property (nonatomic, copy) NSString *help_content;
@property (nonatomic, assign) BOOL isExpand;
@end
