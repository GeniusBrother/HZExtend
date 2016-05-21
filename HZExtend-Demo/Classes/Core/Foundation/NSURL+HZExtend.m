//
//  NSURL+HZExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSURL+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "NSString+HZExtend.h"
@implementation NSURL (HZExtend)

- (NSDictionary *)queryDic
{
    return [self.absoluteString queryDic];
}

+ (BOOL)URLIsValid:(NSString *)urlString
{
    if(!urlString.isNoEmpty) return NO;
    
    NSString *deleteWhiteStr = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *URL = [NSURL URLWithString:deleteWhiteStr];
    
    if(!URL) {
        NSURL *URL = [NSURL URLWithString:[deleteWhiteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        return URL?YES:NO;
    }else {
        return YES;
    }
}

@end
