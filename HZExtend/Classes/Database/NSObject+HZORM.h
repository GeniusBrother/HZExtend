//
//  NSObject+HZORM.h
//  Pods
//
//  Created by xzh on 2016/12/8.
//
//

/****************     进行ORM操作     ****************/

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "HZDatabaseManager.h"
#define PROPERTY_NANME_FOR_KEY(KEY) NSStringFromSelector(@selector(KEY))

NS_ASSUME_NONNULL_BEGIN
extern NSString *const kPrimaryKeyName;

@interface NSObject (HZORM)
#pragma mark - Property
/** 是否存在数据库中 */
@property(nonatomic, assign, readonly) BOOL isInDB;

/** 主键值,0表示不存在 */
@property(nonatomic, assign, readonly) NSUInteger primaryKey;

#pragma mark - Initialization
/**
 *	创建模型
 *
 *	@param dic  json数据
 *
 *  @return 模型
 */
+ (instancetype)modelWithDic:(NSDictionary<NSString *, id> *)dic;

/**
 *	从数据库加载模型
 *
 *	@param key  查找模型所用到的字段
 *  @param value 字段所对应的值
 *
 *  @return 模型
 */
+ (instancetype)modelInDBWithKey:(NSString *)key value:(id)value;

#pragma mark - ORM操作
/**
 *  保存数据到数据库
 *  如果数据库已经存在则更新
 */
- (BOOL)save;

/**
 *  从数据库删除自身这条数据
 */
- (BOOL)delete;

/**
 *	从数据库删除该表下的全部数据
 */
+ (BOOL)deleteAll;

/**
 *  删除数组中的全部元组
 */
+ (BOOL)deleteWithArray:(NSArray *)array;

/**
 *	查找数据模型
 *
 *	@param column  作为查询条件的属性名
 *  @param value  作为查询条件的属性值
 *
 *  @return 数据模型数组,无结果返回nil
 */
+ (nullable NSArray *)findByColumn:(NSString *)column value:(id)value;

/**
 *	查找数据模型
 *
 *	@param sql  查找sql语句,参数用?占位
 *  @param parameters  参数数组
 *
 *  @return 数据模型数组,无结果返回nil
 */
+ (nullable NSArray *)findWithSql:(NSString *)sql withParameters:(nullable NSArray *)parameters;

/**
 *	查找该表下的所有数据模型
 *
 *  @return 数据模型数组,无结果返回nil
 */
+ (nullable NSArray *)findAll;


#pragma mark - CallBack
/**
 *  向数据库插入数据之前调用
 */
- (void)beforeInsert;

/**
 *  向数据库插入数据后调用
 */
- (void)sucessInsert;

/**
 *  向数据库更新数据之前调用
 */
- (void)beforeUpdate;

/**
 *  向数据库更新数据后调用
 */
- (void)sucessUpdate;

/**
 *  从数据库删除数据之前调用
 */
- (void)beforeDelete;

/**
 *  从数据库删除数据后调用
 */
- (void)sucessDelete;

#pragma mark - Override
//子类重写该方法来返回相应的数据
/**
 *  子类重写该方法来返回表名
 */
+ (NSString *)getTabelName;

/**
 *  子类重写该方法来返回属性与列名的映射关系
 */
+ (NSDictionary<NSString *, NSString *> *)getColumnNames;

/**
 *	子类重写该方法对映射值进行处理然后再返回赋给属性
 *  默认实现为返回原值,可以对数据进行处理在设置给属性,如将json字符串转出json对象再返回
 */
+ (id)convertedValueForPropertyName:(NSString *)name value:(id)value;


@end

NS_ASSUME_NONNULL_END
