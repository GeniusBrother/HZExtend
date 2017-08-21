//
//  HZQueryBuilder.m
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 17/8/15.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "HZQueryBuilder.h"
#import <NSObject+HZORM.h>
#import "HZModelMeta.h"
@interface HZQueryBuilder ()

@property(nonatomic, strong) HZModelMeta *meta;

@property(nonatomic, copy) NSString *select;
@property(nonatomic, copy) NSString *where;
@property(nonatomic, copy) NSString *orderBy;
@property(nonatomic, copy) NSString *groupBy;
@property(nonatomic, copy) NSString *join;
@property(nonatomic, copy) NSString *having;
@property(nonatomic, assign) NSInteger skip;
@property(nonatomic, assign) NSInteger take;

@end

@implementation HZQueryBuilder

#pragma mark - Initialization
+ (instancetype)queryBuilderWithMeta:(HZModelMeta *)meta
{
    HZQueryBuilder *builder = [[HZQueryBuilder alloc] init];
    builder.meta = meta;

    return builder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _select = @"";
    _where = @"";
    _orderBy = @"";
    _groupBy = @"";
    _join = @"";
    _having = @"";
    _skip = -1;
    _take = 0;
}

#pragma mark - Public Method
#pragma mark Construct
- (HZQueryBuilder *)select:(NSArray<NSString *> *)columns
{
    if (!(columns.count > 0)) return self;
    
    self.select = [columns componentsJoinedByString:@","];
    
    return self;
}

- (HZQueryBuilder *)selectRaw:(NSString *)raw
{
    if (!(raw.length > 0)) return self;
    
    self.select = raw;
    
    return self;
}

- (HZQueryBuilder *)where:(NSDictionary<NSString *,id> *)params
{
    if (!(params.count > 0)) return self;
    
    NSMutableString *whereMutable = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [whereMutable appendFormat:@"%@ = '%@' and",key,obj];
    }];
    
    NSRange lastAnd = [whereMutable rangeOfString:@"and" options:NSBackwardsSearch];
    [whereMutable deleteCharactersInRange:lastAnd];
    self.where = [whereMutable copy];
    
    return self;
}

- (HZQueryBuilder *)whereRaw:(NSString *)raw
{
    if (!(raw.length > 0)) return self;
    
    self.where = raw;
    
    return self;
}

- (HZQueryBuilder *)skip:(NSInteger)skip
{
    self.skip = skip;
    
    return self;
}

- (HZQueryBuilder *)take:(NSInteger)take
{
    self.take = take;
    
    return self;
}

- (HZQueryBuilder *)join:(NSString *)tableName withFirstColumn:(nonnull NSString *)firstColumn
                operator:(nullable NSString *)opera
            secondColumn:(nonnull NSString *)secondColumn
{
    
    self.join = [NSString stringWithFormat:@"%@ on %@ = %@",tableName,firstColumn,secondColumn];
    
    return self;
}

- (HZQueryBuilder *)orderBy:(NSString *)column desc:(BOOL)desc
{
    self.orderBy = [NSString stringWithFormat:@"%@ %@",column,desc?@"DESC":@"ASC"];
    return self;
}

- (HZQueryBuilder *)groupBy:(NSString *)groupBy
{
    self.groupBy = groupBy;
    
    return self;
}

- (HZQueryBuilder *)having:(NSString *)raw
{
    self.having = raw;
    
    return self;
}

#pragma mark Retrieve
- (NSArray *)get
{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select %@ from %@",self.select,self.meta.tableName];
    
    if (self.join.length > 0) {
        [sql appendFormat:@" inner join %@",self.join];
    }
    
    if (self.where.length > 0) {
        [sql appendFormat:@" where %@",self.where];
    }
    
    if (self.orderBy.length > 0) {
        [sql appendFormat:@" order by %@",self.orderBy];
    }
    
    if (self.groupBy.length > 0) {
        [sql appendFormat:@" group by %@",self.groupBy];
    }
    
    if (self.having.length > 0) {
        [sql appendFormat:@" having %@",self.having];
    }
    
    NSString *limit = [self limit];
    if (limit.length > 0) {
        [sql appendFormat:@" limit %@",limit];
    }
    
    return [NSObject findWithSql:sql withMeta:self.meta];
}

- (id)first
{
    self.take = 1;
    return [[self get] firstObject];
}

#pragma mark - Private Method
- (NSString *)limit
{
    NSInteger offset = self.skip;
    NSInteger take = self.take;
    
    if (offset >= 0 && take > 0) {
        return [NSString stringWithFormat:@"%ld, %ld",offset,take];
    }else if (offset >= 0) {
        return [NSString stringWithFormat:@"%ld, 1",offset];
    }else if (take > 0){
        return [NSString stringWithFormat:@"%ld",take];
    }else {
        return @"";
    }
}

@end
