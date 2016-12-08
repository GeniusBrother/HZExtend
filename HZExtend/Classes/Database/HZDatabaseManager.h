//
//  HZDatabaseManager.h
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//
/****************     操作数据库     ****************/

#import <Foundation/Foundation.h>
#import "HZSingleton.h"

#define HZDBManager [HZDatabaseManager sharedManager]

@interface HZDatabaseManager : NSObject
singleton_h(Manager)
//[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HZDatabase.db"];
/** 数据库存放路径 */
@property(nonatomic, copy) NSString *dbPath;

/**
 * 打开数据库
 *
 *  @return YES表示打开成功
 */
- (BOOL)open;

/**
 *  关闭数据库
 *
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
 *  执行除查询SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句,参数用?占位
 *  @param data 参数数组
 *
 *  @return 字典数组,若无任何结果返回nil
 */
- (nullable NSArray *)executeQuery:(NSString *)sql withParams:(nullable NSArray *)data;

/**
 *  执行除查询以外的SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句
 *  @param flag YES表示执行有返回值,NO表示无返回值
 *
 *  @return 字典数组,若无任何结果返回nil
 */
- (nullable NSArray *)executeStatement:(NSString *)sql flag:(BOOL)isReturn;

/**
 *  执行除查询数量的SQL语句
 *  需先使用‘open’来打开数据库
 *
 *	@param sql  sql语句
 *  @return 整形,查询的数量结果
 */
- (long)longForQuery:(NSString *)sql;

/**
 *	返回最近插入操作的Row ID
 */
- (NSUInteger)lastInsertRowId;
@end
