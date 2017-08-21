//
//  HZModelMeta.h
//  HZORM <https://github.com/GeniusBrother/HZORM>
//
//  Created by GeniusBrother on 17/8/15.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 存储ORM模型元数据
 */
@interface HZModelMeta : NSObject

- (instancetype)initWithClass:(Class)cla;

@property(nonatomic, readonly) Class cla;

@property(nonatomic, readonly) NSString *tableName;

@property(nonatomic, readonly) NSDictionary<NSString *, NSString *> *casts;

@property(nonatomic, readonly) NSDictionary<NSString *, NSString *> *columnMap;

@property(nonatomic, readonly) NSArray<NSString *> *primaryKeys;

@property(nonatomic, readonly) BOOL incrementing;

@end
