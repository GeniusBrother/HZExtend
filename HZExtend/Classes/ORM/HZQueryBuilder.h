//
//  HZQueryBuilder.h
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 17/8/15.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HZModelMeta;
NS_ASSUME_NONNULL_BEGIN

/**
 it can be used for data queries.
 */
@interface HZQueryBuilder : NSObject

/**
 Creates and returns a query builder.
 
 @param meta The meta data of ORMModel.
 
 @return new instance of `HZQueryBuilder` with specified meta.
 */
+ (instancetype)queryBuilderWithMeta:(HZModelMeta *)meta;

/**
 Sets the fields to be queried.
 */
- (HZQueryBuilder *)select:(NSArray<NSString *> *)columns;

/**
 Sets the query clause.
 */
- (HZQueryBuilder *)selectRaw:(NSString *)raw;

/**
 Sets the query criteria.
 */
- (HZQueryBuilder *)where:(NSDictionary<NSString *, id> *)params;

/**
 Sets the where clause.
 */
- (HZQueryBuilder *)whereRaw:(NSString *)raw;

/**
 Sets the orderBy.
 */
- (HZQueryBuilder *)orderBy:(NSString *)column desc:(BOOL)desc;

/**
 Sets the groupBy.
 */
- (HZQueryBuilder *)groupBy:(NSString *)groupBy;

/**
 Sets the having.
 */
- (HZQueryBuilder *)having:(NSString *)raw;

/**
 Sets the join.
 */
- (HZQueryBuilder *)join:(NSString *)tableName
         withFirstColumn:(NSString *)firstColumn
                operator:(nullable NSString *)opera
            secondColumn:(NSString *)secondColumn;

/**
 Sets the offset.
 */
- (HZQueryBuilder *)skip:(NSInteger)skip;

/**
 Sets the count.
 */
- (HZQueryBuilder *)take:(NSInteger)take;

/**
 Returns the all eligible ORMModels.
 */
- (NSArray *)get;

/**
 Returns the first ORMModel matching the criteria.
 */
- (id)first;

@end

NS_ASSUME_NONNULL_END
