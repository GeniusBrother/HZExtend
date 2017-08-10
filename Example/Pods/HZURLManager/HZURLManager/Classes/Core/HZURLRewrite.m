//
//  HZURLRewrite.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2017/7/28.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "HZURLRewrite.h"
#import "HZURLManagerConfig.h"
@implementation HZURLRewrite

+ (NSURL *)rewriteURLForURL:(NSURL *)url
{
    if (!url) return nil;
    
    NSArray *rules = [HZURLManagerConfig sharedConfig].rewriteRule;
    
    if ([rules isKindOfClass:[NSArray class]] && rules.count > 0) {
        NSString *targetURL = url.absoluteString;
        NSRegularExpression *replaceRx = [NSRegularExpression regularExpressionWithPattern:@"[$](\\d)+|[$]query" options:0 error:NULL];
        for (NSDictionary *rule in rules) {
            NSString *matchRule = [rule objectForKey:@"match"];
            if (!([matchRule isKindOfClass:[NSString class]] && matchRule.length > 0)) continue;
            
            NSRange searchRange = NSMakeRange(0, targetURL.length);
            NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:matchRule options:0 error:NULL];
            NSRange range = [rx rangeOfFirstMatchInString:targetURL options:0 range:searchRange];
            if (range.length != 0) {    //url匹配
                //获取分组值
                NSMutableArray *groupValues = [NSMutableArray array];
                NSTextCheckingResult *result = [rx firstMatchInString:targetURL options:0 range:searchRange];
                for (NSInteger idx = 0; idx<rx.numberOfCaptureGroups; idx++) {
                    NSRange groupRange = [result rangeAtIndex:idx+1];
                    if (groupRange.length != 0) {
                        [groupValues addObject:[targetURL substringWithRange:groupRange]];
                    }
                }
                
                //拼接目标字符串
                NSString *targetRule = [rule objectForKey:@"target"];
                NSMutableString *newTargetURL = [NSMutableString stringWithString:targetRule];
                [replaceRx enumerateMatchesInString:targetRule options:0 range:NSMakeRange(0, targetRule.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSRange matchRange = result.range;
                    NSRange firstGroupRange = [result rangeAtIndex:1];
                    NSString *value = [targetRule substringWithRange:matchRange];
                    if (firstGroupRange.length != 0) {
                        NSInteger index = [[targetRule substringWithRange:firstGroupRange] integerValue];
                        if (index >= 1 && index <= groupValues.count) {
                            NSInteger loc = (index-1)?:0;
                            [newTargetURL replaceOccurrencesOfString:value withString:groupValues[loc] options:0 range:NSMakeRange(0, newTargetURL.length)];
                        }
                    }else {
                        
                        if ([value containsString:@"query"]) {
                            [newTargetURL replaceOccurrencesOfString:value withString:url.query.length>0?url.query:@"" options:0 range:NSMakeRange(0, newTargetURL.length)];
                        }
                    }
                }];
                targetURL = newTargetURL;
            }
        }
        
        return [NSURL URLWithString:targetURL];
    }
    
    return url;
}


@end
