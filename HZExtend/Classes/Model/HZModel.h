//
//  HzModel.h
//  ZHFramework
//
//  Created by xzh. on 15/8/11.
//  Copyright (c) 2015年 xzh. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MJExtension.h"

/****************     与数据库中的元组映射     ****************/

NS_ASSUME_NONNULL_BEGIN

@interface HZModel : NSObject

/**
 *  是否存在数据库中
 */
@property(nonatomic, assign, readonly) BOOL isInDB;

/**
 *  主键值,0表示不存在
 */
@property(nonatomic, assign, readonly) NSUInteger primaryKey;

/**
 *  dic->model
 */
+ (instancetype)modelWithDic:(NSDictionary<NSString *, id> *)dic;

+ (void)setupDBPath:(NSString *)dbPath;

/**
 *  数据库地址
 */
+ (NSString *)dbPath;

/**
 *  数据库基本操作
 */
+ (void)open;
+ (void)close;
+ (BOOL)excuteUpdate:(NSString *)sql withParams:(nullable NSArray *)data;
+ (nullable NSArray *)excuteQuery:(NSString *)sql withParams:(nullable NSArray *)data;
+ (long)longForQuery:(NSString *)sql;

+ (nullable NSArray *)excuteStatement:(NSString *)sql flag:(BOOL)isReturn;   //执行多条语句

/**
 *  元组操作
 */
- (void)safeSave;   //safe代表执行之前先open数据库，执行完毕后再close数据库
- (void)safeDelete;

+ (nullable instancetype)modelWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (nullable NSArray *)findByColumn:(NSString *)column value:(id)value;
+ (nullable NSArray *)findWithSql:(NSString *)sql withParameters:(nullable NSArray *)parameters;
+ (nullable NSArray *)findAll;

- (void)save;
- (void)deleteSelf;
+ (void)deleteAll;

/**
 *  删除数组中的全部元组
 */
+ (void)deleteWithArray:(NSArray *)array;

/**
 *  子类重写
 */
- (void)loadModel;  //init时调用
- (void)beforeSave;
- (void)afterSave;
- (void)beforeUpdateSelf;
- (void)afterUpdateSelf;
- (void)beforeDeleteSelf;
- (void)afterDeleteSelf;

@end

NS_ASSUME_NONNULL_END