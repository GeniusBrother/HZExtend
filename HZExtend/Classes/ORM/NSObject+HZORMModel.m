//
//  NSObject+HZORMModel.m
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 17/8/15.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "NSObject+HZORMModel.h"
#import "HZORMUtils.h"

@implementation NSObject (HZORMModel)

+ (NSString *)getTabelName { return NSStringFromClass([self class]); }

+ (NSDictionary<NSString *, NSString *> *)getColumnMap
{
    NSArray *propertyNames = [HZORMUtils allPropertyNamesWithClass:[self class]];
    NSMutableDictionary *map = [NSMutableDictionary dictionaryWithCapacity:propertyNames.count];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [map setObject:obj forKey:obj];
    }];
    
    return map;
}

+ (NSArray<NSString *> *)getPrimaryKeys { return @[@"id"]; }

+ (NSDictionary<NSString *,NSString *> *)getCasts { return @{}; }

+ (BOOL)isIncrementing { return YES; }


#pragma mark - CallBack
- (void)beforeInsert {}
- (void)sucessInsert {}
- (void)beforeUpdate {}
- (void)sucessUpdate {}
- (void)beforeRemove {}
- (void)sucessRemove {}
@end
