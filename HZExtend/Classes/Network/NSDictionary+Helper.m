//
//  NSDictionary+Helper.m
//  HZNetwork
//
//  Created by xzh on 2018/1/1.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

- (NSString *)hzn_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
