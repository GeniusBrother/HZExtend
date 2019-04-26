//
//  NSURL+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "NSURL+HZExtend.h"
#import "NSString+HZExtend.h"

@implementation NSURL (HZExtend)

- (NSString *)allPath
{
    NSString *absoluteStr = self.absoluteString;
    NSString *keyValues = self.query;
    if (keyValues.length > 0) return [absoluteStr stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"?%@",keyValues] withString:@""];
    
    return absoluteStr;
}

- (NSDictionary *)queryDic
{
    NSString *keyValues = self.query;
    if (!keyValues.isNoEmpty) return nil;
    
    return [self queryDicWithKeysValues:keyValues];
}

- (BOOL)isRemote
{
    NSString *scheme = self.scheme;
    NSArray *remoteSchemes = @[@"http", @"https", @"ftp"];
    return [remoteSchemes containsObject:scheme];
}


#pragma mark - Private Method
//从k=v中获取键值
- (NSString *)valueFromKeyValue:(NSString *)keyValue atIndex:(NSUInteger)index
{
    return [[keyValue componentsSeparatedByString:@"="] objectAtIndex:index];
}

- (NSDictionary *)queryDicWithKeysValues:(NSString *)keyValues
{
    if (!(keyValues.length > 0)) return @{};
    
    NSArray *pairArray = [keyValues componentsSeparatedByString:@"&"];  //键值对字符串
    NSMutableDictionary *queryDic= [NSMutableDictionary dictionaryWithCapacity:pairArray.count];
    NSString *key = nil;
    NSString *obj = nil;
    if (pairArray.count > 1)
    {
        for (NSString *pair in pairArray)
        {
            key = [self valueFromKeyValue:pair atIndex:0];
            obj = [self valueFromKeyValue:pair atIndex:1];
            [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
        }
    }
    else if (pairArray.count == 1)
    {
        key = [self valueFromKeyValue:keyValues atIndex:0];
        obj = [self valueFromKeyValue:keyValues atIndex:1];
        [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
    }
    
    return queryDic;
}

@end
