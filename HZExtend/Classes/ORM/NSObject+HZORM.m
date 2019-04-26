//
//  NSObject+HZORM.m
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 16/12/8.
//  Copyright (c) 2016 GeniusBrother. All rights reserved.
//

#import "NSObject+HZORM.h"
#import <objc/runtime.h>
#import <FMDB/FMDB.h>
#import "sqlite3.h"
#import "HZModelMeta.h"
#import "HZQueryBuilder.h"
#import "NSObject+HZORMModel.h"
@interface NSObject ()

@end

@implementation NSObject (HZORM)

#pragma mark - Public Method
#pragma mark Action
- (BOOL)save
{
    BOOL rs = NO;
    if (![self existInDB]) {
        rs = [self insert];
    }else {
        rs = [self update];
    }
    
    return rs;
}

- (BOOL)insert
{
    //call back
    [self beforeInsert];
    
    //construct sql
    HZModelMeta *meta;
    NSString *sql = [[[self class] insertSqlsWithObjs:@[self] meta:&meta] firstObject];
    
    //execute
    if ([HZDBManager executeUpdate:sql withParams:nil]) {
        
        if (meta.incrementing) [self setValue:@([HZDBManager lastInsertRowId]) forKey:[meta.columnMap objectForKey:[meta.primaryKeys firstObject]]];
        
        [self sucessInsert];
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)insert:(NSArray *)models
{
    HZModelMeta *meta;
    NSArray *insertSqls = [[self class] insertSqlsWithObjs:models meta:&meta];
    
    if (!(insertSqls.count > 0)) return NO;
    
    BOOL result = [HZDBManager executeStatements:[insertSqls componentsJoinedByString:@";"] withResultBlock:nil];
    
    if (meta.incrementing) {
        NSInteger lastInsertRowId = [HZDBManager lastInsertRowId];
        NSInteger lastIndex = models.count - 1;
        NSString *pkPropertyName = [meta.columnMap objectForKey:[meta.primaryKeys firstObject]];
        [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger rowId = lastInsertRowId - (lastIndex - idx);
            [obj setValue:@(rowId) forKey:pkPropertyName];
        }];
    }
    
    return result;
}

+ (BOOL)remove:(NSArray *)pks
{
    if (!([pks isKindOfClass:[NSArray class]] && pks.count > 0)) return NO;
    
    HZModelMeta *meta = [self meta];
    if (!meta.incrementing) return NO;
    
    NSString *tableName = meta.tableName;
    NSString *pkName = [meta.primaryKeys firstObject];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ in (%@)", tableName,pkName,[pks componentsJoinedByString:@","]];
    BOOL result = [HZDBManager executeUpdate:sql withParams:nil];
    
    return result;
}

- (BOOL)remove
{
    [self beforeRemove];
    HZModelMeta *meta = [[self class] meta];
    NSString *tableName = meta.tableName;
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, [self wherePKWithMeta:meta]];
    
    if ([HZDBManager executeUpdate:sql withParams:nil]) {
        
        [self sucessRemove];
        return YES;
    }
    
    return NO;
}

+ (BOOL)remove
{
    HZModelMeta *meta = [self meta];
    NSString *tableName = meta.tableName;
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if ([HZDBManager executeUpdate:sql withParams:nil]) {
        return YES;
    }
    return NO;
}

- (BOOL)update
{
    //get table structure.
    HZModelMeta *meta = [[self class] meta];
    NSString *tableName = meta.tableName;
    NSMutableDictionary *columnsMapWithoutPK = [NSMutableDictionary dictionaryWithDictionary:meta.columnMap];
    [columnsMapWithoutPK removeObjectsForKeys:meta.primaryKeys];
    
    
    [self beforeUpdate];
    
    NSMutableString *setValues = [NSMutableString string];
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:columnsMapWithoutPK.count];
    [columnsMapWithoutPK enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull column, NSString  *_Nonnull property, BOOL * _Nonnull stop) {
        [setValues appendFormat:@"%@ = ?,",column];
        id data = [self validDBValueForProperty:property];
        if (data) [parameters addObject:data];
    }];
    [setValues deleteCharactersInRange:NSMakeRange(setValues.length - 1, 1)];
    
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", tableName, setValues, [self wherePKWithMeta:meta]];
    if ([HZDBManager executeUpdate:sql withParams:parameters]) {
        
        [self sucessUpdate];
        return YES;
    }
    return NO;
}


#pragma mark Search
+ (instancetype)find:(id)pk
{
    if (!pk) return nil;
    
    HZModelMeta *meta = [self meta];
    
    NSString *pkName = [meta.primaryKeys firstObject];
    return [[[self search:@[@"*"]] where:@{pkName:pk}] first];
}

+ (instancetype)firstWithKeyValues:(NSDictionary *)keyValues
{
    if (!([keyValues isKindOfClass:[NSDictionary class]] && keyValues.count > 0)) return  nil;
    
    return [[[self search:@[@"*"]] where:keyValues] first];
}

+ (NSArray *)all
{
    return [[self search:@[@"*"]] get];
}


+ (HZQueryBuilder *)search:(NSArray *)columns
{
    return [[HZQueryBuilder queryBuilderWithMeta:[[HZModelMeta alloc] initWithClass:[self class]]] select:columns];
}

+ (HZQueryBuilder *)searchRaw:(NSString *)raw
{
    return [[HZQueryBuilder queryBuilderWithMeta:[[HZModelMeta alloc] initWithClass:[self class]]] selectRaw:raw];
}

+ (NSArray *)findWithSql:(NSString *)sql withMeta:(nonnull HZModelMeta *)meta
{
    if(!(sql.length > 0 && meta)) return nil;
    
    NSArray *results= [HZDBManager executeQuery:sql withParams:nil];
    
    if (([results isKindOfClass:[NSArray class]] && results.count > 0)) {
        NSMutableArray *objArray = [NSMutableArray arrayWithCapacity:results.count];
        Class modelClass = meta.cla;
        
        [results enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSObject *obj = [[modelClass alloc] init];
            [self configPropertyWithData:dic meta:meta forObj:obj];
            [objArray addObject:obj];
        }];
        return objArray;
    }

    return nil;
}

#pragma mark - Private Method
#pragma mark  Data Convert
//将属性值转化成适合数据存储的值
- (id)validDBValueForProperty:(NSString *)name
{
    id originalValue = [self valueForKey:name];
    
    if (!originalValue) return [NSNull null];
    
    if ([originalValue isKindOfClass:[NSArray class]] || [originalValue isKindOfClass:[NSDictionary class]]) {
        return [NSObject jsonStringWithObject:originalValue];
    }else if([originalValue isKindOfClass:[NSString class]] || [originalValue isKindOfClass:[NSNumber class]]){
        return originalValue;
    }else { //originalValue为其它对象类型
        return @"";
    }
}

- (NSArray *)validDBValuesForPropertys:(NSArray *)propertyNames;
{
    if (!(propertyNames.count > 0)) return nil;
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames) {
        id value = [self validDBValueForProperty:propertyName];
        [values addObject:value];
    }
    return values;
}

+ (void)configPropertyWithData:(NSDictionary *)data meta:(HZModelMeta *)meta forObj:(NSObject *)obj
{
    NSDictionary *columnPropertyDic = meta.columnMap;
    NSDictionary *casts = meta.casts;
    
    [data enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull columnName, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSString *propertyName = [columnPropertyDic objectForKey:columnName];
        if ([propertyName isKindOfClass:[NSString class]] && propertyName.length > 0) {
            
            NSString *type = [casts objectForKey:propertyName];
            id convertedValue = [self converteValue:value withType:type];
            
            NSAssert(convertedValue, @"HZORM 装换的值不能为nil");
            if (convertedValue && ![convertedValue isKindOfClass:[NSNull class]]) [obj setValue:convertedValue forKey:propertyName];
        }
        
    }];
}

+ (id)converteValue:(id)value withType:(NSString *)type
{
    id convertedValue = value;
    if (type) {
        if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
            convertedValue = [NSObject jsonObjWithJsonString:convertedValue];
        }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
            convertedValue = [NSObject jsonObjWithJsonString:convertedValue];
            convertedValue = [convertedValue isKindOfClass:[NSArray class]]?[NSMutableArray arrayWithArray:convertedValue]:[NSMutableDictionary dictionaryWithDictionary:convertedValue];
        }
    }
    
    return convertedValue;
}

#pragma mark - Create SQL
+ (NSArray *)insertSqlsWithObjs:(NSArray *)objArray meta:(HZModelMeta **)meta
{
    if (!(objArray.count > 0)) return nil;
    
    HZModelMeta *metaObj = [self meta];
    *meta = metaObj;
    NSArray *columns = metaObj.columnMap.allKeys;
    NSString *tableName = metaObj.tableName;
    BOOL incrementing = metaObj.incrementing;
    if (incrementing) {
        NSString *primaryKey = [metaObj.primaryKeys firstObject];
        NSMutableArray *columnsWithoutPK = [NSMutableArray arrayWithArray:columns];
        [columnsWithoutPK removeObject:primaryKey];
        columns = columnsWithoutPK;
    }
    
    NSMutableArray *insertSqls = [NSMutableArray arrayWithCapacity:objArray.count];
    [objArray enumerateObjectsUsingBlock:^(NSObject  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //construct sql and params.
        NSMutableArray *propertyNames = [NSMutableArray arrayWithCapacity:columns.count];
        for (NSString *column in columns) {
            [propertyNames addObject:[metaObj.columnMap objectForKey:column]];
        }
        NSArray *validDBValues = [obj validDBValuesForPropertys:propertyNames];
        NSMutableArray *parameterList = [NSMutableArray arrayWithCapacity:validDBValues.count];
        [validDBValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [parameterList addObject:[NSString stringWithFormat:@"'%@'",obj]];
        }];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)", tableName, [columns componentsJoinedByString:@","], [parameterList componentsJoinedByString:@","]];
        [insertSqls addObject:sql];
    }];

    return insertSqls;
}

- (NSString *)wherePKWithMeta:(HZModelMeta *)meta
{
    NSArray *pks = meta.primaryKeys;
    NSDictionary *maps = meta.columnMap;
    
    NSMutableString *wherePK = [NSMutableString string];
    [pks enumerateObjectsUsingBlock:^(NSString  *_Nonnull column, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyName = [maps objectForKey:column];
        if (propertyName) {
            [wherePK appendFormat:@" %@ = '%@' AND",column,[self validDBValueForProperty:propertyName]];
        }
    }];
    
    NSAssert(wherePK.length > 0, @"map of column-property don't containe pk");
    
    [wherePK deleteCharactersInRange:NSMakeRange(wherePK.length - 4, 4)];
    
    return wherePK;
}

#pragma mark Other
+ (NSString *)jsonStringWithObject:(id)jsonObj
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];
    if (error) return @"";
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)jsonObjWithJsonString:(NSString *)jsonStr
{
    return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
}

- (BOOL)existInDB
{
    HZModelMeta *meta = [[self class] meta];
    NSString *tableName = meta.tableName;
    
    NSInteger count = [HZDBManager longForQuery:[NSString stringWithFormat:@"select count(*) from %@ where %@",tableName, [self wherePKWithMeta:meta]]];
    
    return count>0?YES:NO;
}


+ (HZModelMeta *)meta
{
    return [[HZModelMeta alloc] initWithClass:[self class]];
}


@end
