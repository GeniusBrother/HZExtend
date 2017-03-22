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
#define PROPERTY_NANME_FOR_PROPERTY(PROPERTY) NSStringFromSelector(@selector(PROPERTY))

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
 *	@param keys  查找模型所用到的字段数组
 *  @param values 字段所对应的值数组，顺序保持一致
 *
 *  @return 模型
 */
+ (instancetype)modelInDBWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values;

#pragma mark - ORM操作
/**
 *  创建模型时调用,检查是否已经存在在数据库
 *  若已经存在在数据库,则更新isInDB&primaryKey值
 *
 *  @param keys  判断唯一性属性名称,如果该字段值相同,则认为为同一条数据
 *  @param values 属性所对应的值，与属性顺序保持一致
 */
- (BOOL)checkExistWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values;

/**
 *  判断模型是否存在于数据库,若存在返回自增主键值
 *
 *  @param keys  判断唯一性属性名称,如果该字段值相同,则认为为同一条数据
 *  @param values 属性所对应的值，与属性顺序保持一致
 */
+ (NSInteger)modelExistDBWithKeys:(NSArray<NSString *> *)keys values:(NSArray *)values;

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

+ (BOOL)saveArray:(NSArray *)modelArray;

/**
 *  删除数组中的全部元组
 */
+ (BOOL)deleteWithArray:(NSArray *)array;

/**
 *  根据值删除元组
 */
+ (BOOL)deleteWithKeys:(NSArray <NSString *> *)keys values:(NSArray *)values;

/**
 *	查找数据模型
 *
 *	@param column  作为查询条件的属性名
 *  @param value  作为查询条件的属性值
 *
 *  @return 数据模型数组,无结果返回nil
 */
+ (nullable NSArray *)findByColumns:(NSArray *)columns values:(NSArray *)values;

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
 *  子类实现该方法来返回表名
 */
+ (NSString *)getTabelName;

/**
 *  子类实现该方法来返回列名属性的映射关系
 */
+ (NSDictionary<NSString *, NSString *> *)getColumnNames;

/**
 *  子类实现该方法来返回标识数据唯一性的列名
 */
+ (NSArray *)getUniqueKeys;

/**
 *	子类实现该方法对数据库值进行处理,然后在将新值赋给属性
 *  默认实现为返回原值
 *
 *	@param name 属性名
 *  @param originValue  原始数据库值
 *
 *  @return id,处理后的新值
 */
+ (id)getNewValueForProperty:(NSString *)name withOriginValue:(id)originValue;


@end

NS_ASSUME_NONNULL_END
