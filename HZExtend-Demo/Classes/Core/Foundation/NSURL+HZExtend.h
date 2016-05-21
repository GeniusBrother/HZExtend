//
//  NSURL+HZExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSURL (HZExtend)

- (NSDictionary *)queryDic;

+ (BOOL)URLIsValid:(NSString *)urlString;

@end
NS_ASSUME_NONNULL_END