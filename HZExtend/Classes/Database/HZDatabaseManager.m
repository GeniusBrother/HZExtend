//
//  HZDatabaseManager.m
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//

#import "HZDatabaseManager.h"
#import <FMDB/FMDB.h>
#import "NSObject+HZExtend.h"
#import "HZMacro.h"
#import "sqlite3.h"
@interface HZDatabaseManager ()

@property(nonatomic, strong) FMDatabase *database;

@end

@implementation HZDatabaseManager
#pragma mark - Initialization
singleton_m

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Private Method
- (BOOL)isOpen
{
    return [self.database goodConnection];
}

#pragma mark - Public Method
- (BOOL)open
{
    NSAssert(self.dbPath.isNoEmpty, @"请先设置db path ");
    
    return [self.database open];
}

- (BOOL)close
{
    return [self.database close];
}

- (BOOL)executeUpdate:(NSString *)sql withParams:(NSArray *)data
{
    if (![self isOpen])  {
        NSAssert(NO, @"请先打开数据库");
        return NO;
    }
    
    if (!sql.isNoEmpty) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return NO;
    }
    
    BOOL result = NO;
    if (data.isNoEmpty) {
        result = [self.database executeUpdate:sql withArgumentsInArray:data];
    }else {
        result = [self.database executeUpdate:sql];
    }
    
    if (!result) {
        HZLog(@"update 失败 错误信息-----%@",self.database.lastErrorMessage);
    }
    return result;
}

- (NSArray *)executeQuery:(NSString *)sql withParams:(NSArray *)data
{
    if (![self isOpen]) {
        NSAssert(NO, @"请先打开数据库");
        return nil;
    }
    if (!sql.isNoEmpty) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return nil;
    }
    
    FMResultSet *rs = nil;
    NSMutableArray *array = [NSMutableArray array];
    if (data.isNoEmpty) {
        rs = [self.database executeQuery:sql withArgumentsInArray:data];
    }else {
        rs = [self.database executeQuery:sql];
    }
    
    if (!rs) {
        HZLog(@"sql 查询失败:%@",self.database.lastErrorMessage);
        return nil;
    }
    
    while ([rs next]) {
        NSMutableDictionary *dic = (NSMutableDictionary *)rs.resultDictionary;
        if (dic.isNoEmpty) [array addObject:dic];
    }
    [rs close];
    
    return array;
}

- (NSArray *)executeStatement:(NSString *)sql flag:(BOOL)isReturn
{
    if (![self isOpen]) {
        NSAssert(NO, @"NSObject+HZModel,请先打开数据库");
        return nil;
    }
    
    if (!sql.isNoEmpty) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return nil;
    }
    
    NSMutableArray *array = nil;
    FMDBExecuteStatementsCallbackBlock blcok = nil;
    if (isReturn) {
        array = [NSMutableArray array];
        blcok = ^int(NSDictionary *resultsDictionary){
            [array addObject:resultsDictionary];
            return SQLITE_OK;
        };
    }
    BOOL result = [self.database executeStatements:sql withResultBlock:blcok];
    if (!result) {
        HZLog(@"sql 批处理失败:%@",self.database.lastErrorMessage);
        return nil;
    }
    
    return array;
}

- (long)longForQuery:(NSString *)sql
{
    if (![self isOpen]) {
        NSAssert(NO, @"NSObject+HZModel,请先打开数据库");
        return NSNotFound;
    }
    
    if (!sql.isNoEmpty) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return NSNotFound;
    }
    
    return [self.database longForQuery:sql];
}

- (NSUInteger)lastInsertRowId
{
    return (NSUInteger)[self.database lastInsertRowId];
}
@end
