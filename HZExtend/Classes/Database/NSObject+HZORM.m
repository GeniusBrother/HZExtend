//
//  NSObject+HZModel.m
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//

#import "NSObject+HZORM.h"
#import "HZMacro.h"
#import "NSObject+HZExtend.h"
#import "NSDictionary+HZExtend.h"
#import "NSArray+HZExtend.h"

#import <objc/runtime.h>
#import "FMDB.h"
static const char kPrimaryKey = '\0';
static const char kIsInDBKey = '\0';
NSString *const kPrimaryKeyName = @"primaryKey";
@interface NSObject ()

@property(nonatomic, assign) BOOL isInDB;

@end

@implementation NSObject (HZORM)
#pragma mark - Initialization
+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    NSObject *model = [[[self alloc] init] mj_setKeyValues:dic];
    return model;
}

+ (instancetype)modelInDBWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values
{
    return [[self findByColumns:keys values:values] firstObject];
}

#pragma mark - Private Method
- (NSArray *)propertyValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *propertyName in [[self class] getColumnNames].allValues) {
        id value = [self workedValueForPropertyName:propertyName];
        
        if (value != nil) {
            [values addObject:value];
        } else {
            [values addObject:[NSNull null]];
        }
    }
    return values;
}

- (id)workedValueForPropertyName:(NSString *)name
{
    id originalValue = [self valueForKey:name];
    
    if (!originalValue) return [NSNull null];
    
    if ([originalValue isKindOfClass:[NSArray class]]) {
        return [(NSArray *)originalValue jsonString];
    }else if ([originalValue isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)originalValue jsonString];
    }else {
        
        id obj = [originalValue mj_keyValues];
        if ([obj isKindOfClass:[NSDictionary class]]) { //判断是否为模型类型
            return [(NSDictionary *)obj jsonString];
        }
        return originalValue;
    }
}

- (BOOL)insert
{
    NSArray *columnsWithoutPK = [[self class] getColumnNames].allKeys;
    if (!columnsWithoutPK.isNoEmpty) {
        NSAssert(NO, @"请实现getColumnNames 指定列名");
        return NO;
    }
    
    NSString *tableName = [[self class] getTabelName];
    if (!tableName.isNoEmpty) {
        NSAssert(NO, @"请实现getTabelName 指定表名");
        return NO;
    }
    
    [self beforeInsert];
    
    NSMutableArray *parameterList = [NSMutableArray arrayWithCapacity:columnsWithoutPK.count];
    for (int i=0; i<[columnsWithoutPK count]; i++) {
        [parameterList addObject:@"?"]; //@[?,?];
    }
    
    //将2个数组拼接成字符串,并组合成sql
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)", tableName, [columnsWithoutPK componentsJoinedByString:@","], [parameterList componentsJoinedByString:@","]];
    
    if ([HZDBManager executeUpdate:sql withParams:[self propertyValues]]) {
        self.isInDB = YES;
        self.primaryKey = [HZDBManager lastInsertRowId];
        
        [self sucessInsert];
        return YES;
    }
    
    return NO;
}

- (BOOL)updateSelf
{
    NSDictionary *columnPropertyDic = [[self class] getColumnNames];
    if (!columnPropertyDic.isNoEmpty) {
        NSAssert(NO, @"请实现getColumnNames 指定列名");
        return NO;
    }
    
    [self beforeUpdate];
    
    __block NSMutableString *setValues = [NSMutableString string];
    __block NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:columnPropertyDic.count];
    [columnPropertyDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull column, NSString  *_Nonnull property, BOOL * _Nonnull stop) {
        [setValues appendFormat:@"%@ = ?,",column];
        id data = [self workedValueForPropertyName:property];
        if (data) [parameters addObject:data];
    }];
    [setValues deleteCharactersInRange:NSMakeRange(setValues.length - 1, 1)];
    [parameters addObject:@(self.primaryKey)];
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE primaryKey = ?", [[self class] getTabelName], setValues];
    if ([HZDBManager executeUpdate:sql withParams:parameters]) {
        
        [self sucessUpdate];
        return YES;
    }
    return NO;
}

- (BOOL)deleteSelf
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE primaryKey = ?", [[self class]getTabelName]];
    if ([HZDBManager executeUpdate:sql withParams:@[@(self.primaryKey)]]) {
        self.isInDB = NO;
        self.primaryKey = 0;
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)whereStrWithKeys:(NSArray *)keys values:(NSArray *)values
{
    NSMutableString *str = [NSMutableString stringWithString:@"where "];
    for (int i=0; i<[values count]; i++) {
        NSString *key = [keys objectAtSafeIndex:i];
        [str appendFormat:@"%@=? AND ",key];
    }
    
    [str deleteCharactersInRange:NSMakeRange(str.length-4, 4)];
    return str;
}


#pragma mark - Public Method
+ (NSInteger)modelExistDBWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values
{
    if (!keys.isNoEmpty || !values) return NO;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select primaryKey from %@ %@",[self getTabelName],[self whereStrWithKeys:keys values:values]];
    NSObject *obj = [[[self class] findWithSql:sql withParameters:values] firstObject];
    return obj.primaryKey;
}

- (BOOL)checkExistWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values
{
    NSInteger key = [[self class] modelExistDBWithKeys:keys values:values];
    BOOL rs = NO;
    if (key) {
        self.isInDB = rs = YES;
        self.primaryKey = key;
    }
    
    return rs;
}

- (BOOL)save
{
    BOOL rs = NO;
    if ([HZDBManager open]) {
        
        if (!self.isInDB) {
            rs = [self insert];
        }else {
            rs = [self updateSelf];
        }
        [HZDBManager close];
        return rs;
    }
    return NO;
}

+ (BOOL)deleteWithKeys:(NSArray <NSString *> *)keys values:(NSArray *)values
{
    if (!keys.isNoEmpty || !values.isNoEmpty) return NO;
    if ([HZDBManager open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", [self getTabelName],[self whereStrWithKeys:keys values:values]];
        BOOL rs = [HZDBManager executeUpdate:sql withParams:values];
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

+ (BOOL)deleteAll
{
    if ([HZDBManager open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self getTabelName]];
        BOOL rs = [HZDBManager executeUpdate:sql withParams:nil];
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

+ (BOOL)saveArray:(NSArray *)modelArray
{
    if (!modelArray.isNoEmpty) return NO;
    
    if ([HZDBManager open]) {
        [HZDBManager beginTransactionWithBlock:^BOOL(HZDatabaseManager * _Nonnull db) {
            for (NSObject *obj in modelArray) {
                if (![obj save]) {
                    return NO;
                }
            }
            return YES;
        }];

        [HZDBManager close];
        return YES;
    }
    
    return NO;
}

+ (BOOL)deleteWithArray:(NSArray *)array
{
    if (!array.isNoEmpty) return NO;
    
    if ([HZDBManager open]) {
        NSMutableString *collection = [NSMutableString stringWithString:@"("];
        for (NSObject *model in array) {
            [collection appendFormat:@"%lu,",(unsigned long)model.primaryKey];
        }
        [collection deleteCharactersInRange:NSMakeRange(collection.length-1, 1)];
        [collection appendString:@")"];
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where primaryKey in %@",[self getTabelName],collection];
        BOOL rs = NO;
        if ([HZDBManager executeUpdate:sql withParams:nil]) {
            [array setValue:@0 forKey:@"primaryKey"];
            [array setValue:@(NO) forKey:@"isInDB"];
            rs =  YES;
        }
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

- (BOOL)delete
{
    if ([HZDBManager open]) {
        BOOL rs = [self deleteSelf];
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

+ (NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters
{
    NSArray *modelArray = nil;
    if ([HZDBManager open]) {
        NSArray *results= [HZDBManager executeQuery:sql withParams:parameters];
        NSMutableArray *objArray = [NSMutableArray arrayWithCapacity:results.count];
        NSDictionary *columnPropertyDic = [self getColumnNames];
        [results enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull json, NSUInteger idx, BOOL * _Nonnull stop) {
            NSObject *obj = [[self alloc] init];
            [json enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull columnName, id  _Nonnull value, BOOL * _Nonnull stop) {
                if ([columnName isEqualToString:kPrimaryKeyName]) {
                    [obj setValue:value forKey:columnName];
                }else {
                    NSString *propertyName = [columnPropertyDic objectForKey:columnName];
                    if (propertyName.isNoEmpty) {
                        id convertedValue =  [self getNewValueForProperty:propertyName withOriginValue:value];
                        NSAssert(convertedValue, @"HZORM 装换的值不能为nil");
                        if (convertedValue && ![convertedValue isKindOfClass:[NSNull class]]) [obj setValue:convertedValue forKey:propertyName];
                    }
                }
            }];
            [obj setValue:@(YES) forKey:@"isInDB"];
            [objArray addObject:obj];
        }];
        modelArray = objArray;
        [HZDBManager close];
    }

    return modelArray;
}



+ (NSArray *)findByColumns:(NSArray *)columns values:(NSArray *)values
{
    if (!columns.isNoEmpty || !values.isNoEmpty) return nil;
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ %@",[self getTabelName],[self whereStrWithKeys:columns values:values]];

    
    return [self findWithSql:sql withParameters:values];
}

+ (NSArray *)findAll
{
    return [self findWithSql:[NSString stringWithFormat:@"SELECT * FROM %@", [self getTabelName]] withParameters:nil];
}

#pragma mark - CallBack
- (void)beforeInsert {}
- (void)sucessInsert {}
- (void)beforeUpdate {}
- (void)sucessUpdate {}
- (void)beforeDelete {}
- (void)sucessDelete {}

#pragma mark - Override
+ (NSString *)getTabelName { return @"";}

+ (NSDictionary *)getColumnNames { return nil; }

+ (id)getNewValueForProperty:(NSString *)name withOriginValue:(id)originValue { return originValue; }

+ (NSArray *)getUniqueKeys { return nil; }

#pragma mark - Property
- (BOOL)isInDB
{
    NSNumber *isInDB = objc_getAssociatedObject(self, &kIsInDBKey);
    if (!isInDB) {
        NSArray *keys = [[self class] getUniqueKeys];
        if (keys.isNoEmpty) {
            NSMutableArray *values = [NSMutableArray arrayWithCapacity:keys.count];
            NSDictionary *columnPropertDic = [[self class] getColumnNames];
            [keys enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *property = [columnPropertDic objectForKey:obj];
                id value = [self valueForKey:property];
                if (value) [values addObject:value];
            }];
            
            return [self checkExistWithKeys:keys values:values];
        }
    }
    return [isInDB boolValue];
}

- (void)setIsInDB:(BOOL)isInDB
{
    [self willChangeValueForKey:@"isInDB"];
    objc_setAssociatedObject(self, &kIsInDBKey, @(isInDB), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"isInDB"];
}

- (NSUInteger)primaryKey
{
    NSNumber *primaryKey = objc_getAssociatedObject(self, &kPrimaryKey);
    return [primaryKey unsignedIntegerValue];
}

- (void)setPrimaryKey:(NSUInteger)primaryKey
{
    [self willChangeValueForKey:@"primaryKey"];
    objc_setAssociatedObject(self, &kPrimaryKey, @(primaryKey), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"primaryKey"];
}

@end
