//
//  NSObject+Json.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/14.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "NSObject+Json.h"

@implementation NSObject (Json)
- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        MyLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString*)simpleJsonString {
    NSDictionary* dic = [self mj_keyValues];
    return [dic jsonStringWithPrettyPrint:YES];
}
@end
