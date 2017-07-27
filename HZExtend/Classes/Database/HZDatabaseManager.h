//
//  HZDatabaseManager.h
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//
/****************     操作和管理APP数据库     ****************/

#import <Foundation/Foundation.h>
#import "HZSingleton.h"

#define HZDBManager [HZDatabaseManager sharedManager]

NS_ASSUME_NONNULL_BEGIN

typedef int(^HZDBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);


@interface HZDatabaseManager : NSObject
singleton_h(Manager)

/** 数据库存放路径 */
@property(nonatomic, copy, nullable) NSString *dbPath;

/**
 *  是否由receiver来管理连接
 *  默认为YES,在app活跃的生命周期则会一直保持连接,进入后台后会释放连接
 */
@property(nonatomic, assign) BOOL shouldControlConnection;

/**
 * 打开数据库
 *
 *  @return YES表示打开成功
 */
- (BOOL)open;

/**
 *  关闭数据库
 *  如果shouldControlConnection = YES,则会不起作用
 *  @return YES表示打开成功
 */
- (BOOL)close;

/**
 *  执行除查询以外的SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句,参数用?占位
 *  @param data 参数数组
 *
 *  @return YES表示执行成功
 */
- (BOOL)executeUpdate:(NSString *)sql withParams:(nullable NSArray *)data;

/**
 *  执行查询SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句,参数用?占位
 *  @param data 参数数组
 *
 *  @return 字典数组,若无任何结果返回nil
 */
- (nullable NSArray *)executeQuery:(NSString *)sql withParams:(nullable NSArray *)data;

/**
 *  批处理
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句
 *  @param block 如果有结果返回时被调用,如果数据正确返回SQLITE_OK继续执行,返回其它则停止执行
 *
 *  @return BOOL,返回YES,表示成功执行
 */
- (BOOL)executeStatements:(NSString *)sql withResultBlock:(nullable HZDBExecuteStatementsCallbackBlock)block;

/**
 *	执行事务操作
 *
 *	@param completion  操作成功返回YES，进行提交，返回NO进行回滚
 */
- (void)beginTransactionWithBlock:(BOOL(^)(HZDatabaseManager *db))completion;

/**
 *  执行返回结果为long的SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句
 *  @return 一个整形值
 */
- (long)longForQuery:(NSString *)sql;

/**
 *  执行返回结果为double的sql语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句
 *  @return 一个double值,
 */
- (double)doubleForQuery:(NSString *)sql;

/**
 *	返回Row ID
 */
- (NSUInteger)lastInsertRowId;

@end

NS_ASSUME_NONNULL_END
