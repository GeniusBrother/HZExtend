//
//  NSObject+HZORM.h
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 16/12/8.
//  Copyright (c) 2016 GeniusBrother. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "HZDatabaseManager.h"
#import "HZQueryBuilder.h"

@class HZModelMeta;

NS_ASSUME_NONNULL_BEGIN

/**
 `HZORM` is a thread safe implementation of ActiveRecord. Each database table has a corresponding "ORMModel" which is used to interact with that table. Models allow you to query for data in your tables, as well as insert new records into the table. 
 
 Before getting started, you should implement the methods in NSObject+HZORMModel.h to provide the structure of table.
 */
@interface NSObject (HZORM)

/**
 Retrieves a model by its primary key.
 
 @param pk The value of primary key.
 @return A ORM Model.
 */
+ (nullable instancetype)find:(id)pk;

/**
 Returns the first record matching the attributes, or nil if don't match.
 
 @param keyValues The attributes.
 */
+ (nullable instancetype)firstWithKeyValues:(NSDictionary *)keyValues;

/**
 Saves the model to the database.
 
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)save;

/**
 Updates the model in the database.
 
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)update;

/**
 Deletes the model from the database.
 
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)remove;

/**
 Deletes the all models in table from the database.
 
 @return `YES` upon success; `NO` upon failure.
 */
+ (BOOL)remove;

/**
 Deletes the models for the given pks.
 
 @param pks Array containing primary key of models.
 
 @return `YES` upon success; `NO` upon failure.
 */
+ (BOOL)remove:(NSArray *)pks;

/**
 Inserts the models to the database.
 
 @param models The ORM Models.
 @return `YES` upon success; `NO` upon failure.
 */
+ (BOOL)insert:(NSArray *)models;

/**
 Returns the all ORM models in table, or nil if don't exists any ORM models for receiver.
 */
+ (nullable NSArray *)all;

/**
 Querys ORM Models with specified columns.
 
 @discussion `*` reprensents the all columns in table.
 
 @param columns The names of column.
 
 @return A query constructor that can be used for data queries. see `HZQueryBuilder` for more info.
 */
+ (HZQueryBuilder *)search:(NSArray *)columns;

/**
 Querys ORM Models with specified sql statement.

 @param raw Sql statement.
 
 @return A query constructor that can be used for data queries. see `HZQueryBuilder` for more info.
 */
+ (HZQueryBuilder *)searchRaw:(NSString *)raw;

/**
 Querys ORM Models with specified sql statement and meta of ORMModel.
 
 @param raw Sql statement.
 @param meta The meta data of ORMModel
 
 @return The all eligible ORMModels.
 */
+ (nullable NSArray *)findWithSql:(NSString *)sql withMeta:(HZModelMeta *)meta;


@end

NS_ASSUME_NONNULL_END
