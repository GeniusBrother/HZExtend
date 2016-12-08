//
//  NSObject+HZModel.m
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//

#import "NSObject+HZModel.h"
#import "HZMacro.h"
#import "NSObject+HZExtend.h"

#import <objc/runtime.h>
#import "FMDB.h"
static const char kPrimaryKey = '\0';
static const char kIsInDBKey = '\0';

@interface NSObject ()

@property(nonatomic, assign) BOOL isInDB;
@property(nonatomic, assign) NSUInteger primaryKey;

@end

@implementation NSObject (HZModel)
#pragma mark - Initialization
+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    NSObject *model = [[[self alloc] init] mj_setKeyValues:dic];
    return model;
}

+ (instancetype)modelInDBWithKey:(NSString *)key value:(id)value
{
    if (!key.isNoEmpty || !value) return nil;
    
    NSObject * model = nil;
    if ([HZDBManager open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = ?",[self getTabelName],key];
        model = [[self findWithSql:sql withParameters:@[value]] firstObject];
        [HZDBManager close];
    }
    return model;
}

#pragma mark - Private Method
- (NSArray *)propertyValues
{
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *columnName in [[self class] getColumnNames].allValues) {
        id value = [self valueForKey:columnName];
        
        if (value != nil) {
            [values addObject:value];
        } else {
            [values addObject:[NSNull null]];
        }
    }
    return values;
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
    NSArray *propertyNames = [[self class] getColumnNames].allValues;
    NSDictionary *data = [self dictionaryWithValuesForKeys:propertyNames];
    if (!data.isNoEmpty) return NO;
    
    [self beforeUpdate];
    
    NSString *setValues = [[[data allKeys] componentsJoinedByString:@" = ?, "] stringByAppendingString:@" = ?"];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE primaryKey = ?", [[self class] getTabelName], setValues];
    NSArray *parameters = [[data allValues] arrayByAddingObject:@(self.primaryKey)];
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

- (BOOL)save
{
    if (!self.isInDB) {
        [self insert];
    }else {
        [self updateSelf];
    }
}

#pragma mark - Public Method
+ (BOOL)safeDeleteAll
{
    if ([HZDBManager open]) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", [self getTabelName]];
        BOOL rs = [HZDBManager executeUpdate:sql withParams:nil];
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

+ (BOOL)safeDeleteWithArray:(NSArray *)array
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

- (BOOL)safeSave
{
    if ([HZDBManager open]) {
        BOOL rs = [self save];
        [HZDBManager close];
        return rs;
    }
    
    return NO;
}

- (BOOL)safeDelete
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
        modelArray = [self mj_objectArrayWithKeyValuesArray:results];
        [modelArray setValue:[NSNumber numberWithBool:YES] forKey:@"isInDB"];
        [HZDBManager close];
    }

    return modelArray;
}

+ (NSArray *)findByColumn:(NSString *)column value:(id)value
{
    if (!column.isNoEmpty || value == nil) return nil;
    
    return [self findWithSql:[NSString stringWithFormat:@"SELECT * FROM %@ where %@ = ?",[self getTabelName],column] withParameters:@[value]];
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
+ (NSString *)getTabelName {}

+ (NSDictionary *)getColumnNames { return nil; }

#pragma mark - Property
- (BOOL)isInDB
{
    NSNumber *isInDB = objc_getAssociatedObject(self, &kIsInDBKey);
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
