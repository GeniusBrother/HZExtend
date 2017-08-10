//
//  HZNetworkCache.h
//  HZNetwork
//
//  Created by xzh. on 2017/8/7.
//  Copyright (c) 2017年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZNetworkCache <NSObject>

- (void)setCache:(id)cache forKey:(NSString *)key;

- (id)cacheForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
