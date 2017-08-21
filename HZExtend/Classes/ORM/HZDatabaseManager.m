//
//  HZDatabaseManager.m
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 16/12/8.
//  Copyright (c) 2016 GeniusBrother. All rights reserved.
//

#import "HZDatabaseManager.h"
#import <FMDB/FMDB.h>
#import "sqlite3.h"
@interface HZDatabaseManager ()

@property(nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSRecursiveLock *threadLock;
@property(nonatomic, strong) FMDatabase *executingDB;

@end

@implementation HZDatabaseManager
#pragma mark - Initialization
static id _instance;
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return _instance;
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self setup];
        });
    }
    return self;
}

- (void)setup
{
    self.threadLock = [[NSRecursiveLock alloc] init];
}

#pragma mark - Private Method
- (void)inDatabase:(void (^)(FMDatabase *db))block
{
    if(!block) return;
    
    [self.threadLock lock];
    
    if (self.executingDB) {
        block(self.executingDB);
    }else {
        __weak typeof(self) weakSelf = self;
        [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            weakSelf.executingDB = db;
            block(db);
            weakSelf.executingDB = nil;
        }];
    }

    [self.threadLock unlock];
}

#pragma mark - Public Method
- (BOOL)executeUpdate:(NSString *)sql withParams:(NSArray *)data
{
    if (!([sql isKindOfClass:[NSString class]] && sql.length > 0)) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return NO;
    }
    
    __block BOOL result = NO;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            result = [db executeUpdate:sql withArgumentsInArray:data];
        }else {
            result = [db executeUpdate:sql];
        }
#if DEBUG
        if (!result) {
            NSLog(@"update 失败 错误信息-----%@",db.lastErrorMessage);
        }
#endif
    }];

    

    
    return result;
}

- (NSArray *)executeQuery:(NSString *)sql withParams:(NSArray *)data
{
    
    if (!([sql isKindOfClass:[NSString class]] && sql.length > 0)) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = nil;
        
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            rs = [db executeQuery:sql withArgumentsInArray:data];
        }else {
            rs = [db executeQuery:sql];
        }
        

        if (!rs) {
#if DEBUG
            NSLog(@"sql 查询失败:%@",db.lastErrorMessage);
#endif
        }else {
            while ([rs next]) {
                NSMutableDictionary *dic = (NSMutableDictionary *)rs.resultDictionary;
                if (dic) [array addObject:dic];
            }
            [rs close];
        }
    }];

    return array;
}

- (BOOL)executeStatements:(NSString *)sql withResultBlock:(HZDBExecuteStatementsCallbackBlock)block
{

    if (!([sql isKindOfClass:[NSString class]] && sql.length > 0)) {
        NSAssert(NO, @"%s SQL语句为空",__FUNCTION__);
        return NO;
    }

    __block BOOL result = NO;
    [self inDatabase:^(FMDatabase * _Nonnull db) {
        result = [db executeStatements:sql withResultBlock:block];
    }];
    
    return result;
}

- (void)close
{
    [self.dbQueue close];
}

- (void)beginTransactionWithBlock:(BOOL (^)(HZDatabaseManager * _Nonnull obj))block
{
    if (!block) return;

    __weak HZDatabaseManager *weakSelf = self;
    [self inDatabase:^(FMDatabase *db) {
        [db beginTransaction];
        BOOL rs = block(weakSelf);
        if (rs) {
            [db commit];
        }else {
            [db rollback];
        }
    }];

}

- (double)doubleForQuery:(NSString *)sql
{
    __block double value = MAXFLOAT;
    [self inDatabase:^(FMDatabase *db) {
        value = [db doubleForQuery:sql];
    }];
    
    return value;
}

- (long)longForQuery:(NSString *)sql
{
    __block long value = NSNotFound;
    [self inDatabase:^(FMDatabase *db) {
        value = [db longForQuery:sql];
    }];
    return value;
}

- (NSString *)stringForQuery:(NSString *)sql
{
    __block NSString *value = nil;
    [self inDatabase:^(FMDatabase *db) {
        value = [db stringForQuery:sql];
    }];
    return value;
}

- (int)intForQuery:(NSString *)sql
{
    __block int value = 0;
    [self inDatabase:^(FMDatabase *db) {
        value = [db intForQuery:sql];
    }];
    return value;
}

- (int64_t)lastInsertRowId
{
    __block int64_t rowId = NSNotFound;
    [self inDatabase:^(FMDatabase *db) {
        rowId = [db lastInsertRowId];
    }];
    
    return rowId;
}

#pragma mark - Setter
- (void)setDbPath:(NSString *)dbPath
{
    if (([dbPath isKindOfClass:[NSString class]] && dbPath.length > 0) && ![dbPath isEqualToString:_dbPath]) {
        
        [self.dbQueue close];
        
        NSString *directory = [dbPath stringByDeletingLastPathComponent];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:directory]) {
            NSError *error;
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    _dbPath = dbPath;
}

@end
